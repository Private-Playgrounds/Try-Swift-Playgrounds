//
//  QuietlySetVariantIndexView.swift
//  Playgrounds
//
//  Created by Chiharu Nameki on 2026/04/12.
//

import AVKit
import SwiftUI

// HLSの任意のVariantを選択して再生させることが可能
// 特に中間の解像度の再生品質や画質チェックなどに

struct QuietlySetVariantIndexView: View {
    @State private var model: VariantIndexModel?
    @State private var showVariants = false

    var body: some View {
        Group {
            if let model {
                VideoPlayer(player: model.player)
                    .ignoresSafeArea()
                    .overlay(alignment: .topLeading) {
                        StatusOverlay(model: model)
                    }
                    .overlay(alignment: .bottomTrailing) {
                        Button {
                            showVariants = true
                        } label: {
                            Image(systemName: "list.bullet")
                                .padding(12)
                                .background(.ultraThinMaterial, in: Circle())
                        }
                        .padding()
                    }
                    .sheet(isPresented: $showVariants) {
                        VariantPickerSheet(model: model)
                    }
            } else {
                Color.black
                    .ignoresSafeArea()
                    .onAppear {
                        self.model = VariantIndexModel()
                    }
            }
        }
        .navigationTitle("_quietlySetVariantIndex")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct VariantPickerSheet: View {
    @Bindable var model: VariantIndexModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                Section("Variants") {
                    if model.variantDescriptions.isEmpty {
                        Text("Loading variants…")
                            .foregroundStyle(.secondary)
                    }
                    ForEach(Array(model.variantDescriptions.enumerated()), id: \.offset) { index, desc in
                        Button {
                            model.player.currentItem?.quietlySetVariantIndex(index)
                            model.selectedIndex = index
                        } label: {
                            HStack {
                                Text("#\(index)")
                                    .monospacedDigit()
                                Text(desc)
                                    .font(.caption)
                                Spacer()
                                if model.selectedIndex == index {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(.green)
                                }
                            }
                        }
                        .tint(.primary)
                    }
                }

                Section {
                    Button("Reset to Auto") {
                        model.player.currentItem?.quietlySetVariantIndex(-1)
                        model.selectedIndex = nil
                    }
                }
            }
            .navigationTitle("Variants")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
}

private struct StatusOverlay: View {
    var model: VariantIndexModel

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("stableVariantID: \(model.currentStableVariantID)")
            Text("presentationSize: \(model.presentationSize)")
            if let event = model.lastAccessLogEvent {
                Text("indicated: \(Int(event.indicatedBitrate / 1000)) kbps")
                Text("observed: \(Int(event.observedBitrate / 1000)) kbps")
            }
        }
        .font(.caption.monospaced())
        .padding(8)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8))
        .padding()
    }
}

@Observable
private class VariantIndexModel {
    let player: AVPlayer
    var variantDescriptions: [String] = []
    var selectedIndex: Int?
    var currentStableVariantID: Int = -1
    var presentationSize: String = "—"
    var lastAccessLogEvent: AVPlayerItemAccessLogEvent?

    private var pollingTask: Task<Void, Never>?

    init() {
        // Apple's basic HLS test stream (low resolution variants)
        let url = URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_16x9/bipbop_16x9_variant.m3u8")!
        let item = AVPlayerItem(url: url)
        self.player = AVPlayer(playerItem: item)
        player.play()

        Task { @MainActor in
            guard let urlAsset = item.asset as? AVURLAsset else { return }
            let variants = try await urlAsset.load(.variants)
            self.variantDescriptions = variants.map { variant in
                let size = variant.videoAttributes?.presentationSize
                let res = size.map { "\(Int($0.width))x\(Int($0.height))" } ?? "audio-only"
                let bitrate = variant.peakBitRate ?? 0
                return "\(res) @ \(Int(bitrate / 1000)) kbps"
            }
        }

        pollingTask = Task { @MainActor [weak self] in
            while !Task.isCancelled {
                self?.pollStatus()
                try? await Task.sleep(for: .seconds(1))
            }
        }
    }

    private func pollStatus() {
        guard let item = player.currentItem else { return }
        currentStableVariantID = item.currentStableVariantID
        let size = item.presentationSize
        presentationSize = "\(Int(size.width))x\(Int(size.height))"
        lastAccessLogEvent = item.accessLog()?.events.last
    }
}

private extension AVPlayerItem {
    func quietlySetVariantIndex(_ index: Int) {
        let selector = NSSelectorFromString("_quietlySetVariantIndex:")
        guard responds(to: selector) else { return }

        let implementation = method(for: selector)
        let function = unsafeBitCast(
            implementation,
            to: (@convention(c) (AnyObject, Selector, Int) -> Void).self
        )
        function(self, selector, index)
    }

    var currentStableVariantID: Int {
        let selector = NSSelectorFromString("currentStableVariantID")
        guard responds(to: selector) else { return -1 }

        let implementation = method(for: selector)
        let function = unsafeBitCast(
            implementation,
            to: (@convention(c) (AnyObject, Selector) -> Int).self
        )
        return function(self, selector)
    }
}

#Preview {
    NavigationStack {
        QuietlySetVariantIndexView()
    }
}
