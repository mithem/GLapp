//
//  Date+today.swift
//  GLapp
//
//  Created by Miguel Themann on 18.12.21.
//

import Foundation

extension Date {
    static func today(at: DateComponents) -> Date {
        var today = Calendar.current.dateComponents([.calendar, .timeZone, .year, .month, .day], from: .rightNow)
        var addComponents = at
        addComponents.year = nil
        addComponents.month = nil
        addComponents.day = nil
        today.hour = 0
        today.minute = 0 // so DateComponents.combine respects rhs's (`addComponents`) hour & minute
        let combination = today + addComponents
        return Calendar.current.date(from: combination)! // please don't fail
    }
}
