//
//  ClassTest+isOver.swift
//  GLapp
//
//  Created by Miguel Themann on 10.12.21.
//

import Foundation

extension ClassTest {
    var isOver: Bool {
        if let endDate = endDate {
            return .rightNow > endDate
        }
        return .rightNow > Calendar.current.date(byAdding: .init(day: 1), to: classTestDate) ?? classTestDate
    }
}
