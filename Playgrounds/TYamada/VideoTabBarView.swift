//
//  VideoTabBarView.swift
//  Playgrounds
//
//
//  ─────────────────────────────────────────────────────────────
//  【このファイルの目的】
//  Private API を使って、UITabBar のアイコン位置に動画をループ再生させる。
//
//  【全体の流れ】
//   1. SwiftUI の VideoTabBarView が UIViewControllerRepresentable で
//      VideoTabBarController（UITabBarController サブクラス）を埋め込む。
//   2. UITabBarController が 3 つのタブを作る。videoTabIndex のタブを
//      動画差し替えの対象にする。
//   3. CADisplayLink で毎フレーム呼ばれる tick() の中で、
//        (a) タブバー内部のアイコン UIImageView を Private API で特定
//        (b) その座標に合わせて AVPlayerLayer を載せた overlay view を配置
//        (c) 元アイコンを alpha=0 で隠す
//      の 3 つを行う。
//
//  【Private API で触っているもの】
//   - UITabBarItem._view   (ivar)     → UITabBarButton / iOS 26 では _UITabButton
//   - UITabBarButton._info (ivar)     → UITabBarSwappableImageView (iOS 17 以前)
//     iOS 26 では _info ivar が存在しないため、ボタン配下の UIImageView を走査して拾う。
//   - object_getIvar / class_getInstanceVariable で ivar 値を安全に読む。
//  ─────────────────────────────────────────────────────────────
//

import SwiftUI
import UIKit
import AVFoundation
import ObjectiveC

// MARK: - SwiftUI エントリポイント

struct VideoTabBarView: View {
    var body: some View {
        VideoTabControllerRepresentable()
            .ignoresSafeArea()
            .navigationTitle("Video TabBar")
            .navigationBarTitleDisplayMode(.inline)
    }
}

private struct VideoTabControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> VideoTabBarController { VideoTabBarController() }
    func updateUIViewController(_ vc: VideoTabBarController, context: Context) {}
}

// MARK: - タブの本体

final class VideoTabBarController: UITabBarController {

    /// 動画を差し込むタブの index（0 始まり）
    private let videoTabIndex = 1

    /// 再生する動画。Bundle 同梱の IMG_1176.mov を優先、無ければ Apple HLS サンプルへフォールバック。
    private let videoURL: URL = {
        if let url = Bundle.main.url(forResource: "IMG_1176", withExtension: "mov") {
            return url
        }
        return URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/master.m3u8")!
    }()

    private var videoOverlay: VideoIconOverlayView?
    private var displayLink: CADisplayLink?

    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [
            makeTab(title: "Home",     symbol: "house.fill",          bg: .systemBackground),
            makeTab(title: "Live",     symbol: "play.rectangle.fill", bg: .systemGray6),
            makeTab(title: "Settings", symbol: "gearshape.fill",      bg: .systemBackground),
        ]
        selectedIndex = videoTabIndex
    }

    /// 画面表示中は毎フレーム tick() を呼んで、アイコンの座標に overlay を追従させる。
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if displayLink == nil {
            let link = CADisplayLink(target: self, selector: #selector(tick))
            link.add(to: .main, forMode: .common)
            displayLink = link
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        displayLink?.invalidate()
        displayLink = nil
    }

    @objc private func tick() {
        installVideoOverlayIfNeeded()
        videoOverlay?.sync()
    }

    private func makeTab(title: String, symbol: String, bg: UIColor) -> UIViewController {
        let vc = UIViewController()
        vc.view.backgroundColor = bg
        let label = UILabel()
        label.text = "\(title) タブ"
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        vc.view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor),
        ])
        vc.tabBarItem = UITabBarItem(title: title, image: UIImage(systemName: symbol), selectedImage: nil)
        return vc
    }

    // MARK: - Private API：アイコン UIImageView の特定

    /// 1 回だけ overlay を tabBar 直下に差し込む。
    /// tabBar 座標系に載せることで、z-order / clip のトラブルを避ける。
    private func installVideoOverlayIfNeeded() {
        guard videoOverlay == nil else { return }
        guard let iconView = findIconView(atTabIndex: videoTabIndex),
              iconView.bounds.width > 1 else { return }

        let overlay = VideoIconOverlayView(url: videoURL, target: iconView, hostTabBar: tabBar)
        tabBar.addSubview(overlay)
        tabBar.bringSubviewToFront(overlay)
        videoOverlay = overlay
    }

    /// タブバー index 番目のアイコン UIImageView を Private API で取り出す。
    ///
    /// 探索順：
    ///   Step 1. UITabBarItem._view ivar  → タブボタン View（UITabBarButton / _UITabButton）
    ///   Step 2. UITabBarButton._info ivar → UITabBarSwappableImageView（iOS 17 以前で有効）
    ///   Step 3. iOS 26 向けフォールバック：ボタン配下で一番大きい UIImageView を採用
    private func findIconView(atTabIndex index: Int) -> UIView? {
        guard let items = tabBar.items, index < items.count else { return nil }
        let item = items[index] as NSObject

        // Step 1: UITabBarItem._view
        guard let button = readIvarAsObject(item, name: "_view") as? UIView else {
            return nil
        }

        // Step 2: UITabBarButton._info（iOS 17 以前）
        if let imageView = readIvarAsObject(button, name: "_info") as? UIImageView {
            return imageView
        }

        // Step 3: iOS 26 フォールバック。_UITabButton 配下で最大面積の UIImageView。
        return button.collectImageViews()
            .max(by: { $0.bounds.width * $0.bounds.height < $1.bounds.width * $1.bounds.height })
    }

    /// Objective-C runtime で ivar を直接読む。継承階層を遡って探す。
    /// KVC（value(forKey:)）は存在しない key で NSUnknownKeyException を投げ、
    /// Swift からは catch できずクラッシュするため使わない。
    private func readIvarAsObject(_ obj: NSObject, name: String) -> AnyObject? {
        var cls: AnyClass? = type(of: obj)
        while let c = cls {
            if let ivar = class_getInstanceVariable(c, name) {
                return object_getIvar(obj, ivar) as AnyObject?
            }
            cls = class_getSuperclass(c)
        }
        return nil
    }
}

