//
//  RepresentativeLesson.swift
//  RepresentativeLesson
//
//  Created by Miguel Themann on 01.10.21.
//

import Foundation

struct RepresentativeLesson: Equatable, Identifiable, Codable, DeliverableByNotification {
    var id: Date { startDate }
    
    var date: Date
    var lesson: Int
    var room: String?
    var newRoom: String?
    var note: String?
    var subject: Subject
    var normalTeacher: String
    var representativeTeacher: String?
    
    var startDate: Date {
        return Calendar.current.date(byAdding: Constants.lessonStartDateComponents[lesson]!, to: date)!
    }
    
    var endDate: Date {
        return Calendar.current.date(byAdding: Constants.lessonEndDateComponents[lesson]!, to: date)!
    }
    
    var isOver: Bool {
        return .rightNow > endDate
    }
    
    var summary: String {
        let timeInterval = date.timeIntervalSinceNow
        let timeDescription: String
        if timeInterval > 2 * 24 * 60 * 60 { // 2 days
            timeDescription = GLDateFormatter.relativeDateTimeFormatter.localizedString(fromTimeInterval: timeInterval)
        } else {
            let components = Calendar.current.dateComponents([.year, .month, .day, .weekday], from: date)
            let todayComponents = Calendar.current.dateComponents([.year, .month, .day, .weekday], from: .rightNow)
            if components == todayComponents {
                timeDescription = NSLocalizedString("today")
            } else if let weekday = components.weekday {
                let str = Constants.weekdayIDStringMap[weekday - 1]! // weekdays are from 1-7
                timeDescription = NSLocalizedString(str)
            } else {
                timeDescription = GLDateFormatter.relativeDateTimeFormatter.localizedString(fromTimeInterval: timeInterval)
            }
        }
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        var summary = "\(timeDescription) \(formatter.string(from: .init(value: lesson))!) \(subject.subjectName ?? subject.className)"
        if let newRoom = newRoom {
            summary += " \(NSLocalizedString("in_mid_sentence")) \(newRoom)"
        }
        if let representativeTeacher = representativeTeacher {
            summary += " \(NSLocalizedString("with_mid_sentence")) \(representativeTeacher)"
        }
        if let note = note {
            if note.starts(with: "(") && note.last! == ")" {
                summary += " \(note)"
            } else {
                summary += " (\(note))"
            }
        }
        return summary
    }
    
    var notificationId: KeyPath<Constants.Identifiers.Notifications, String>? { \.reprPlanUpdateNotification }
    
    var title: String { "repr_plan_update" }
    
    var interruptionLevel: NotificationManager.InterruptionLevel {
        return relevance < 3 ? .timeSensitive : .default
    }
    
    var relevance: Double {
        let timeInterval = startDate.timeIntervalSince(.rightNow)
        let cutoff = 12.0
        let hours = timeInterval / 3600
        if hours > cutoff {
            return 0
        }
        return cutoff - hours
    }
}
