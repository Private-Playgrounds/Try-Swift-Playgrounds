import SwiftUI

struct SohSampleView: View {
    @State private var backlightLevel: Float = UIApplication.shared.currentBacklightLevel

    var body: some View {
        List {
            Section("Backlight") {
                Slider(value: $backlightLevel, in: 0...1) {
                    Text("Level: \(backlightLevel, specifier: "%.2f")")
                }
                .onChange(of: backlightLevel) { _, newValue in
                    UIApplication.shared.setPrivateBacklightLevel(newValue)
                }
            }
            Section("Dangerous") {
                Button("Suspend App") {
                    UIApplication.shared.privateSuspend()
                }
                Button("Terminate App", role: .destructive) {
                    UIApplication.shared.privateTerminateWithSuccess()
                }
            }
        }
        .navigationTitle("UIApplication Private API")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - UIApplication Private API Extensions (Selector-based)

private extension UIApplication {
    /// `- (float)backlightLevel;`
    var currentBacklightLevel: Float {
        let selector = NSSelectorFromString("backlightLevel")
        guard responds(to: selector) else { return 0.5 }
        let impl = method(for: selector)
        let fn = unsafeBitCast(impl, to: (@convention(c) (AnyObject, Selector) -> Float).self)
        return fn(self, selector)
    }

    /// `- (void)setBacklightLevel:(float)level;`
    func setPrivateBacklightLevel(_ level: Float) {
        let selector = NSSelectorFromString("setBacklightLevel:")
        guard responds(to: selector) else { return }
        let impl = method(for: selector)
        let fn = unsafeBitCast(impl, to: (@convention(c) (AnyObject, Selector, Float) -> Void).self)
        fn(self, selector, level)
    }

    /// `- (void)suspend;`
    func privateSuspend() {
        let selector = NSSelectorFromString("suspend")
        guard responds(to: selector) else { return }
        perform(selector)
    }
    
    /// `- (void)terminateWithSuccess;`
    func privateTerminateWithSuccess() {
        let selector = NSSelectorFromString("terminateWithSuccess")
        guard responds(to: selector) else { return }
        perform(selector)
    }
}

#Preview {
    NavigationStack {
        SohSampleView()
    }
}