private extension UIView {
    /// 自分と配下の全 UIImageView を集める
    func collectImageViews() -> [UIImageView] {
        var result: [UIImageView] = []
        if let iv = self as? UIImageView { result.append(iv) }
        for sub in subviews { result.append(contentsOf: sub.collectImageViews()) }
        return result
    }
}

// MARK: - 動画オーバーレイ

/// アイコン UIImageView の位置に追従して AVPlayerLayer を表示する UIView。
/// tabBar に add されていて、sync() で毎フレーム座標を合わせる。
private final class VideoIconOverlayView: UIView {

    private let target: UIView
    private weak var host: UITabBar?
    private let player: AVQueuePlayer
    private let looper: AVPlayerLooper
    private let playerLayer: AVPlayerLayer

    init(url: URL, target: UIView, hostTabBar: UITabBar) {
        self.target = target
        self.host = hostTabBar
        let item = AVPlayerItem(url: url)
        let q = AVQueuePlayer()
        self.player = q
        // AVPlayerLooper でシームレスなループ再生
        self.looper = AVPlayerLooper(player: q, templateItem: item)
        self.playerLayer = AVPlayerLayer(player: q)
        super.init(frame: .zero)

        backgroundColor = .clear
        isUserInteractionEnabled = false
        clipsToBounds = true
        layer.cornerRadius = 8
        playerLayer.videoGravity = .resizeAspectFill
        layer.addSublayer(playerLayer)

        player.isMuted = true
        player.actionAtItemEnd = .none
        player.play()
    }

    required init?(coder: NSCoder) { fatalError() }

    /// 毎フレーム呼ぶ：
    ///   1. target（アイコン ImageView）の bounds を tabBar 座標系に変換して overlay を配置
    ///   2. 最前面に持ってくる（SwiftUI の再描画で後ろに回される対策）
    ///   3. 元アイコンを alpha=0 で毎フレーム隠す
    func sync() {
        guard let host = host, target.window != nil else { return }

        let converted = host.convert(target.bounds, from: target)
        // アイコンより少し大きめに載せて縁のチラつきを防ぐ
        frame = converted.insetBy(dx: -2, dy: -2)
        playerLayer.frame = bounds

        host.bringSubviewToFront(self)

        hideOriginalRecursively(in: target)
    }

    private func hideOriginalRecursively(in view: UIView) {
        if let iv = view as? UIImageView { iv.alpha = 0 }
        for sub in view.subviews { hideOriginalRecursively(in: sub) }
    }
}

#Preview {
    NavigationStack {
        VideoTabBarView()
    }
}
