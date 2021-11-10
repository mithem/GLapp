//
//  RepresentativeLesson.swift
//  RepresentativeLesson
//
//  Created by Miguel Themann on 01.10.21.
//

import Foundation

final class RepresentativeLesson: ObservableObject, Identifiable, DeliverableByNotification {
    var id: Date { startDate }
    @Published var date: Date
    @Published var lesson: Int
    @Published var room: String?
    @Published var newRoom: String?
    @Published var note: String?
    @Published var subject: Subject
    @Published var normalTeacher: String
    @Published var representativeTeacher: String?
    
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
         let highRelevanceInterval = UserDefaults.standard.double(forKey: UserDefaultsKeys.reprPlanNotificationsHighRelevanceTimeInterval)
         return relevance >= highRelevanceInterval ? .timeSensitive : .active
    }
    
    var relevance: Double {
        let timeInterval = startDate.timeIntervalSince(.rightNow)
        var cutoff = UserDefaults.standard.double(forKey: UserDefaultsKeys.reprPlanNotificationsHighRelevanceTimeInterval)
        if cutoff == 0 {
            cutoff = Constants.defaultReprPlanNotificationsHighRelevanceTimeInterval
        }
        if timeInterval > 2 * cutoff {
            return 0
        }
        let relevance = 2 * cutoff - timeInterval
        return relevance / (2 * cutoff) // normalize so user adjustments don't mess up the system's interpretation of previous relevance values
    }
    
    func updateSubject(with dataManager: DataManager) {
        subject = dataManager.getSubject(subjectName: subject.subjectName ?? subject.className, className: nil) // assume className is unkown
    }
    
    init(date: Date, lesson: Int, room: String?, newRoom: String?, note: String?, subject: Subject, normalTeacher: String, representativeTeacher: String? = nil) {
        self.date = date
        self.lesson = lesson
        self.room = room
        self.newRoom = newRoom
        self.note = note
        self.subject = subject
        self.normalTeacher = normalTeacher
        self.representativeTeacher = representativeTeacher
    }
}
