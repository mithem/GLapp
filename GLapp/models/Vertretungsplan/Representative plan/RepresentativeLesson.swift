//
//  RepresentativeLesson.swift
//  RepresentativeLesson
//
//  Created by Miguel Themann on 01.10.21.
//

import Foundation

struct RepresentativeLesson: Equatable, Identifiable, Codable, DeliverableByNotification {
    var id: Date { date }
    
    var date: Date
    var lesson: Int
    var room: String?
    var newRoom: String?
    var note: String?
    var subject: Subject
    var normalTeacher: String
    var representativeTeacher: String?
    
    var summary: String {
        let now: Date
        if #available(iOS 15, *) {
            now = .now
        } else {
            now = .init(timeIntervalSinceNow: 0)
        }
        let timeInterval = date.timeIntervalSince(now)
        if timeInterval > 2 * 24 * 60 * 60 { // 2 days
            return GLDateFormatter.relativeDateTimeFormatter.localizedString(fromTimeInterval: timeInterval)
        } else {
            let components = Calendar.current.dateComponents([.weekday], from: date)
            let str = Constants.weekdayIDStringMap[components.weekday!]!
            return NSLocalizedString(str)
        }
    }
}
