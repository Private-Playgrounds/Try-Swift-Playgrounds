//
//  ModdedUIMenu.swift
//  Playgrounds
//
//  Created by Kengo Tate on 2026/04/12.
//

import SwiftUI
import UIKit

struct ModdedUIMenuView: View {
    var body: some View {
        ModdedUIMenuViewControllerRepresentable()
            .navigationTitle("Modded UIMenu")
            .navigationBarTitleDisplayMode(.inline)
    }
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
        let hostingController = UIHostingController(rootView: ModdedUIMenuBodyView())
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
            menu.headerViewProvider = {
                MenuHeaderView(frame: CGRect(x: 0, y: 0, width: 0, height: 84))
            }
            return menu
        }
    }

    fileprivate func presentShareSheet() {
        if
            let interaction = activeContextMenuInteraction(),
            let presentation = interaction.outgoingPresentation
        {
            presentation.addDismissalCompletion { [weak self] in
                self?.presentShareSheetNow()
            }
            interaction.dismissPrivateMenu()
            return
        }

        presentShareSheetNow()
    }

    private func presentShareSheetNow() {
        let presenter = parent ?? self
        guard presenter.presentedViewController == nil else {
            return
        }

        let activityViewController = UIActivityViewController(
            activityItems: [shareURL],
            applicationActivities: nil
        )
        activityViewController.popoverPresentationController?.sourceView = presenter.view
        activityViewController.popoverPresentationController?.sourceRect = CGRect(
            x: presenter.view.bounds.midX,
            y: presenter.view.bounds.midY,
            width: 1,
            height: 1
        )
        presenter.present(activityViewController, animated: true)
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
    var body: some View {
        VStack(spacing: 20) {
            Text("UINavigationItem.titleMenuProvider で custom header 付き UIMenu を表示します。")
                .multilineTextAlignment(.center)

            Text("ナビゲーションタイトルをタップしてメニューを開いてください。")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            Text("HeaderViewについているShareボタンが有効化できてないです。")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}

private final class MenuHeaderView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear

        let hostingController = UIHostingController(rootView: MenuHeaderContentView())
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

                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(.primary)
                        .frame(width: 28, height: 28)
                        .clipShape(Circle())
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
