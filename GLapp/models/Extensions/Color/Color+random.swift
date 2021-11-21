//
//  Color+random.swift
//  GLapp
//
//  Created by Miguel Themann on 31.10.21.
//

import SwiftUI

extension Color {
    static var random: Self {
        var colors: [Color] = [.red, .green, .blue, .accentColor, .gray, .orange, .pink, .purple, .yellow]
        if #available(iOS 15, *) {
            colors.append(contentsOf: [.brown, .cyan, .indigo, .mint, .teal])
        }
        return colors.randomElement()!
    }
}
