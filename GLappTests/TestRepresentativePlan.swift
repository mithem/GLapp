//
//  TestRepresentativePlan.swift
//  GLappTests
//
//  Created by Miguel Themann on 28.10.21.
//

import XCTest
@testable import GLapp

class TestRepresentativePlan: XCTestCase {
    var dataManager: DataManager!
    var currentComponents: DateComponents!
    var date: Date!
    var berlinCalendar: Calendar!
    var sPH: Subject!
    var sM: Subject!
    var sD: Subject!
    var formatter: NumberFormatter!
    
    override func setUpWithError() throws {
        dataManager = MockDataManager()
        currentComponents = Calendar(identifier: .gregorian).dateComponents([.year, .month, .day, .weekday], from: .rightNow)
        berlinCalendar = .init(identifier: .gregorian)
        berlinCalendar.timeZone = .init(identifier: "Europe/Berlin")!
        date = berlinCalendar.date(from: .init(calendar: berlinCalendar, timeZone: .init(identifier: "Europe/Berlin"), year: currentComponents.year!, month: currentComponents.month!, day: currentComponents.day!))!
        sPH = Subject(dataManager: dataManager, className: "PH", teacher: "SEN", subjectName: "PH")
        sM = Subject(dataManager: dataManager, className: "M", teacher: "PST", subjectName: "M")
        sD = Subject(dataManager: dataManager, className: "D", teacher: "DRO", subjectName: "D")
        formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
    }
    
    func testSummary() {
        let yesterday = berlinCalendar.date(byAdding: .init(day: -1), to: date)!
        let tomorrow = berlinCalendar.date(byAdding: .init(day: 1), to: date)!
        let l1 = RepresentativeLesson(date: date, lesson: 4, room: "PR2", newRoom: nil, note: "Vertretung", subject: sPH, normalTeacher: "SEN", representativeTeacher: "DOH")
        let l2 = RepresentativeLesson(date: date, lesson: 5, room: "PR2", newRoom: nil, note: "Vertretung", subject: sPH, normalTeacher: "SEN", representativeTeacher: "DOH")
        let l3 = RepresentativeLesson(date: tomorrow, lesson: 2, room: "A16", newRoom: "A18", note: "Raumänderung", subject: sD, normalTeacher: "DRO", representativeTeacher: nil)
        let plan = RepresentativePlan(date: yesterday, representativeDays: [
            .init(date: date, lessons: [l1, l2], notes: ["test information 1", "test information 2"]),
            .init(date: tomorrow, lessons: [l3], notes: [])
        ], lessons: [], notes: ["test information 3"])
        
        XCTAssertEqual(plan.notificationSummary, "test information 3; \(l1.notificationSummary), \(l2.notificationSummary); test information 1, test information 2, \(l3.notificationSummary)")
    }
    
    func testSummary2() {
        let calendar = Calendar(identifier: .gregorian)
        let components = DateComponents(calendar: calendar, timeZone: .init(identifier: "Europe/Berlin"), year: 2022, month: 1, day: 10, hour: 0, minute: 0)
        let date = calendar.date(from: components)!
        let l = RepresentativeLesson(date: date, lesson: 2, room: "A16", newRoom: nil, note: "", subject: sD, normalTeacher: "DRO", representativeTeacher: nil)
        let plan = RepresentativePlan(date: date, representativeDays: [
            .init(date: date, lessons: [l], notes: [])
        ], lessons: [], notes: [])
        
        XCTAssertEqual(plan.notificationSummary, l.notificationSummary)
    }
    
