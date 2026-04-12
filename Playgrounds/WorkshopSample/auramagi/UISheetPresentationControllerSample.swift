//
//  UISheetPresentationControllerSample.swift
//  Playgrounds
//
//  Created by Mikhail Apurin on 2026-04-12.
//

import SwiftUI
import UIKit

struct UISheetPresentationControllerSample: View {
    var body: some View {
        SampleVCRepresentable()
            .ignoresSafeArea()
    }
}

#Preview {
    UISheetPresentationControllerSample()
}

private struct SampleVCRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> SampleVC {
        SampleVC()
    }
    
    func updateUIViewController(_ uiViewController: SampleVC, context: Context) {
    }
}

private final class SampleVC: UIViewController {
    private var hasPresentedSheet = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard !hasPresentedSheet else { return }
        hasPresentedSheet = true
        
        present(makeSheetViewController(), animated: false)
    }
    
    private func makeSheetViewController() -> UIViewController {
        let viewController = UIKitSheetViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        
        if let sheet = navigationController.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
        }
        
        return navigationController
    }
}

private final class UIKitSheetViewController: UIViewController {
    private let segmentedControl = UISegmentedControl(items: ["Try", "Swift", "Tokyo"])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        segmentedControl.selectedSegmentIndex = 0
        navigationItem.titleView = segmentedControl
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            systemItem: .close,
            primaryAction: UIAction { [weak self] _ in
                self?.dismiss(animated: true)
            }
        )
        
        let button = UIButton(primaryAction: UIAction(title: "Glassify", handler: { [segmentedControl] _ in
            let glass = makeGlass(variant: 9)
            let effect = UIGlassEffect.perform(NSSelectorFromString("effectWithGlass:"), with: glass).takeUnretainedValue() as? UIVisualEffect
            segmentedControl.perform(NSSelectorFromString("_setGlassEffect:"), with: effect)
        }))
        
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}

public func makeGlass(variant: Int) -> NSObject {
    let glassClass = unsafeBitCast(NSClassFromString("_UIViewGlass")!, to: (any PrivateUIViewGlassWrapper.Type).self)
    return glassClass.init(variant: variant) as! NSObject
}

@objc public protocol PrivateUIViewGlassWrapper: NSObjectProtocol {
    init(variant: Int)
}
