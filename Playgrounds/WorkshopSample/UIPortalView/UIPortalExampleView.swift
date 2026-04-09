//
//  UIPortalView.swift
//  Playgrounds
//
//  Created by Kazuki Nakashima on 2026/04/05.
//

import AVKit
import SwiftUI

struct UIPortalExampleView: View {
    @State private var model = UIPortalViewModel()

    var body: some View {
        VStack{
            AVPlayerViewControllerRepresentable(viewController: model.playerViewController)
                .aspectRatio(16 / 9, contentMode: .fit)
            
            PortalViewRepresentable(portalView: model.portalView)
                .aspectRatio(16 / 9, contentMode: .fit)
        }
        .scenePadding()
        .navigationTitle("UIPortalView")
    }
}

@MainActor
@Observable
final class UIPortalViewModel {
    let playerViewController: AVPlayerViewController
    let portalView: UIView
    var videoURL: URL? {
        didSet {
            updatePlayer()
        }
    }

    init(videoURL: URL? = Bundle.main.url(forResource: "IMG_1176", withExtension: "mov")) {
        let viewController = AVPlayerViewController()
        viewController.view.backgroundColor = .black
        viewController.showsPlaybackControls = true
        viewController.videoGravity = .resizeAspect
        self.playerViewController = viewController
        self.portalView = Self.makePortalView(sourceView: viewController.view)
        self.videoURL = videoURL
        updatePlayer()
    }

    private func updatePlayer() {
        guard let videoURL else {
            playerViewController.player?.pause()
            playerViewController.player = nil
            return
        }

        let currentURL = (playerViewController.player?.currentItem?.asset as? AVURLAsset)?.url
        guard currentURL != videoURL else {
            return
        }

        playerViewController.player = AVPlayer(url: videoURL)
    }

    private static func makePortalView(sourceView: UIView) -> UIView {
//      Dynamic lookup is also a reasonable option when avoiding a direct
//      reference to the concrete `_UIPortalView` type.
///     guard let portalViewType = NSClassFromString("_UIPortalView") as? UIView.Type else {
///         let fallbackView = UIView()
///         fallbackView.translatesAutoresizingMaskIntoConstraints = false
///         fallbackView.backgroundColor = .black
///         return fallbackView
///      }
///     let portalView = portalViewType.init(frame: .zero)

        let portalView = _UIPortalView()
        
        portalView.translatesAutoresizingMaskIntoConstraints = false
        portalView.backgroundColor = .black
        portalView.clipsToBounds = true
        portalView.setValue(sourceView, forKey: "sourceView")
        portalView.setValue(false, forKey: "hidesSourceView")
        portalView.setValue(true, forKey: "allowsHitTesting")
        portalView.setValue(false, forKey: "matchesPosition")
        portalView.setValue(false, forKey: "matchesTransform")
        portalView.setValue(true, forKey: "matchesAlpha")
        portalView.layer.setValue(false, forKey: "excludeSeparated")
        return portalView
    }
}


private struct AVPlayerViewControllerRepresentable: UIViewControllerRepresentable {
    let viewController: AVPlayerViewController

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        return viewController
    }

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
    }
}

private struct PortalViewRepresentable: UIViewRepresentable {
    let portalView: UIView

    func makeUIView(context: Context) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = .black
        containerView.clipsToBounds = true
        attachPortalView(to: containerView)
        return containerView
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        attachPortalView(to: uiView)
    }

    private func attachPortalView(to containerView: UIView) {
        guard portalView.superview !== containerView else {
            return
        }

        portalView.removeFromSuperview()
        containerView.addSubview(portalView)

        NSLayoutConstraint.activate([
            portalView.topAnchor.constraint(equalTo: containerView.topAnchor),
            portalView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            portalView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            portalView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])
    }
}

#Preview {
    NavigationStack{
        UIPortalExampleView()
    }
}
