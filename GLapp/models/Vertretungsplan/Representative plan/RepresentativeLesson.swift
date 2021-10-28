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
        let timeDescription: String
        if timeInterval > 2 * 24 * 60 * 60 { // 2 days
            timeDescription = GLDateFormatter.relativeDateTimeFormatter.localizedString(fromTimeInterval: timeInterval)
        } else {
            let components = Calendar.current.dateComponents([.year, .month, .day, .weekday], from: date)
            let todayComponents = Calendar.current.dateComponents([.year, .month, .day, .weekday], from: now)
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
}
