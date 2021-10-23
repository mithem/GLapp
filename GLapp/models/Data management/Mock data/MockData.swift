//
//  MockData.swift
//  MockData
//
//  Created by Miguel Themann on 09.10.21.
//

import Foundation

struct MockData {
    static let dataManager = MockDataManager()
    static let subject = Subject(dataManager: dataManager, className: "M-LK2", subjectType: "LK", teacher: "PST")
    static let subject2 = Subject(dataManager: dataManager, className: "PH-LK1", subjectType: "LK", teacher: "SEN")
    static let subject3 = Subject(dataManager: dataManager, className: "EK-GK2", subjectType: "GKM", teacher: "BUS")
    static let subject4 = Subject(dataManager: dataManager, className: "PSE", subjectType: "PSE", teacher: "BLN", subjectName: "PSE")
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
    static let representativeLesson = RepresentativeLesson(date: .init(timeIntervalSinceNow: 3600), lesson: 5, room: "A10", newRoom: "A11", note: "Raumänderung", subject: subject)
    static let representativeLesson2 = RepresentativeLesson(date: .init(timeIntervalSinceNow: 10000), lesson: 2, room: "PR1", newRoom: nil, note: "EVA", subject: subject2)
    static let classTest = ClassTest(date: .init(timeIntervalSinceNow: -7200), classTestDate: .init(timeIntervalSinceNow: 604_800), start: 2, end: 5, room: "A10", subject: .init(dataManager: dataManager, className: "M-LK2"), teacher: "PST", individual: true, opened: true, alias: "M")
    static let classTest2 = ClassTest(date: .init(timeIntervalSinceNow: -7200), classTestDate: .init(timeIntervalSinceNow: 345_600), start: 4, end: 5, room: "E38", subject: .init(dataManager: dataManager, className: "KU-GK2"), teacher: "DUY", individual: true, opened: true, alias: "K")
    static let representativePlan = RepresentativePlan(date: .init(timeIntervalSinceNow: -1000), representativeDays: [.init(date: .init(timeIntervalSinceNow: 10000), lessons: [representativeLesson2, representativeLesson])], lessons: [], notes: ["Test-Eintrag für das Android-App-Team"])
    static let classTestPlan = ClassTestPlan(date: .init(timeIntervalSinceNow: -100000), classTests: [classTest, classTest2])
    static let timetable = Timetable(date: .init(timeIntervalSinceNow: -100000), weekdays: [
        .init(id: 0, lessons: [lesson, lesson2, lesson3, lesson4]),
        .init(id: 1, lessons: [lesson5, lesson6, lesson, lesson2]),
        .init(id: 2, lessons: [lesson3, lesson4, lesson9, lesson10]),
        .init(id: 3, lessons: [lesson7, lesson8, lesson2, lesson3]),
        .init(id: 4, lessons: [lesson5, lesson6, lesson7, lesson8])
    ])
}
