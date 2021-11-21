//
//  RepresentativeLesson+DeliverableByNotification.swift
//  GLapp
//
//  Created by Miguel Themann on 21.11.21.
//

import Foundation

extension RepresentativeLesson: DeliverableByNotification {
     var notificationSummary: String {
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
    
    var notificationTitle: String { "repr_plan_update" }
    
     var interruptionLevel: NotificationManager.InterruptionLevel {
         return relevance >= 0.499 ? .timeSensitive : .active // scared of rounding errors ruining the math
    }
    
    var relevance: Double {
        let timeInterval = startDate.timeIntervalSince(.rightNow)
        if timeInterval < 0 {
            return 1
        }
        var highRelevanceInterval = UserDefaults.standard.double(forKey: UserDefaultsKeys.reprPlanNotificationsHighRelevanceTimeInterval)
        if highRelevanceInterval == 0 {
            highRelevanceInterval = Constants.defaultReprPlanNotificationsHighRelevanceTimeInterval
        }
        if timeInterval > 2 * highRelevanceInterval {
            return 0
        }
        let relevance = 2 * highRelevanceInterval - timeInterval
        return relevance / (2 * highRelevanceInterval) // normalize so user adjustments don't mess up the system's interpretation of previous relevance values
    }
}
