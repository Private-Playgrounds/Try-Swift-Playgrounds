//
//  MyMapAppleLogo.swift
//  Playgrounds
//
//  Created by kiwiyuki on 2026/04/12.
//

import SwiftUI
import MapKit

struct MapAppleLogoAllTypeView: View {
    var body: some View {
        VStack {
            ForEach(0...5, id: \.self) { type in
                HStack {
                    MapAppleLogoView(mapType: UInt64(type), isDarkMode: false)
                    MapAppleLogoView(mapType: UInt64(type), isDarkMode: true)
                }

            }
        }
    }
}

struct MapAppleLogoView: View {
    let mapType: UInt64
    let isDarkMode: Bool

    init(mapType: UInt64 = 0, isDarkMode: Bool = false) {
        self.mapType = mapType
        self.isDarkMode = isDarkMode
    }

    var body: some View {
        if let image = makeLogoImage() {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .frame(height: 20)
        }
    }

    private func makeLogoImage() -> UIImage? {
        let cls: AnyClass? = NSClassFromString("MKAppleLogoImageView")
        let sel = NSSelectorFromString("logoForMapType:forDarkMode:")
        guard let method = class_getClassMethod(cls, sel) else { return nil }
        typealias LogoFactoryIMP = @convention(c) (AnyClass, Selector, UInt64, Bool) -> AnyObject
        let fn = unsafeBitCast(method_getImplementation(method), to: LogoFactoryIMP.self)
        return fn(cls!, sel, mapType, isDarkMode) as? UIImage
    }
}
#Preview {
    MapAppleLogoAllTypeView()
}
