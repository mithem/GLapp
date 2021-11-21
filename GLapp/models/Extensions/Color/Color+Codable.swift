//
//  Color+Codable.swift
//  GLapp
//
//  Created by Miguel Themann on 31.10.21.
//

import SwiftUI

extension Color: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let red = try container.decode(Double.self, forKey: .red)
        let green = try container.decode(Double.self, forKey: .green)
        let blue = try container.decode(Double.self, forKey: .blue)
        let alpha = try container.decode(Double.self, forKey: .alpha)
        self.init(red: red, green: green, blue: blue, opacity: alpha)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var red: CGFloat = .nan
        var green: CGFloat = .nan
        var blue: CGFloat = .nan
        var alpha: CGFloat = .nan
        UIColor(self).getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        try container.encode(red, forKey: .red)
        try container.encode(green, forKey: .green)
        try container.encode(blue, forKey: .blue)
        try container.encode(alpha, forKey: .alpha)
    }
    
    enum CodingKeys: CodingKey {
       case red, green, blue, alpha
    }
}
