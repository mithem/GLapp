//
//  DateComponents+combine.swift
//  GLapp
//
//  Created by Miguel Themann on 28.10.21.
//

import Foundation

extension DateComponents {
    static func combine(_ lhs: DateComponents, _ rhs: DateComponents, multiplier: Int = 1) -> DateComponents {
        var result = DateComponents()
        if let l = lhs.second {
            result.second = l + (rhs.second ?? 0) * multiplier
        }
        if let l = lhs.minute {
            result.minute  = l + (rhs.minute ?? 0) * multiplier
        }
        if let l = lhs.hour {
            result.hour  = l + (rhs.hour ?? 0) * multiplier
        }
        if let l = lhs.day {
            result.day  = l + (rhs.day ?? 0) * multiplier
        }
        if let l = lhs.month {
            result.month  = l + (rhs.month ?? 0) * multiplier
        }
        if let l = lhs.year {
            result.year  = l + (rhs.year ?? 0) * multiplier
        }
        return result
    }
}
