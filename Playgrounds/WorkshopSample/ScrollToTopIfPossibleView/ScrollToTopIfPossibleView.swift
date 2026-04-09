//
//  ScrollToTopIfPossibleView.swift
//  Playgrounds
//
//  Created by Kazuki Nakashima on 2026/04/09.
//

import SwiftUI
import WebKit

struct ScrollToTopIfPossibleView: View {
    @State private var model: ScrollToTopIfPossibleViewModel?
    var body: some View {
        Group {
            if let model {
                WKWebViewRepresentable(model:model)
                    .toolbar{
                        ToolbarItemGroup(placement:.bottomBar){
                            HStack{
                                Button("Normal"){
                                    let rect: CGRect = CGRect(x: 0, y: 0, width: 1, height: 1)
                                    model.webView.scrollView.scrollRectToVisible(rect, animated: true)
                                }
                                Divider()
                                Button("Private"){
                                    model.webView.scrollView.scrollToTopIfPossible(animated: true)
                                }
                            }
                        }
                    }
            } else {
                Color.clear
                    .onAppear{
                        self.model = ScrollToTopIfPossibleViewModel()
                    }
            }
        }
        .navigationTitle("ScrollToTopIfPossibleView")
        .navigationBarTitleDisplayMode(.inline)
    }
}

@Observable class ScrollToTopIfPossibleViewModel{
    var webView:WKWebView
    
    init() {
        let configuration = WKWebViewConfiguration()
        configuration.allowsPictureInPictureMediaPlayback = true
        configuration.allowsInlineMediaPlayback = true
        configuration.allowsAirPlayForMediaPlayback = true
        
        let webView = WKWebView()
        webView.allowsBackForwardNavigationGestures = true
        self.webView = webView
    }
}


private struct WKWebViewRepresentable:UIViewRepresentable{
    var model: ScrollToTopIfPossibleViewModel
    func makeUIView(context: Context) -> WKWebView {
        let url = URL(string:"https://tryswift.jp")!
        
        model.webView.load(URLRequest(url: url))
        return model.webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
    }
}

private extension UIScrollView {
    @discardableResult
    func scrollToTopIfPossible(animated: Bool) -> Bool {
        let selector = NSSelectorFromString("_scrollToTopIfPossible:")
        guard responds(to: selector) else {
            return false
        }

        let implementation = method(for: selector)
        let function = unsafeBitCast(
            implementation,
            to: (@convention(c) (AnyObject, Selector, Bool) -> Bool).self
        )
        return function(self, selector, animated)
    }
}

#Preview {
    NavigationStack {
        ScrollToTopIfPossibleView()
    }
}
