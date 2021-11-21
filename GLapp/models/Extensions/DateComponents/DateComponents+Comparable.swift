//
//  DateComponents+Comparable.swift
//  GLapp
//
//  Created by Miguel Themann on 02.11.21.
//

import Foundation

extension DateComponents: Comparable {
    public static func < (_ lhs: DateComponents, _ rhs: DateComponents) -> Bool {
        Calendar.current.date(byAdding: lhs, to: .rightNow)! < Calendar.current.date(byAdding: rhs, to: .rightNow)!
    }
}
