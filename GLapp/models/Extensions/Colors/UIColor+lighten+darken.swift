//
//  UIColor+lighten+darken.swift
//  GLapp
//
//  Created by Miguel Themann on 01.11.21.
//

import UIKit

extension UIColor {
    func lighten() -> UIColor {
        var r, g, b, a: CGFloat
        (r, g, b, a) = (0, 0, 0, 0)
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let c = 0.4
        return .init(red: r + c, green: g + c, blue: b + c, alpha: a)
    }
    
    func darken() -> UIColor {
        var r, g, b, a: CGFloat
        (r, g, b, a) = (0, 0, 0, 0)
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let c = 0.4
        return .init(red: r - c, green: g - c, blue: b - c, alpha: a)
    }
}
