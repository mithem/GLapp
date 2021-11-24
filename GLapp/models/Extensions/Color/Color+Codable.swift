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
        let data = try container.decode(Data.self, forKey: .color)
        guard let uiColor = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data) else { throw DecodingError.valueNotFound(UIColor.self, .init(codingPath: [CodingKeys.color], debugDescription: "Could not unarchive valid UIColor.")) }
        self.init(uiColor)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let colorData = try NSKeyedArchiver.archivedData(withRootObject: UIColor(self), requiringSecureCoding: false)
        try container.encode(colorData, forKey: .color)
    }
    
    enum CodingKeys: CodingKey {
       case color
    }
}
