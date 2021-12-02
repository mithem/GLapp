//
//  MockData.swift
//  MockData
//
//  Created by Miguel Themann on 09.10.21.
//

import Foundation

struct MockData {
    static let dataManager = MockDataManager()
    static let subject = Subject(dataManager: dataManager, className: "M-LK2", subjectType: "LK", teacher: "PST", color: .blue)
    static let subject2 = Subject(dataManager: dataManager, className: "PH-LK1", subjectType: "LK", teacher: "SEN", color: .green)
    static let subject3 = Subject(dataManager: dataManager, className: "EK-GK2", subjectType: "GKM", teacher: "BUS", color: .purple)
    static let subject4 = Subject(dataManager: dataManager, className: "PSE", subjectType: "PSE", teacher: "BLN", subjectName: "PSE", color: .red)
    static let subject5 = Subject(dataManager: dataManager, className: "SPAN", subjectType: "SPAN", teacher: "SPAN", subjectName: "SPAN", color: .yellow)
    static let lesson = Lesson(lesson: 4, room: "A10", subject: subject)
    static let lesson2 = Lesson(lesson: 5, room: "A10", subject: subject)
    static let lesson3 = Lesson(lesson: 6, room: "PR2", subject: subject2)
    static let lesson4 = Lesson(lesson: 7, room: "PR2", subject: subject2)
    static let lesson5 = Lesson(lesson: 1, room: "A17", subject: subject3)
    static let lesson6 = Lesson(lesson: 2, room: "A16", subject: subject3)
    static let lesson7 = Lesson(lesson: 3, room: "FOR", subject: subject2)
    static let lesson8 = Lesson(lesson: 4, room: "FOR", subject: subject3)
    static let lesson9 = Lesson(lesson: 8, room: "IR3", subject: subject4)
    static let lesson10 = Lesson(lesson: 9, room: "IR3", subject: subject4)
    static let lesson11 = Lesson(lesson: 10, room: "SPANI", subject: subject5)
    static let lesson12 = Lesson(lesson: 4, room: "IR3", subject: subject4)
    static let lesson13 = Lesson(lesson: 5, room: "IR3", subject: subject4)
    static let representativeLesson = RepresentativeLesson(date: nDaysFromNow(), lesson: 5, room: "A10", newRoom: "A11", note: "Raumänderung", subject: subject, normalTeacher: "PST")
    static let representativeLesson2 = RepresentativeLesson(date: nDaysFromNow(), lesson: 2, room: "PR1", newRoom: nil, note: "EVA", subject: subject2, normalTeacher: "PR1")
    static let representativePlan = RepresentativePlan(date: .init(timeIntervalSinceNow: -600), representativeDays: [.init(date: nDaysFromNow(), lessons: [representativeLesson2, representativeLesson])], lessons: [], notes: ["Test-Eintrag für das Android-App-Team"])
    static let classTest = ClassTest(date: .init(timeIntervalSinceNow: -10000), classTestDate: nDaysFromNow(), start: 1, end: 1, room: "A11", subject: subject4, teacher: "ABC", individual: true, opened: true, alias: "PSE")
    static let classTest2 = ClassTest(date: .init(timeIntervalSinceNow: -7200), classTestDate: nDaysFromNow(7), start: 2, end: 5, room: "A10", subject: subject, teacher: "PST", individual: true, opened: true, alias: "M")
    static let classTest3 = ClassTest(date: .init(timeIntervalSinceNow: -7200), classTestDate: nDaysFromNow(2), start: 4, end: 5, room: "E38", subject: subject3, teacher: "DEF", individual: true, opened: true, alias: "K")
    static let classTestPlan = ClassTestPlan(date: .init(timeIntervalSinceNow: -100000), classTests: [classTest, classTest2, classTest3])
    static let timetable = Timetable(date: .init(timeIntervalSinceNow: -100000), weekdays: [
        .init(id: 0, lessons: [lesson, lesson2, lesson3, lesson4]),
        .init(id: 1, lessons: [lesson5, lesson6, lesson, lesson2]),
        .init(id: 2, lessons: [lesson12, lesson13, lesson3, lesson4, lesson9, lesson10]),
        .init(id: 3, lessons: [lesson7, lesson8, lesson2, lesson3]),
        .init(id: 4, lessons: [lesson5, lesson6, lesson7, lesson8, lesson11])
    ])
    
    static func nDaysFromNow(_ n: Int = 0) -> Date {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = .init(identifier: "Europe/Berlin")!
        var components = calendar.dateComponents([.year, .month, .day], from: .rightNow)
        components.day = components.day! + n
        return calendar.date(from: components)!
    }
}
