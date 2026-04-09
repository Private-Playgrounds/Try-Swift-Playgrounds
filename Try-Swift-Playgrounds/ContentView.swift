//
//  ContentView.swift
//  Try-Swift-Playgrounds
//
//  Created by Kazuki Nakashima on 2026/04/09.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
