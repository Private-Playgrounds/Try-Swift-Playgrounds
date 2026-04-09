import SwiftUI

struct CustomKBBackgroundView: View {
    var body: some View {
        _CustomKBBackgroundVCRepresentable()
            .ignoresSafeArea()
            .navigationTitle("Custom KeyboardAppearance")
    }
}

struct _CustomKBBackgroundVCRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = CustomKBBackgroundVC

    func makeUIViewController(context: Context) -> UIViewControllerType {
        .init()
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}

class CustomKBBackgroundVC: UIViewController {

    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.keyboardDismissMode = .interactive
        sv.alwaysBounceVertical = true
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    private let inputBackdrop: UIView = {
        let v = UIView()
        v.layer.contents = UIImage(resource: .sampleKeyboardBackground).cgImage
        v.layer.contentsGravity = .resizeAspectFill
        v.layer.masksToBounds = true
        v.alpha = 0.6
        v.isUserInteractionEnabled = false
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let glassView: UIVisualEffectView = {
        let effect = UIGlassEffect(style: .regular)
        effect.isInteractive = true
        let v = UIVisualEffectView(effect: effect)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let textField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "メッセージを入力..."
        tf.borderStyle = .none
        tf.clearButtonMode = .whileEditing

        tf.keyboardAppearance = UIKeyboardAppearance(rawValue: 12)!

        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupKeyboardLayoutGuide()
        setupViews()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textField.becomeFirstResponder()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        applyFadeMask()
    }

    private func applyFadeMask() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = inputBackdrop.bounds
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.black.cgColor,
        ]
        let fadeHeight: CGFloat = 150
        let totalHeight = inputBackdrop.bounds.height
        gradientLayer.locations = [
            0,
            NSNumber(value: fadeHeight / totalHeight),
        ]
        inputBackdrop.layer.mask = gradientLayer
    }

    private func setupViews() {
        view.addSubview(scrollView)
        view.addSubview(inputBackdrop)
        view.addSubview(glassView)
        glassView.contentView.addSubview(textField)
        glassView.cornerConfiguration = .capsule()

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            glassView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            glassView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            glassView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -4),

            textField.leadingAnchor.constraint(equalTo: glassView.contentView.leadingAnchor, constant: 12),
            textField.trailingAnchor.constraint(equalTo: glassView.contentView.trailingAnchor, constant: -12),
            textField.topAnchor.constraint(equalTo: glassView.contentView.topAnchor, constant: 16),
            textField.bottomAnchor.constraint(equalTo: glassView.contentView.bottomAnchor, constant: -16),

            inputBackdrop.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            inputBackdrop.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            inputBackdrop.topAnchor.constraint(equalTo: glassView.topAnchor, constant: 0),
            inputBackdrop.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    private func setupKeyboardLayoutGuide() {
        view.keyboardLayoutGuide.keyboardDismissPadding = 60
    }
}

#Preview {
    NavigationStack {
        CustomKBBackgroundView()
    }
}
