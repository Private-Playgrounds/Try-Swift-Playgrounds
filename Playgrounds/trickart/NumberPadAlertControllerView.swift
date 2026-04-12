//
//  NumberPadAlertControllerView.swift
//  Playgrounds
//
//  Created by trickart on 2026/04/12.
//

import SwiftUI
import UIKit

struct NumberPadAlertControllerView: View {
    @EnvironmentObject private var sceneDelegate: SceneDelegate
    var body: some View {
        VStack {
            Text("UIAlertController does not publicly support custom views.\nThis sample sets `contentViewController` via KVC (private API) for research purposes only.")
                .multilineTextAlignment(.center)
                .padding()
            Button {
                AlertPresenter.presentPinPadAlert(in: sceneDelegate.windowScene)
            } label: {
                Text("Show PIN Pad Alert")
                    .bold()
                    .padding()
            }
            .buttonStyle(.glassProminent)
        }
        .navigationTitle("NumberPad Alert")
    }

    enum AlertPresenter {
        static func presentPinPadAlert(in scene: UIWindowScene?) {
            let alertController = UIAlertController(
                title: "パスコードを入力",
                message: "4桁のパスコードを入力してください",
                preferredStyle: .alert
            )

            let padViewController = PinPadViewController(length: 4) { [weak alertController] code in
                alertController?.dismiss(animated: true)
                print("Entered PIN: \(code)")
            }
            alertController.setValue(padViewController, forKey: "contentViewController")

            alertController.addAction(UIAlertAction(title: "キャンセル", style: .cancel))

            guard let presenter = scene?.keyWindow?.rootViewController else {
                return
            }
            presenter.present(alertController, animated: true)
        }
    }
}

final class PinPadViewController: UIViewController, UITextFieldDelegate {
    private let length: Int
    private let onComplete: (String) -> Void

    private var dots: [UIView] = []
    private let hiddenField = UITextField()

    private var entered: String = "" {
        didSet {
            updateDots()
            if entered.count == length {
                onComplete(entered)
            }
        }
    }

    init(length: Int, onComplete: @escaping (String) -> Void) {
        self.length = length
        self.onComplete = onComplete
        super.init(nibName: nil, bundle: nil)
        preferredContentSize = CGSize(width: 240, height: 40)
    }

    required init?(coder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear

        let dotsStack = UIStackView()
        dotsStack.spacing = 18
        dotsStack.alignment = .center
        dotsStack.distribution = .equalSpacing
        dotsStack.translatesAutoresizingMaskIntoConstraints = false
        for _ in 0..<length {
            let dot = UIView()
            dot.translatesAutoresizingMaskIntoConstraints = false
            dot.widthAnchor.constraint(equalToConstant: 12).isActive = true
            dot.heightAnchor.constraint(equalToConstant: 12).isActive = true
            dot.layer.cornerRadius = 6
            dot.layer.borderWidth = 1
            dot.layer.borderColor = UIColor.label.cgColor
            dots.append(dot)
            dotsStack.addArrangedSubview(dot)
        }
        view.addSubview(dotsStack)

        hiddenField.keyboardType = .numberPad
        hiddenField.textContentType = .oneTimeCode
        hiddenField.isSecureTextEntry = true
        hiddenField.delegate = self
        hiddenField.isHidden = true
        view.addSubview(hiddenField)

        // 文字が入るたびに呼ばれる
        hiddenField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)

        NSLayoutConstraint.activate([
            dotsStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dotsStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            dotsStack.heightAnchor.constraint(equalToConstant: 20),
        ])

        updateDots()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        hiddenField.becomeFirstResponder()
    }

    @objc private func editingChanged() {
        let digits = (hiddenField.text ?? "").filter(\.isNumber)
        let trimmed = String(digits.prefix(length))
        if trimmed != hiddenField.text {
            hiddenField.text = trimmed
        }
        entered = trimmed
    }

    private func updateDots() {
        for (index, dot) in dots.enumerated() {
            dot.backgroundColor = index < entered.count ? .label : .clear
        }
    }
}

#Preview {
    NavigationStack {
        NumberPadAlertControllerView()
    }
}
