//
//  Color+isDarkBackground.swift
//  GLapp
//
//  Created by Miguel Themann on 01.11.21.
//

import SwiftUI

// https://stackoverflow.com/questions/64071466/detect-color-type-dark-or-light

extension Color {
    var isDark: Bool {
        var r, g, b, a: CGFloat
        (r, g, b, a) = (0, 0, 0, 0)
        UIColor(self).getRed(&r, green: &g, blue: &b, alpha: &a)
        let luminance = 0.2126 * r + 0.7152 * g + 0.0722 * b
        return  luminance < 0.50
    }
    
    @MainActor var isTransparent: Bool {
        var r, g, b, a: CGFloat
        (r, g, b, a) = (0, 0, 0, 0)
        UIColor(self).getRed(&r, green: &g, blue: &b, alpha: &a)
        return a < 0.5
    }
}
