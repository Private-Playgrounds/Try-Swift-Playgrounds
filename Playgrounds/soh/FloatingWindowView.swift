import SwiftUI

/// プライベート API を使ってアプリ内フローティングウィンドウを表示するデモ。
/// windowLevel を高く設定した UIWindow 上にドラッグ可能なパネルを配置する。
struct FloatingWindowView: View {
    @State private var windowShown = false

    var body: some View {
        VStack(spacing: 20) {
            Text("windowLevel を高く設定した UIWindow を生成し、\nhitTest オーバーライドでパネル外のタッチを透過させる")
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Button(windowShown ? "Dismiss" : "Show Floating Window") {
                if windowShown {
                    FloatingWindowManager.shared.dismiss()
                } else {
                    FloatingWindowManager.shared.present()
                }
                windowShown.toggle()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .navigationTitle("Floating Window")
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear {
            FloatingWindowManager.shared.dismiss()
            windowShown = false
        }
    }
}

// MARK: - Touch-Transparent Window

private class TouchTransparentWindow: UIWindow {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hit = super.hitTest(point, with: event)
        return hit === self ? nil : hit
    }
}

// MARK: - Manager

@MainActor
final class FloatingWindowManager {
    static let shared = FloatingWindowManager()
    private var overlay: TouchTransparentWindow?

    func present() {
        guard overlay == nil,
              let scene = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene }).first else { return }

        let w = TouchTransparentWindow(windowScene: scene)
        w.windowLevel = .alert + 1
        w.backgroundColor = .clear
        w.isHidden = false

        let vc = UIHostingController(rootView: PanelView())
        vc.view.backgroundColor = .clear
        w.rootViewController = vc
        overlay = w
    }

    func dismiss() {
        overlay?.isHidden = true
        overlay = nil
    }
}

// MARK: - Draggable Panel

private struct PanelView: View {
    @State private var position = CGPoint(x: 200, y: 350)
    @State private var panelSize = CGSize(width: 260, height: 300)

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                HStack {
                    Text("Floating")
                        .font(.caption2.bold())
                        .foregroundStyle(.secondary)
                    Spacer()
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(.bar)

                SceneSnapshotView()
                    .frame(height: panelSize.height - 30)
                    .clipped()
            }
            .frame(width: panelSize.width, height: panelSize.height)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .shadow(color: .black.opacity(0.35), radius: 10, y: 5)
            .position(position)
            .gesture(
                DragGesture()
                    .onChanged { v in
                        position.x += v.translation.width
                        position.y += v.translation.height
                    }
            )
            .onAppear {
                position = CGPoint(x: geo.size.width / 2, y: geo.size.height * 0.4)
            }
        }
        .ignoresSafeArea()
    }
}

// MARK: - Scene Snapshot via Private API

/// `_UISceneLayerHostContainerView` でアプリのシーンレイヤーをリアルタイム複製する。
/// 利用できない場合はスナップショット画像にフォールバック。
private struct SceneSnapshotView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        if let hosted = Self.createLayerHost() {
            hosted.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            return hosted
        }
        // フォールバック: キーウィンドウのスナップショット
        return Self.createSnapshotView()
    }

    func updateUIView(_ uiView: UIView, context: Context) {}

    // MARK: Private

    private static func createLayerHost() -> UIView? {
        guard let scene = UIApplication.shared.connectedScenes.first else { return nil }
        guard let cls = NSClassFromString("_UISceneLayerHostContainerView") as? UIView.Type else { return nil }

        let sel = NSSelectorFromString("initWithScene:")
        guard cls.instancesRespond(to: sel) else { return nil }

        let raw = cls.init()
        guard let container = raw.perform(sel, with: scene)?.takeUnretainedValue() as? UIView else { return nil }

        let createSel = NSSelectorFromString("_createHostViewForLayer:")
        let lmSel = NSSelectorFromString("layerManager")

        if scene.responds(to: lmSel),
           let lm = scene.perform(lmSel)?.takeUnretainedValue() as? NSObject {
            let lsSel = NSSelectorFromString("layers")
            if lm.responds(to: lsSel),
               let layers = lm.perform(lsSel)?.takeUnretainedValue() as? [AnyObject] {
                for layer in layers {
                    if container.responds(to: createSel),
                       let v = container.perform(createSel, with: layer)?.takeUnretainedValue() as? UIView {
                        container.addSubview(v)
                    }
                }
            }
        }
        return container
    }

    private static func createSnapshotView() -> UIView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        if let keyWindow = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap(\.windows)
            .first(where: \.isKeyWindow) {
            let renderer = UIGraphicsImageRenderer(bounds: keyWindow.bounds)
            imageView.image = renderer.image { ctx in
                keyWindow.drawHierarchy(in: keyWindow.bounds, afterScreenUpdates: false)
            }
        }
        return imageView
    }
}

#Preview {
    NavigationStack {
        FloatingWindowView()
    }
}
