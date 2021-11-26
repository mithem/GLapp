//
//  UIColor+getForegroundColor.swift
//  GLapp
//
//  Created by Miguel Themann on 05.11.21.
//

import SwiftUI

extension UIColor {
    func getForegroundColor(colorScheme: ColorScheme) -> UIColor {
        if isTransparent || self == .label { return .label }
        if isDark { return .white }
        return .black
    }
}