    func testDifferenceIdentical() {
        let cal = Calendar(identifier: .gregorian)
        let todayComp = cal.dateComponents([.year, .month, .day], from: .rightNow)
        var tomorrowComp = todayComp
        tomorrowComp.day! += 1
        let today = cal.date(from: todayComp)!
        let tomorrow = cal.date(from: tomorrowComp)!
        let plan = RepresentativePlan(date: today, representativeDays: [
            .init(date: today, lessons: [
                .init(date: today, lesson: 2, room: "PR2", newRoom: "PR1", note: "Raumänderung", subject: sPH, normalTeacher: "SEN", representativeTeacher: nil)
            ], notes: ["Hello, world!"]),
            .init(date: tomorrow, lessons: [
                .init(date: tomorrow, lesson: 5, room: "A16", newRoom: "E32", note: "Raumänderung", subject: sD, normalTeacher: "DRO", representativeTeacher: nil)
            ], notes: [
                "Hello, there!"
            ])
        ], lessons: [
            .init(date: today, lesson: 1, room: "A11", newRoom: nil, note: "EVA", subject: sM, normalTeacher: "PST", representativeTeacher: nil)
        ], notes: [
            "This is a test"
        ])
        let expected = RepresentativePlan(date: today, representativeDays: [], lessons: [], notes: [])
        
        XCTAssert(RepresentativePlan.difference(plan, to: plan).isEmpty)
        XCTAssertEqual(RepresentativePlan.difference(plan, to: plan), expected)
    }
    
    func testDifferenceNotes() {
        let cal = Calendar(identifier: .gregorian)
        let todayComp = cal.dateComponents([.year, .month, .day], from: .rightNow)
        var tomorrowComp = todayComp
        tomorrowComp.day! += 1
        let today = cal.date(from: todayComp)!
        let tomorrow = cal.date(from: tomorrowComp)!
        let plan1 = RepresentativePlan(date: today, representativeDays: [
            .init(date: today, lessons: [
                .init(date: today, lesson: 2, room: "PR2", newRoom: "PR1", note: "Raumänderung", subject: sPH, normalTeacher: "SEN", representativeTeacher: nil)
            ], notes: ["Hello, world!"]),
            .init(date: tomorrow, lessons: [
                .init(date: tomorrow, lesson: 5, room: "A16", newRoom: "E32", note: "Raumänderung", subject: sD, normalTeacher: "DRO", representativeTeacher: nil)
            ], notes: [
                "Hello, there!"
            ])
        ], lessons: [
            .init(date: today, lesson: 1, room: "A11", newRoom: nil, note: "EVA", subject: sM, normalTeacher: "PST", representativeTeacher: nil)
        ], notes: [
            "This is a test"
        ])
        let plan2 = plan1.copy()
        plan2.notes.append("Test message")
        let expected = RepresentativePlan(date: today, representativeDays: [], lessons: [], notes: ["Test message"])
        
        let dif = RepresentativePlan.difference(plan1, to: plan2)
        
        XCTAssertFalse(dif.isEmpty)
        XCTAssertEqual(dif, expected)
    }
    
    func testDifferenceOneMoreDay() {
        let cal = Calendar(identifier: .gregorian)
        let todayComp = cal.dateComponents([.year, .month, .day], from: .rightNow)
        var tomorrowComp = todayComp
        tomorrowComp.day! += 1
        var inTwoDaysComponents = tomorrowComp
        inTwoDaysComponents.day! += 1
        let today = cal.date(from: todayComp)!
        let tomorrow = cal.date(from: tomorrowComp)!
        let inTwoDays = cal.date(from: inTwoDaysComponents)!
        let plan1 = RepresentativePlan(date: today, representativeDays: [
            .init(date: today, lessons: [
                .init(date: today, lesson: 2, room: "PR2", newRoom: "PR1", note: "Raumänderung", subject: sPH, normalTeacher: "SEN", representativeTeacher: nil)
            ], notes: ["Hello, world!"]),
            .init(date: tomorrow, lessons: [
                .init(date: tomorrow, lesson: 5, room: "A16", newRoom: "E32", note: "Raumänderung", subject: sD, normalTeacher: "DRO", representativeTeacher: nil)
            ], notes: [
                "Hello, there!"
            ])
        ], lessons: [
            .init(date: today, lesson: 1, room: "A11", newRoom: nil, note: "EVA", subject: sM, normalTeacher: "PST", representativeTeacher: nil)
        ], notes: [
            "This is a test"
        ])
        let plan2 = plan1.copy()
        let day = RepresentativeDay(date: inTwoDays, lessons: [
            .init(date: inTwoDays, lesson: 3, room: "A11", newRoom: nil, note: "EVA", subject: sM, normalTeacher: "PST", representativeTeacher: nil)
        ], notes: [])
        plan2.representativeDays.append(day)
        let expected = RepresentativePlan(date: today, representativeDays: [day], lessons: [], notes: [])
        
        let dif = RepresentativePlan.difference(plan2, to: plan1)
        
        XCTAssertFalse(dif.isEmpty)
        XCTAssertEqual(dif, expected)
    }
    
