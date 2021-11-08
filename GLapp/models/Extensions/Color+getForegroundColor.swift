//
//  Color+getForegroundColor.swift
//  GLapp
//
//  Created by Miguel Themann on 05.11.21.
//

import SwiftUI

extension Color {
    func getForegroundColor(colorScheme: ColorScheme) -> Color {
        if isTransparent || self == .primary { return .primary }
        if isDark { return .white }
        return .black
    }
}
