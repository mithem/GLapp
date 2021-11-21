//
//  DateComponents+plus+minus.swift
//  GLapp
//
//  Created by Miguel Themann on 28.10.21.
//

import Foundation

extension DateComponents: Differentiable {
    static func difference(_ lhs: DateComponents, to rhs: DateComponents) -> DateComponents {
        combine(lhs, rhs, multiplier: -1)
    }
    static func + (_ lhs: DateComponents, _ rhs: DateComponents) -> DateComponents {
        combine(lhs, rhs)
    }
}
