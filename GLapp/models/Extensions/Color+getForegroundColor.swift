//
//  Color+getForegroundColor.swift
//  GLapp
//
//  Created by Miguel Themann on 01.11.21.
//

import SwiftUI

extension Color {
    func getForegroundColor(colorScheme: ColorScheme) -> Color {
        if colorScheme == .dark && isDark {
            return lighten()
        }
        if colorScheme == .light && !isDark {
            return darken()
        }
        return self
    }
}
