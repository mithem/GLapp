//
//  TestRepresentativeLesson.swift
//  GLappTests
//
//  Created by Miguel Themann on 26.10.21.
//

import XCTest
@testable import GLapp

class TestRepresentativeLesson: XCTestCase {
    func testSummary() throws {
        let dataManager = MockDataManager()
        let date = Calendar(identifier: .gregorian).date(from: .init(calendar: .init(identifier: .gregorian), timeZone: .init(identifier: "Europe/Berlin"), year: 2021, month: 10, day: 27))!
        let sPH = Subject(dataManager: dataManager, className: "PH", teacher: "SEN", subjectName: "PH")
        let lesson = RepresentativeLesson(date: date, lesson: 1, room: "PR2", newRoom: nil, note: "(frei)", subject: sPH, normalTeacher: "SEN", representativeTeacher: nil)
        
        XCTAssertEqual(lesson.summary, "")
    }
}
