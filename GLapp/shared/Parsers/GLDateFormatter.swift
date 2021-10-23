//
//  GLDateFormatter.swift
//  GLDateFormatter
//
//  Created by Miguel Themann on 09.10.21.
//

import Foundation

class GLDateFormatter {
    static var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.timeZone = .current
        formatter.dateStyle = .long
        formatter.timeStyle = .medium
        return formatter
    }
    
    static var classTestDateParsingFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = .init(identifier: "de_DE")
        formatter.timeZone = .init(identifier: "Europe/Berlin")
        formatter.dateStyle = .short
        return formatter
    }
    
    static var parsingClassTestDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = .init(identifier: "de_DE")
        formatter.timeZone = .init(identifier: "Europe/Berlin")
        formatter.dateFormat = "YYYY-MM-dd HH-mm-ss"
        return formatter
    }
    
    static var dateOnlyFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.timeZone = .current
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }
    
    static var relativeDateTimeFormatter: RelativeDateTimeFormatter {
        let formatter = RelativeDateTimeFormatter()
        formatter.dateTimeStyle = .numeric
        return formatter
    }
}
