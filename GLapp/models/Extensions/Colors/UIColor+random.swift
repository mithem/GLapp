//
//  UIColor+random.swift
//  GLapp
//
//  Created by Miguel Themann on 31.10.21.
//

import UIKit

extension UIColor {
    static var random: UIColor {
        var colors: [UIColor] = [.systemRed, .systemGreen, .systemBlue, .systemGray, .systemOrange, .systemPink, .systemPurple, .systemYellow]
        if #available(iOS 15, *) {
            colors.append(contentsOf: [.systemBrown, .systemCyan, .systemIndigo, .systemMint, .systemTeal])
        }
        return colors.randomElement()!
    }
}
