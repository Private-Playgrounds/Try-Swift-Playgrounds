import SwiftUI

struct SohSampleView: View {
    var body: some View {
        ContentUnavailableView(
            "Coming Soon",
            systemImage: "hammer.fill",
            description: Text("soh's playground is under construction.")
        )
        .navigationTitle("soh")
    }
}

#Preview {
    NavigationStack {
        SohSampleView()
    }
}
