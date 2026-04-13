//
//  ModdedUIMenu.swift
//  Playgrounds
//
//  Created by Kengo Tate on 2026/04/12.
//

import SwiftUI
import UIKit
import Combine

struct ModdedUIMenuView: View {
    var body: some View {
        ModdedUIMenuViewControllerRepresentable()
            .navigationTitle("Modded UIMenu")
            .navigationBarTitleDisplayMode(.inline)
    }
}

@MainActor
private final class ModdedUIMenuConfiguration: ObservableObject {
    @Published var prefersNavBarAnchoredShareSheet = true
}

private struct ModdedUIMenuViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ModdedUIMenuViewController {
        ModdedUIMenuViewController()
    }

    func updateUIViewController(_ uiViewController: ModdedUIMenuViewController, context: Context) {
    }
}

@MainActor
private final class ModdedUIMenuViewController: UIViewController {
    private let actions = MenuAction.sampleActions
    private var hasConfiguredNavigationItem = false
    private let shareURL = URL(string: "https://github.com/Private-Playgrounds/Try-Swift-Playgrounds")!
    private let shareSheetPopoverDelegate = ShareSheetPopoverDelegate()
    private let configuration = ModdedUIMenuConfiguration()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        configureContent()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationItem()
    }

    private func configureContent() {
        let hostingController = UIHostingController(rootView: ModdedUIMenuBodyView(configuration: configuration))
        addChild(hostingController)

        let hostedView = hostingController.view!
        hostedView.translatesAutoresizingMaskIntoConstraints = false
        hostedView.backgroundColor = .clear
        view.addSubview(hostedView)

        NSLayoutConstraint.activate([
            hostedView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            hostedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostedView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        hostingController.didMove(toParent: self)
    }

    private func configureNavigationItem() {
        guard !hasConfiguredNavigationItem else {
            return
        }

        guard let parent else {
            return
        }

        hasConfiguredNavigationItem = true
        let targetNavigationItem = parent.navigationItem
        targetNavigationItem.titleMenuProvider = { [weak self, actions] _ in
            guard let self else {
                return UIMenu(title: "", children: [])
            }
            let children = actions.map { $0.menuElement(owner: self) }
            let menu = UIMenu(title: "", children: children)
            menu.headerViewProvider = { [weak self] in
                MenuHeaderView(
                    frame: CGRect(x: 0, y: 0, width: 0, height: 84),
                    onShareTap: { sourceView, sourceRect in
                        self?.presentShareSheet(from: sourceView, sourceRect: sourceRect)
                    }
                )
            }
            return menu
        }
    }

    fileprivate func presentShareSheet(from sourceView: UIView? = nil, sourceRect: CGRect? = nil) {
        let presenter = parent ?? self
        let anchorRect = anchorRectInPresenter(sourceView: sourceView, sourceRect: sourceRect, presenter: presenter)

        dismissVisibleTitleMenuIfNeeded(from: presenter) { [weak self] in
            self?.presentShareSheetNow(anchorRect: anchorRect)
        }
    }

    private func presentShareSheetNow(anchorRect: CGRect?) {
        let presenter = parent ?? self
        guard presenter.presentedViewController == nil else {
            return
        }

        let activityViewController = UIActivityViewController(
            activityItems: [shareURL],
            applicationActivities: nil
        )

        guard configuration.prefersNavBarAnchoredShareSheet else {
            presenter.present(activityViewController, animated: true)
            return
        }

        activityViewController.setValue(true, forKey: "allowsCustomPresentationStyle")
        activityViewController.modalPresentationStyle = .popover
        let sourceRect = anchorRect ?? CGRect(
            x: presenter.view.bounds.midX,
            y: presenter.view.bounds.midY,
            width: 1,
            height: 1
        )
        if let popoverPresentationController = activityViewController.popoverPresentationController {
            forcePopoverPresentationsIfAvailable()
            popoverPresentationController.delegate = shareSheetPopoverDelegate
            popoverPresentationController.permittedArrowDirections = .up
            popoverPresentationController.canOverlapSourceViewRect = true
            popoverPresentationController.popoverLayoutMargins = UIEdgeInsets(top: 8, left: 12, bottom: 12, right: 12)
            invokePrivateSetter("_setAdaptivityEnabled:", bool: false, on: popoverPresentationController)
            invokePrivateSetter("_setShouldHideArrow:", bool: true, on: popoverPresentationController)
            if let preferredSourceItem = preferredTitleMenuPresentationSourceItem() {
                popoverPresentationController.sourceItem = preferredSourceItem
            } else if let titleControl = titleMenuControl(in: presenter) {
                popoverPresentationController.sourceView = presenter.view
                popoverPresentationController.sourceRect = presenter.view.convert(titleControl.bounds, from: titleControl)
            } else {
                popoverPresentationController.sourceView = presenter.view
                popoverPresentationController.sourceRect = sourceRect
            }
        }
        presenter.present(activityViewController, animated: true)
    }

    private func forcePopoverPresentationsIfAvailable() {
        let selector = NSSelectorFromString("_setAlwaysAllowPopoverPresentations:")
        _ = (UIPopoverPresentationController.self as AnyObject).perform(selector, with: NSNumber(value: true))
    }

    private func invokePrivateSetter(_ selectorName: String, bool value: Bool, on object: NSObject) {
        let selector = NSSelectorFromString(selectorName)
        _ = object.perform(selector, with: NSNumber(value: value))
    }

    private func dismissVisibleTitleMenuIfNeeded(from presenter: UIViewController, completion: @escaping () -> Void) {
        if
            let interaction = activeContextMenuInteraction(),
            let presentation = interaction.outgoingPresentation
        {
            presentation.addDismissalCompletion(completion)
            interaction.dismissPrivateMenu()
            return
        }

        guard let presentedViewController = presenter.presentedViewController else {
            completion()
            return
        }

        let presentedClassName = NSStringFromClass(type(of: presentedViewController))
        guard presentedClassName.contains("_UIContextMenu") else {
            completion()
            return
        }

        presentedViewController.dismiss(animated: true, completion: completion)
    }

    private func anchorRectInPresenter(sourceView: UIView?, sourceRect: CGRect?, presenter: UIViewController) -> CGRect? {
        guard let sourceView, let sourceRect else {
            return nil
        }
        if sourceView.window === presenter.view.window {
            return presenter.view.convert(sourceRect, from: sourceView)
        }

        guard let window = sourceView.window else {
            return nil
        }

        let sourceRectInWindow = sourceView.convert(sourceRect, to: window)
        return presenter.view.convert(sourceRectInWindow, from: window)
    }

    private func preferredTitleMenuPresentationSourceItem() -> (any UIPopoverPresentationControllerSourceItem)? {
        guard let titleControl = titleMenuControl(in: parent ?? self) else {
            return nil
        }

        let selector = NSSelectorFromString("_preferredPresentationSourceItem")
        guard
            titleControl.responds(to: selector),
            let sourceItem = titleControl.perform(selector)?.takeUnretainedValue()
        else {
            return nil
        }

        return sourceItem as? any UIPopoverPresentationControllerSourceItem
    }

    private func titleMenuControl(in presenter: UIViewController) -> UIView? {
        guard let navigationBar = presenter.navigationController?.navigationBar else {
            return nil
        }

        return firstSubview(in: navigationBar) { view in
            NSStringFromClass(type(of: view)).contains("_UINavigationBarTitleControl")
        }
    }

    private func firstSubview(in root: UIView, where predicate: (UIView) -> Bool) -> UIView? {
        if predicate(root) {
            return root
        }
        for subview in root.subviews {
            if let match = firstSubview(in: subview, where: predicate) {
                return match
            }
        }

        return nil
    }

    private func activeContextMenuInteraction() -> UIContextMenuInteraction? {
        guard let navigationBar = parent?.navigationController?.navigationBar else {
            return nil
        }

        return firstContextMenuInteraction(in: navigationBar)
    }

    private func firstContextMenuInteraction(in view: UIView) -> UIContextMenuInteraction? {
        for interaction in view.interactions {
            guard let contextMenuInteraction = interaction as? UIContextMenuInteraction else {
                continue
            }
            if contextMenuInteraction.hasVisiblePrivateMenu {
                return contextMenuInteraction
            }
        }

        for subview in view.subviews {
            if let interaction = firstContextMenuInteraction(in: subview) {
                return interaction
            }
        }

        return nil
    }
}

@MainActor
private final class ShareSheetPopoverDelegate: NSObject, UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        .none
    }

    func adaptivePresentationStyle(
        for controller: UIPresentationController,
        traitCollection: UITraitCollection
    ) -> UIModalPresentationStyle {
        .none
    }
}

