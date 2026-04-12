//
//  UIAlertControllerSampleView.swift
//  Playgrounds
//
//  Created by Karl Groff on 4/12/26.
//


import AVKit
import SwiftUI

struct KarlAlertControllerSampleView: View {
    @EnvironmentObject private var sceneDelegate: SceneDelegate
    var body: some View {
        VStack {
            Text("UIAlertController does not publicly support custom views.")
            Button {
                AlertPresenter.presentSampleAlert(in: sceneDelegate.windowScene)
            } label: {
                Text("Show Deer Alert Controller")
                    .bold()
                    .padding()
            }
            .buttonStyle(.glassProminent)
        }
        .navigationTitle("UIAlertController")
    }

    enum AlertPresenter {
        private static let alertContentWidth: CGFloat = 270
        private static let alertContentAspectRatio: CGFloat = 16 / 9

        static func presentSampleAlert(in scene: UIWindowScene?) {
            let alertController = UIAlertController(
                title: "Look, deer!",
                message: "This alert is native UIAlertController with a looping video as its content.",
                preferredStyle: .alert
            )

            let videoViewController = makeVideoViewController()
            alertController.setValue(videoViewController, forKey: "contentViewController")

            let action = UIAlertAction(title: "try! Swift", style: .default)
            alertController.addAction(action)
            alertController.preferredAction = action

            guard let presenter = scene?.keyWindow?.rootViewController else {
                return
            }
            presenter.present(alertController, animated: true)
        }

        private static func makeVideoViewController() -> UIViewController {
            guard let videoURL = Bundle.main.url(forResource: "IMG_1176", withExtension: "mov") else {
                let fallbackViewController = UIViewController()
                fallbackViewController.view.backgroundColor = .clear
                fallbackViewController.preferredContentSize = .init(
                    width: alertContentWidth,
                    height: alertContentWidth / alertContentAspectRatio
                )
                return fallbackViewController
            }

            return AlertVideoViewController(
                videoURL: videoURL,
                contentWidth: alertContentWidth,
                aspectRatio: alertContentAspectRatio
            )
        }
    }
}

@MainActor
private final class AlertVideoViewController: AVPlayerViewController {
    private let playerLooper: AVPlayerLooper
    private let queuePlayer: AVQueuePlayer

    init(videoURL: URL, contentWidth: CGFloat, aspectRatio: CGFloat) {
        let playerItem = AVPlayerItem(url: videoURL)
        let queuePlayer = AVQueuePlayer()
        self.queuePlayer = queuePlayer
        self.playerLooper = AVPlayerLooper(player: queuePlayer, templateItem: playerItem)
        super.init(nibName: nil, bundle: nil)
        player = queuePlayer
        showsPlaybackControls = false
        videoGravity = .resizeAspectFill
        view.backgroundColor = .black
        preferredContentSize = .init(width: contentWidth, height: contentWidth / aspectRatio)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        queuePlayer.play()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        queuePlayer.pause()
    }
}


#Preview {
    NavigationStack {
        KarlAlertControllerSampleView()
    }
}
