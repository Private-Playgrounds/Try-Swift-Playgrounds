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
                        TextFieldWithVisibilityToggle()
                    } label: {
                        Text("TextField with visibility toggle")
                    }
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
                    NavigationLink {
                        VideoTabBarView()
                    } label: {
                        Text("Video TabBar")
                    }
                    NavigationLink {
                        NowPlayingSheetView()
                    } label: {
                        Text("NowPlaying Sheet")
                    }
                    NavigationLink {
                        DancingGiginetAppIconView()
                    } label: {
                        Text("Dancing giginet AppIcon")
                    }
                    NavigationLink {
                        QuietlySetVariantIndexView()
                    } label: {
                        Text("_quietlySetVariantIndex")
                    }
                    NavigationLink{
                        Satomasahiro2005View()
                    } label: {
                        Text("@satomasahiro2005")
                    }
                    NavigationLink {
                        FullscreenSheetControllerRikusouda()
                    } label: {
                        Text("FullscreenSheetController by rikusouda")
                    }
                    NavigationLink {
                        NumberPadAlertControllerView()
                    } label: {
                        Text("NumberPadAlertControllerView")
                    }
                    NavigationLink {
                        SohSampleView()
                    } label: {
                        Text("soh's Playground")
                    }
                    NavigationLink {
                        FullscrennInteractiveDismissView()
                    } label: {
                        Text("zunda's FullscrennInteractiveDismiss")
                    }
                    NavigationLink {
                        UISheetPresentationControllerSample()
                    } label: {
                        Text("auramagi UISheetPresentationControllerSample")
                    }
                    NavigationLink {
                        MapAppleLogoAllTypeView()
                    } label: {
                        Text("Map AppleLogo")
                    }
                    NavigationLink {
                        ModdedUIMenuView()
                    } label: {
                        Text("hume Playground")
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
