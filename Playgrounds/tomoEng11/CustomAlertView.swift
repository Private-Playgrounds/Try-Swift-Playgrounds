//
//  CustomAlertView.swift
//  Playgrounds
//
//  Created by 井本　智博 on 2026/04/12.
//

import SwiftUI
import UIKit

struct CustomAlertView: View {
    @State private var showCustomAlert = false

    var body: some View {
        VStack(spacing: 20) {
            Text("UIAlertController 実験")
                .font(.title)

            Button("カスタマイズアラート") {
                showCustomAlert = true
            }
            .buttonStyle(.borderedProminent)

            Text("プライベートAPIで\nタイトル・メッセージ・ボタンの\n色を変更しています")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .alertControllerPresenter(isPresented: $showCustomAlert, customized: true)
    }
}

// MARK: - UIAlertController を表示するための仕組み

struct AlertControllerPresenter: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    var customized: Bool

    func makeUIViewController(context: Context) -> UIViewController {
        UIViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if isPresented && uiViewController.presentedViewController == nil {
            let alert = UIAlertController(
                title: "実験用アラート",
                message: "プライベートAPIを試してみよう！",
                preferredStyle: .alert
            )

            // テキストフィールドを追加
            alert.addTextField { textField in
                textField.placeholder = "ここに入力"
            }

            let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { _ in
                isPresented = false
            }

            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                isPresented = false
            }

            alert.addAction(cancelAction)
            alert.addAction(okAction)

            if customized {
                // ========================================
                // プライベートAPIでカスタマイズ
                // ========================================

                // タイトルの色とフォントを変更
                let titleAttributes: [NSAttributedString.Key: Any] = [
                    .foregroundColor: UIColor.systemGreen,
                    .font: UIFont.boldSystemFont(ofSize: 20)
                ]
                let attributedTitle = NSAttributedString(
                    string: "try! Swift2026",
                    attributes: titleAttributes
                )
                AlertCustomizer.setAttributedTitle(attributedTitle, for: alert)

                // メッセージの色を変更
                let messageAttributes: [NSAttributedString.Key: Any] = [
                    .foregroundColor: UIColor.systemOrange,
                    .font: UIFont.italicSystemFont(ofSize: 14)
                ]
                let attributedMessage = NSAttributedString(
                    string: "Private Playgrounds\n created by tomoEng11",
                    attributes: messageAttributes
                )
                AlertCustomizer.setAttributedMessage(attributedMessage, for: alert)

                // ボタンの色を変更
                AlertCustomizer.setTitleColor(.systemPurple, for: cancelAction)
                AlertCustomizer.setTitleColor(.systemRed, for: okAction)

                // 画像を表示（sampleRikoを使用）
                let image = UIImage(resource: .sampleRiko)
                AlertCustomizer.setContentImage(
                    image,
                    size: CGSize(width: 150, height: 150),
                    for: alert
                )
            }

            uiViewController.present(alert, animated: true)
        }
    }
}

extension View {
    func alertControllerPresenter(isPresented: Binding<Bool>, customized: Bool = false) -> some View {
        self.background(AlertControllerPresenter(isPresented: isPresented, customized: customized))
    }
}

#Preview {
    CustomAlertView()
}
