//
//  LiquidGlassSample.swift
//  Playgrounds
//
//  Created by Kazuki Nakashima on 2026/04/08.
//

import SwiftUIPlaygrounds
import AVKit

struct LiquidGlassSample: View {

    private let samples: [GlassVariantSample] = [
        .init(title: "controlCenter", variant: .controlCenter),
        .init(title: "dock", variant: .dock),
        .init(title: "notificationCenter", variant: .notificationCenter),
        .init(title: "bubbles", variant: .bubbles),
        .init(title: "avplayer", variant: .avplayer),
        .init(title: "inspector", variant: .inspector),
        .init(title: "regular", variant: .regular),
        .init(title: "focusBorder", variant: .focusBorder),
        .init(title: "appIcons", variant: .appIcons),
        .init(title: "facetime", variant: .facetime),
        .init(title: "text", variant: .text),
        .init(title: "widgets", variant: .widgets),
        .init(title: "monogram", variant: .monogram),
        .init(title: "sidebar", variant: .sidebar),
        .init(title: "abuttedSidebar", variant: .abuttedSidebar),
        .init(title: "clear", variant: .clear),
        .init(title: "appIcons(tint: .teal)", variant: .appIcons(tint: .teal))
    ]
    var body: some View {
        ScrollView {
            LazyVGrid(columns:.init(arrayLiteral: .init(.adaptive(minimum: 120)))){
                ForEach(samples) { sample in
                    Circle()
                        .fill(Material._glass(sample.variant))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .scrollIndicators(.hidden)
        .scenePadding(.horizontal)
        .background{
            PlayerView().ignoresSafeArea()
        }
    }
}

private struct GlassVariantSample: Identifiable {
    let title: String
    let variant: Material._GlassVariant

    var id: String { title }
}

private struct PlayerView: View {
    @State private var playback = LiquidGlassPlayback()

    var body: some View {
        _CALayerView(type: AVPlayerLayer.self) { layer in
            layer.player = playback.player
            layer.videoGravity = .resizeAspectFill
        }
        .onAppear {
            playback.play()
        }
        .onDisappear {
            playback.pause()
        }
    }
}

@MainActor
private final class LiquidGlassPlayback {
    let player: AVPlayer

    private var endObserver: NSObjectProtocol?

    init(resourceName: String = "IMG_1176", fileExtension: String = "mov") {
        guard let url = Bundle.main.url(forResource: resourceName, withExtension: fileExtension) else {
            fatalError("Missing bundled video asset: \(resourceName).\(fileExtension)")
        }

        let player = AVPlayer(url: url)
        self.player = player
        player.actionAtItemEnd = .none
        endObserver = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem,
            queue: .main
        ) { [weak player] _ in
            guard let player else {
                return
            }

            player.seek(to: .zero)
            player.play()
        }
    }

    deinit {
        if let endObserver {
            NotificationCenter.default.removeObserver(endObserver)
        }
    }

    func play() {
        player.play()
    }

    func pause() {
        player.pause()
    }
}

#Preview {
    NavigationStack{
        LiquidGlassSample()
    }
}