    func testDifferenceAllTogetherNow() {
        let cal = Calendar(identifier: .gregorian)
        let todayComp = cal.dateComponents([.year, .month, .day], from: .rightNow)
        var tomorrowComp = todayComp
        tomorrowComp.day! += 1
        var inTwoDaysComponents = tomorrowComp
        inTwoDaysComponents.day! += 1
        let today = cal.date(from: todayComp)!
        let tomorrow = cal.date(from: tomorrowComp)!
        let inTwoDays = cal.date(from: inTwoDaysComponents)!
        let plan1 = RepresentativePlan(date: today, representativeDays: [
            .init(date: today, lessons: [
                .init(date: today, lesson: 2, room: "PR2", newRoom: "PR1", note: "Raumänderung", subject: sPH, normalTeacher: "SEN", representativeTeacher: nil)
            ], notes: ["Hello, world!"]),
            .init(date: tomorrow, lessons: [
                .init(date: tomorrow, lesson: 6, room: "A16", newRoom: "E32", note: "Raumänderung", subject: sD, normalTeacher: "DRO", representativeTeacher: nil)
            ], notes: [
                "Hello, there!"
            ])
        ], lessons: [
            .init(date: today, lesson: 1, room: "A11", newRoom: nil, note: "EVA", subject: sM, normalTeacher: "PST", representativeTeacher: nil)
        ], notes: [
            "This is a test"
        ])
        let plan2 = plan1.copy()
        let day = RepresentativeDay(date: inTwoDays, lessons: [
            .init(date: inTwoDays, lesson: 3, room: "A11", newRoom: nil, note: "EVA", subject: sM, normalTeacher: "PST", representativeTeacher: nil)
        ], notes: [])
        plan2.representativeDays[1].notes.append("1234")
        plan2.representativeDays[1].lessons[0] = .init(date: tomorrow, lesson: 6, room: "A16", newRoom: "E31", note: "Raumänderung", subject: sD, normalTeacher: "DRO", representativeTeacher: nil)
        plan2.representativeDays[1].lessons.append(.init(date: tomorrow, lesson: 7, room: "A16", newRoom: "E31", note: "Raumänderung", subject: sD, normalTeacher: "DRO", representativeTeacher: nil))
        plan2.representativeDays.append(day)
        plan2.notes.append("Yet another test!")
        let expected = RepresentativePlan(date: today, representativeDays: [
            .init(date: tomorrow, lessons: [
                .init(date: tomorrow, lesson: 6, room: "A16", newRoom: "E31", note: "Raumänderung", subject: sD, normalTeacher: "DRO", representativeTeacher: nil),
                .init(date: tomorrow, lesson: 7, room: "A17", newRoom: "E31", note: "Raumänderung", subject: sD, normalTeacher: "DRO", representativeTeacher: nil)
            ], notes: ["1234"]),
            day
        ], lessons: [], notes: ["Yet another test!"])
        
        let dif = RepresentativePlan.difference(plan2, to: plan1)
        
        XCTAssertFalse(dif.isEmpty)
        XCTAssertEqual(dif, expected)
    }
}
