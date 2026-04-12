//
//  FullscreenSheetControllerRikusouda.swift
//  Playgrounds
//
//  Created by 吉岡祐樹 on 2026/04/12.
//

import SwiftUI
import UIKit

struct FullscreenSheetControllerRikusouda: View {
    @State private var showSheet = false
    var body: some View {
        ZStack {
            Button("Show Sheet") {
                showSheet = true
            }

            SheetPresenter(isPresented: $showSheet)
                .frame(width: 0, height: 0)
        }
    }
}

private struct SheetPresenter: UIViewControllerRepresentable {
    @Binding var isPresented: Bool

    func makeUIViewController(context: Context) -> UIViewController {
        UIViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if isPresented && uiViewController.presentedViewController == nil {
            let sheetVC = SheetViewController()
            sheetVC.modalPresentationStyle = .pageSheet

            if let sheet = sheetVC.sheetPresentationController {
                sheet.detents = [.large()]
                sheet.prefersGrabberVisible = true
                sheet.preferredCornerRadius = 20
                sheet.selectedDetentIdentifier = .large
                // 多分detents周りでprivateの何かを設定する
            }

            uiViewController.present(sheetVC, animated: true)
        }

        if !isPresented && uiViewController.presentedViewController != nil {
            uiViewController.dismiss(animated: true)
        }
    }
}

private class SheetViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        let label = UILabel()
        label.text = "Hello Sheet"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}


#Preview {
    FullscreenSheetControllerRikusouda()
}

