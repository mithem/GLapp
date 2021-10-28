//
//  DateComponents+plus.swift
//  GLapp
//
//  Created by Miguel Themann on 28.10.21.
//

import Foundation

extension DateComponents {
    static func + (_ lhs: DateComponents, _ rhs: DateComponents) -> DateComponents {
        combine(lhs, rhs)
    }
}
