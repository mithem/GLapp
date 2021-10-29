//
//  CodableColor.swift
//  CodableColor
//
//  Created by Miguel Themann on 17.10.21.
//

import SwiftUI

class CodableColor: Codable {
    var red: CGFloat
    var green: CGFloat
    var blue: CGFloat
    var alpha: CGFloat
    
    var colorBinding: Binding<Color> {
        return Binding(get: {
            Color(red: self.red, green: self.green, blue: self.blue, opacity: self.alpha)
        }, set: { color in
            UIColor(color).getRed(&self.red, green: &self.green, blue: &self.blue, alpha: &self.alpha)
        })
    }
    
    init(_ color: Color) {
        red = .nan
        green = .nan
        blue = .nan
        alpha = .nan
        DispatchQueue.main.async { // otherwise might (or not) result in mysterious crashes..
            // actually not even a joke
            UIColor(color).getRed(&self.red, green: &self.green, blue: &self.blue, alpha: &self.alpha)
        }
    }
    
    static var random: CodableColor {
        var colors: [Color] = [.red, .green, .blue, .accentColor, .gray, .orange, .pink, .purple, .yellow]
        if #available(iOS 15, *) {
            colors.append(contentsOf: [.brown, .cyan, .indigo, .mint, .teal])
        }
        return CodableColor(colors.randomElement() ?? colors.first!)
    }
}
