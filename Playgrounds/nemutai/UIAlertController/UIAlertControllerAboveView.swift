import SwiftUI

struct UIAlertControllerAboveView: View {
    @EnvironmentObject private var sceneDelegate: SceneDelegate
    var body: some View {
        VStack {
            Text("UIAlertController does not publicly support custom views.")
            Button {
                AlertPresenter.presentSampleAlert(in: sceneDelegate.windowScene)
            } label: {
                Text("Show Alert Controller")
                    .bold()
                    .padding()
            }
            .buttonStyle(.glassProminent)
        }
        .navigationTitle("UIAlertController")
    }

    enum AlertPresenter {
        static func presentSampleAlert(in scene: UIWindowScene?) {
            let alertController = UIAlertController(
                title: "Hello, I'm Riko!",
                message: "This alert is native UIAlertController with a custom image view as its content.",
                preferredStyle: .alert
            )

            let imageViewController = makeImageViewController(image: UIImage(resource: .sampleRiko))
            alertController.setValue(imageViewController, forKey: "headerContentViewController")

            let action = UIAlertAction(title: "try! Swift", style: .default)
            alertController.addAction(action)
            alertController.preferredAction = action

            guard let presenter = scene?.keyWindow?.rootViewController else {
                return
            }
            presenter.present(alertController, animated: true)
        }

        private static func makeImageViewController(image: UIImage) -> UIViewController {
            let imageViewController = UIViewController()
            imageViewController.view.backgroundColor = .clear

            let imageView = UIImageView(image: image)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFit

            imageViewController.view.addSubview(imageView)
            NSLayoutConstraint.activate([
                imageView.centerXAnchor.constraint(equalTo: imageViewController.view.centerXAnchor),
                imageView.centerYAnchor.constraint(equalTo: imageViewController.view.centerYAnchor),
                imageView.widthAnchor.constraint(equalToConstant: 150),
                imageView.heightAnchor.constraint(equalToConstant: 150),
            ])
            imageViewController.preferredContentSize = .init(width: 150, height: 150)
            return imageViewController
        }
    }
}


#Preview {
    NavigationStack {
        UIAlertControllerAboveView()
    }
}
