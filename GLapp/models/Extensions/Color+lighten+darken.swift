//
//  Color+lighten+darken.swift
//  GLapp
//
//  Created by Miguel Themann on 01.11.21.
//

import SwiftUI

extension Color {
    func lighten() -> Color {
        var r, g, b, a: CGFloat
        (r, g, b, a) = (0, 0, 0, 0)
        UIColor(self).getRed(&r, green: &g, blue: &b, alpha: &a)
        let c = 0.4
        return .init(red: r + c, green: g + c, blue: b + c, opacity: a)
    }
    
    func darken() -> Color {
        var r, g, b, a: CGFloat
        (r, g, b, a) = (0, 0, 0, 0)
        UIColor(self).getRed(&r, green: &g, blue: &b, alpha: &a)
        let c = 0.4
        return .init(red: r - c, green: g - c, blue: b - c, opacity: a)
    }
}
