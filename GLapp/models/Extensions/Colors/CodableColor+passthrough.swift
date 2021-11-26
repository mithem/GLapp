//
//  CodableColor+passthrough.swift
//  GLapp
//
//  Created by Miguel Themann on 26.11.21.
//

import SwiftUI

extension CodableColor {
    static var random: Self {
        .init(.random)
    }
    
    static let primary = Self.init(.label)
    static let blue = Self.init(.systemBlue) // actually only used for MockData, but anyway. There isn't an infinite amount of colors in the world, right??
    static let green = Self.init(.systemGreen)
    static let red = Self.init(.systemRed)
    static let purple = Self.init(.systemPurple)
    static let yellow = Self.init(.systemYellow)
    
    var isDark: Bool {
        color.isDark
    }
    
    var isTransparent: Bool {
        color.isTransparent
    }
    
    func lighten() -> Self {
        .init(color.lighten())
    }
    
    func darken() -> Self {
        .init(color.darken())
    }
    
    func getColoredForegroundColor(colorScheme: ColorScheme) -> Self {
        .init(color.getColoredForegroundColor(colorScheme: colorScheme))
    }
    
    func getForegroundColor(colorScheme: ColorScheme) -> Self {
        .init(color.getForegroundColor(colorScheme: colorScheme))
    }
}
