//
//  NowPlayingSheetView.swift
//  Playgrounds
//

import SwiftUI
import UIKit

struct NowPlayingSheetView: View {
    @EnvironmentObject private var sceneDelegate: SceneDelegate
    @State private var isPresented = false

    var body: some View {
        VStack(spacing: 24) {
            Text("hogehoge")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button {
                SheetPresenter.present(in: sceneDelegate.windowScene)
            } label: {
                Text("Now Playing を開く")
                    .bold()
                    .padding()
            }
            .buttonStyle(.glassProminent)
        }
        .navigationTitle("UISheetPresentationController")
    }
}

// MARK: - Presenter

private enum SheetPresenter {
    static func present(in scene: UIWindowScene?) {
        guard let presenter = scene?.keyWindow?.rootViewController?.topmostViewController else {
            return
        }

        let sheetVC = NowPlayingViewController()
        sheetVC.modalPresentationStyle = .pageSheet

        if let sheet = sheetVC.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 0
            // Private API: 全画面表示＋インタラクティブ終了
            // Swift では objc_msgSend が直接使えないため dlsym で解決する
            let RTLD_DEFAULT = UnsafeMutableRawPointer(bitPattern: -2)
            if let sym = dlsym(RTLD_DEFAULT, "objc_msgSend") {
                typealias BoolSetter = @convention(c) (AnyObject, Selector, Bool) -> Void
                let msgSend = unsafeBitCast(sym, to: BoolSetter.self)
                msgSend(sheet, NSSelectorFromString("_setWantsFullScreen:"), true)
                msgSend(sheet, NSSelectorFromString("_setAllowsInteractiveDismissWhenFullScreen:"), true)
            }
        }

        presenter.present(sheetVC, animated: true)
    }
}

// MARK: - Sheet Content

final class NowPlayingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupContent()
    }

    private func setupContent() {
        let albumArt = UIView()
        albumArt.backgroundColor = .systemBlue
        albumArt.layer.cornerRadius = 16
        albumArt.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = "Now Playing"
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let subtitleLabel = UILabel()
        subtitleLabel.text = "try! Swift Tokyo 2026"
        subtitleLabel.font = .systemFont(ofSize: 15)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false

        let dismissButton = UIButton(type: .system)
        dismissButton.setTitle("閉じる", for: .normal)
        dismissButton.addTarget(self, action: #selector(dismissSheet), for: .touchUpInside)
        dismissButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(albumArt)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(dismissButton)

        NSLayoutConstraint.activate([
            albumArt.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            albumArt.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            albumArt.widthAnchor.constraint(equalToConstant: 240),
            albumArt.heightAnchor.constraint(equalToConstant: 240),

            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: albumArt.bottomAnchor, constant: 32),

            subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),

            dismissButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dismissButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 32),
        ])
    }

    @objc private func dismissSheet() {
        dismiss(animated: true)
    }
}

// MARK: - UIViewController helper

private extension UIViewController {
    var topmostViewController: UIViewController {
        if let presented = presentedViewController {
            return presented.topmostViewController
        }
        return self
    }
}

#Preview {
    NavigationStack {
        NowPlayingSheetView()
            .environmentObject(SceneDelegate())
    }
}
