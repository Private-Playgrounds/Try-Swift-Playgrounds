import SwiftUI
import UIKit

struct DancingGiginetAppIconView: View {
    @State private var currentIconName: String? = UIApplication.shared.alternateIconName

    private let iconName = "GiginetFrame1"

    var body: some View {
        VStack(spacing: 20) {
            Text("current: \(currentIconName ?? "<primary>")")
                .font(.headline)

            if let img = UIImage(named: "\(iconName)@2x.png") {
                Image(uiImage: img)
                    .resizable()
                    .interpolation(.none)
                    .frame(width: 120, height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                    .shadow(radius: 6)
            }

            Button("Set alternate icon (silently)") {
                setAlternateIcon(iconName)
            }
            .buttonStyle(.borderedProminent)

            Button("Reset to primary icon") {
                setAlternateIcon(nil)
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .navigationTitle("Silent AppIcon Change")
    }

    private func setAlternateIcon(_ name: String?) {
        let app = UIApplication.shared
        let selector = NSSelectorFromString("_setAlternateIconName:completionHandler:")
        guard app.responds(to: selector) else {
            app.setAlternateIconName(name)
            currentIconName = name
            return
        }
        let completion: @convention(block) (NSError?) -> Void = { _ in }
        app.perform(selector, with: name, with: completion as AnyObject)
        currentIconName = UIApplication.shared.alternateIconName
    }
}

#Preview {
    NavigationStack { DancingGiginetAppIconView() }
}
