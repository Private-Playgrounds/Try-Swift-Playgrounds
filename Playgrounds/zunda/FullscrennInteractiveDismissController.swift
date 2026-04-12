import SwiftUI

final class FullscrennInteractiveDismissController: UIViewController {
    private lazy var showSheetButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Show Sheet"

        let action = UIAction { [weak self] _ in
            self?.presentSheet()
        }

        let button = UIButton(configuration: configuration, primaryAction: action)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(showSheetButton)

        NSLayoutConstraint.activate([
            showSheetButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            showSheetButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            showSheetButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 44)
        ])
    }

    private func presentSheet() {
        let sheetViewController = SampleSheetViewController()
        
        if let sheet = sheetViewController.sheetPresentationController {
            sheet.setValue(true, forKey: "wantsFullScreen")
            sheet.setValue(true, forKey: "allowsInteractiveDismissWhenFullScreen")
        }

        present(sheetViewController, animated: true)
    }
}

private final class SampleSheetViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "下にスワイプして閉じれる"
        label.font = .preferredFont(forTextStyle: .title2)

        view.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}

struct FullscrennInteractiveDismissView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> FullscrennInteractiveDismissController {
        FullscrennInteractiveDismissController()
    }

    func updateUIViewController(_ uiViewController: FullscrennInteractiveDismissController, context: Context) {
    }
}

#Preview {
    FullscrennInteractiveDismissView()
}
