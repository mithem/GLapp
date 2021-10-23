//
//  CodableColor+Equatable.swift
//  CodableColor+Equatable
//
//  Created by Miguel Themann on 17.10.21.
//

import Foundation

extension CodableColor: Equatable {
    static func == (lhs: CodableColor, rhs: CodableColor) -> Bool {
        lhs.red == rhs.red && lhs.green == rhs.green && lhs.blue == rhs.blue && lhs.alpha == rhs.alpha
    }
}
