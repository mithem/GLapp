//
//  CodableColor.swift
//  GLapp
//
//  Created by Miguel Themann on 26.11.21.
//

import SwiftUI

struct CodableColor: Codable {
    let color: UIColor
    
    func encode(to encoder: Encoder) throws {
        let nsCoder = NSKeyedArchiver(requiringSecureCoding: false)
        color.encode(with: nsCoder)
        var container = encoder.unkeyedContainer()
        try container.encode(nsCoder.encodedData)
    }
    
    init(_ color: UIColor) {
        self.color = color
    }
    
    init(_ color: Color) {
        self.color = .init(color)
    }
    
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let decodedData = try container.decode(Data.self)
        let nsCoder = try NSKeyedUnarchiver(forReadingFrom: decodedData)
        guard let color = UIColor(coder: nsCoder) else { throw GLappError.colorCodingError }
        self.color = color
    }
}
