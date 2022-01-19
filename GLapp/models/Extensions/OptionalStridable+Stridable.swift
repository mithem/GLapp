//
//  OptionalStridable+Stridable.swift
//  GLapp
//
//  Created by Miguel Themann on 13.01.22.
//

import Foundation

extension Optional: Comparable where Wrapped: Comparable {
    public static func < (lhs: Optional, rhs: Optional) -> Bool {
        if let lhs = lhs {
            if let rhs = rhs {
                return lhs < rhs
            }
            return false
        }
        if rhs != nil, lhs == nil {
            return true
        }
        return false
    }
}

extension Optional: Strideable where Wrapped: SignedNumeric, Wrapped: Strideable {
    public func distance(to other: Optional<Wrapped>) -> Wrapped.Stride {
        if let selff = self {
            if let other = other {
                return self.distance(to: other)
            }
            return selff.distance(to: .zero)
        }
        if let other = other {
            return other.distance(to: .zero)
        }
        return .zero
    }
    
    public func advanced(by n: Wrapped.Stride) -> Optional<Wrapped> {
        if let selff = self {
            return selff.advanced(by: n)
        }
        return nil
    }
    
    public typealias Stride = Wrapped.Stride
}