private extension UIMenu {
    typealias HeaderViewProvider = UIMenuHeaderViewProvider
}

private extension UIContextMenuInteraction {
    var hasVisiblePrivateMenu: Bool {
        _hasVisibleMenu
    }

    func dismissPrivateMenu() {
        dismissMenu()
    }
}

private struct MenuAction {
    let title: String
    let systemImage: String
    let makeElement: (_ owner: ModdedUIMenuViewController) -> UIMenuElement

    func menuElement(owner: ModdedUIMenuViewController) -> UIMenuElement {
        makeElement(owner)
    }

    static let sampleActions: [MenuAction] = [
        MenuAction(title: "Share Repository", systemImage: "square.and.arrow.up") { owner in
            UIAction(title: "Share Repository", image: UIImage(systemName: "square.and.arrow.up")) { _ in
                owner.presentShareSheet()
            }
        },
        MenuAction(title: "Action 1", systemImage: "star") { _ in
            UIAction(title: "Action 1", image: UIImage(systemName: "star")) { _ in }
        },
        MenuAction(title: "Action 2", systemImage: "heart") { _ in
            UIAction(title: "Action 2", image: UIImage(systemName: "heart")) { _ in }
        },
        MenuAction(title: "Action 3", systemImage: "bolt") { _ in
            UIAction(title: "Action 3", image: UIImage(systemName: "bolt")) { _ in }
        },
    ]
}

