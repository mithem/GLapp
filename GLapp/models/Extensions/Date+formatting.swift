//
//  Date+formatted.swift
//  Date+formatted
//
//  Created by Miguel Themann on 09.10.21.
//

import Foundation

extension Date {
    var formattedWithLocale: String {
        return GLDateFormatter.formatter.string(from: self)
    }
    var formattedWithLocaleOnlyDay: String {
        return GLDateFormatter.dateOnlyFormatter.string(from: self)
    }
}
