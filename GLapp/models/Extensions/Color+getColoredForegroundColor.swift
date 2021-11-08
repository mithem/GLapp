//
//  Color+getColoredForegroundColor.swift
//  GLapp
//
//  Created by Miguel Themann on 01.11.21.
//

import SwiftUI

extension Color {
    func getColoredForegroundColor(colorScheme: ColorScheme) -> Color {
        if isTransparent || self == .primary { return .primary }
        if colorScheme == .dark && isDark { return lighten() }
        if colorScheme == .light && !isDark { return darken() }
        return self
    }
}
