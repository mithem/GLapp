//
//  GLDateFormatter.swift
//  GLDateFormatter
//
//  Created by Miguel Themann on 09.10.21.
//

import Foundation

class GLDateFormatter {
    static var berlinFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"
        formatter.timeZone = .init(identifier: "Europe/Berlin")
        return formatter
    }
    
    static var localFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
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
    
    static var dateComponentsFormatter: DateComponentsFormatter {
        let formatter = DateComponentsFormatter()
        formatter.formattingContext = .standalone
        formatter.allowedUnits = [.day, .hour, .minute, .second]
        formatter.unitsStyle = .full
        return formatter
    }
}
