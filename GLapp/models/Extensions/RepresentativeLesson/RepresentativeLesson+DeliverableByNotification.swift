//
//  RepresentativeLesson+DeliverableByNotification.swift
//  GLapp
//
//  Created by Miguel Themann on 21.11.21.
//

import Foundation

extension RepresentativeLesson: DeliverableByNotification {
     var notificationSummary: String {
         if isInvalid {
             return ""
         }
         let timeInterval = date.timeIntervalSinceNow
         let timeDescription: String
         if timeInterval < -24 * 60 * 60 || timeInterval > 2 * 24 * 60 * 60 { // 2 days
             //timeDescription = GLDateFormatter.numericRelativeDateTimeFormatter.localizedString(fromTimeInterval: timeInterval)
             timeDescription = GLDateFormatter.dateOnlyFormatter.string(from: date)
         } else {
             let components = Calendar.current.dateComponents([.calendar, .timeZone, .year, .month, .day, .weekday], from: date)
             let todayComponents = Calendar.current.dateComponents([.calendar, .timeZone, .year, .month, .day, .weekday], from: .rightNow)
             timeDescription = GLDateFormatter.namedRelativeDateTimeFormatter.localizedString(from: components - todayComponents)
         }
         let formatter = NumberFormatter()
         formatter.numberStyle = .ordinal
         let subjectDescription = subject?.subjectName ?? subject?.className
         var summary = "\(timeDescription) \(formatter.string(from: .init(value: lesson))!)"
         if let subjectDescription = subjectDescription {
             summary += " " + subjectDescription
         }
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
        var highRelevanceInterval = UserDefaults.standard.double(for: \.reprPlanNotificationsHighRelevanceTimeInterval)
        if highRelevanceInterval == 0 {
            highRelevanceInterval = UserDefaults.standard.double(for: SettingsStore().reprPlanNotificationsHighRelevanceTimeInterval.key)
        }
        if timeInterval > 2 * highRelevanceInterval {
            return 0
        }
        let relevance = 2 * highRelevanceInterval - timeInterval
        return relevance / (2 * highRelevanceInterval) // normalize so user adjustments don't mess up the system's interpretation of previous relevance values
    }
}
