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
        currentComponents = Calendar(identifier: .gregorian).dateComponents([.year, .month, .day, .weekday], from: .init(timeIntervalSinceNow: 0))
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
        
        XCTAssertEqual(plan.summary, "test information 3; \(l1.summary), \(l2.summary); test information 1, test information 2, \(l3.summary)")
    }
}
