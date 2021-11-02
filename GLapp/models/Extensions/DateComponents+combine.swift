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
         result.second = (lhs.second ?? 0) + (rhs.second ?? 0) * multiplier
        result.minute = (lhs.minute ?? 0) + (rhs.minute ?? 0) * multiplier
        result.hour = (lhs.hour ?? 0) + (rhs.hour ?? 0) * multiplier
        result.day = (lhs.day ?? 0) + (rhs.day ?? 0) * multiplier
        result.month = (lhs.month ?? 0) + (rhs.day ?? 0) * multiplier
        result.year = (lhs.year ?? 0) + (rhs.year ?? 0) * multiplier
        return result
    }
}