private struct ModdedUIMenuBodyView: View {
    @ObservedObject var configuration: ModdedUIMenuConfiguration

    var body: some View {
        VStack(spacing: 20) {
            Text("UINavigationItem.titleMenuProvider で custom header 付き UIMenu を表示します。")
                .multilineTextAlignment(.center)

            Toggle("NavBar 基準の表示を使う", isOn: $configuration.prefersNavBarAnchoredShareSheet)
                .toggleStyle(.switch)

            Text("ナビゲーションタイトルをタップしてメニューを開いてください。")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            Text(configuration.prefersNavBarAnchoredShareSheet ? "ON: NavBar 付近を基準にポップオーバー表示します。" : "OFF: 標準的な共有シート表示に戻します。")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}

private final class MenuHeaderView: UIView {
    private let onShareTap: (UIView, CGRect) -> Void

    init(frame: CGRect, onShareTap: @escaping (UIView, CGRect) -> Void) {
        self.onShareTap = onShareTap
        super.init(frame: frame)
        backgroundColor = .clear

        let hostingController = UIHostingController(
            rootView: MenuHeaderContentView(
                onShareTap: { [weak self] in
                    guard let self else {
                        return
                    }
                    let anchorRect = bounds.insetBy(dx: bounds.width - 44, dy: 0)
                    onShareTap(self, anchorRect)
                }
            )
        )
        let hostedView = hostingController.view!
        hostedView.translatesAutoresizingMaskIntoConstraints = false
        hostedView.backgroundColor = .clear

        addSubview(hostedView)

        NSLayoutConstraint.activate([
            hostedView.topAnchor.constraint(equalTo: topAnchor),
            hostedView.leadingAnchor.constraint(equalTo: leadingAnchor),
            hostedView.trailingAnchor.constraint(equalTo: trailingAnchor),
            hostedView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric, height: 84)
    }
}

private struct MenuHeaderContentView: View {
    let onShareTap: () -> Void

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Image(.sampleRiko)
                .resizable()
                .scaledToFill()
                .frame(width: 32, height: 32)

            VStack(alignment: .leading, spacing: 8) {
                Text("Custom Menu Header")
                    .font(.headline)

                HStack(alignment: .center, spacing: 12) {
                    Text("今回の参考リポジトリ")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Spacer(minLength: 0)

                    Button(action: onShareTap) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(.primary)
                            .frame(width: 28, height: 28)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color(uiColor: .secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

#Preview {
    ModdedUIMenuView()
}
