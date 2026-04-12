import SwiftUI

extension UIView {
    var uiHostingView: UIView? {
        var current: UIView? = self
        while let view = current {
            if String(describing: type(of: view)).contains("_UIHostingView") {
                return view
            }
            current = view.superview
        }
        return nil
    }

    var uiTextField: UITextField? {
        if let textField = self as? UITextField {
            return textField
        }
        return subviews.compactMap(\.uiTextField).first
    }
}

struct PeekerView: UIViewRepresentable {
    static var uiTextField: UITextField?

    func makeUIView(context: Context) -> UIPeekerView {
        UIPeekerView()
    }

    func updateUIView(_ uiView: UIPeekerView, context: Context) {}

    class UIPeekerView: UIView {
        override func didMoveToWindow() {
            super.didMoveToWindow()
            if let uiTextField = uiHostingView?.uiTextField {
                PeekerView.uiTextField = uiTextField
            }
        }
    }
}

struct TextFieldWithVisibilityToggle: View {
    @State var text: String = "abc"
    var body: some View {
        HStack {
            TextField("Password", text: $text)
                .background(PeekerView())
                .border(Color.black)
            Button("Toggle") {
                PeekerView.uiTextField?.isSecureTextEntry.toggle()
            }
        }
        .padding()
    }
}

#Preview {
    TextFieldWithVisibilityToggle()
}
