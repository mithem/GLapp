//
//  Differentiable.swift
//  GLapp
//
//  Created by Miguel Themann on 12.11.21.
//

import Foundation

/// Not about derivatives, but whether you can get the difference between two objects
protocol Differentiable {
    /// Get the difference between the `new` (lhs) and `old` (rhs) object
    static func difference(_ lhs: Self, to rhs: Self) -> Self
}

extension Differentiable {
    static func - (_ lhs: Self, _ rhs: Self) -> Self {
        difference(lhs, to: rhs)
    }
}
