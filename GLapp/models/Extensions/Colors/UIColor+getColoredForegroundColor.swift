//
//  UIColor+getColoredForegroundColor.swift
//  GLapp
//
//  Created by Miguel Themann on 01.11.21.
//

import SwiftUI

extension UIColor {
    func getColoredForegroundColor(colorScheme: ColorScheme) -> UIColor {
        if isTransparent || self == .label { return .label }
        if colorScheme == .dark && isDark { return lighten() }
        if colorScheme == .light && !isDark { return darken() }
        return self
    }
}
