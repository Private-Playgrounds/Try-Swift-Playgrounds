import SwiftUI

public struct ContentView: View {
    public init() {}

    public var body: some View {
        NavigationSplitView {
            NavigationStack{
                List {
                    // Add one entry per participant here.
                    // Keep your view in `Playgrounds/<ParticipantName>/`.
                    NavigationLink {
                        CustomAlertView()
                    } label: {
                        Text("tomoEng11 CustomAlert")
                    }
                    NavigationLink {
                        UIAlertControllerSampleView()
                    } label: {
                        Text("Custom UIAlertController")
                    }
                    NavigationLink {
                        KarlAlertControllerSampleView()
                    } label: {
                        Text("Video UIAlertController")
                    }
                    NavigationLink {
                        CustomKBBackgroundView()
                    } label: {
                        Text("Custom KeyboardAppearance")
                    }
                    NavigationLink {
                        UIPortalExampleView()
                    } label: {
                        Text("UIPortalView")
                    }
                    NavigationLink {
                        ScrollToTopIfPossibleView()
                    } label: {
                        Text("ScrollToTopIfPossibleView")
                    }
                    NavigationLink{
                        LiquidGlassSample()
                    } label: {
                        Text("LiquidGlassSample")
                    }
                    NavigationLink{
                        FullscreenSheetControllerRikusouda()
                    } label: {
                        Text("FullscreenSheetController by rikusouda")
                    }
                    NavigationLink {
                        NumberPadAlertControllerView()
                    } label: {
                        Text("NumberPadAlertControllerView")
                    }
                }
                .navigationTitle("Playgrounds")
            }
        } detail: {
            ContentUnavailableView("Select a View", systemImage: "square.stack.3d.up")
        }
    }
}

#Preview {
    ContentView()
}
