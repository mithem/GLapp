//
//  TestClassTestPlanParser.swift
//  TestClassTestPlanParser
//
//  Created by Miguel Themann on 14.10.21.
//

import XCTest
@testable import GLapp

class TestClassTestPlanParser: XCTestCase {
    var manager: DataManager!
    
    override func setUpWithError() throws {
        manager = MockDataManager()
    }
    
    func testParseSuccess() throws {
        func d(month: Int, day: Int) -> Date {
            let components = DateComponents(year: 2021, month: month, day: day)
            return Calendar(identifier: .gregorian).date(from: components)!
        }
        let anyDate = Date(timeIntervalSinceNow: 0)
        let sPH = Subject(dataManager: manager, className: "PH-LK1", subjectType: nil, teacher: "SEN", subjectName: "PH")
        let sSW = Subject(dataManager: manager, className: "SW-GK1", subjectType: nil, teacher: "HBS", subjectName: "SW")
        let sM = Subject(dataManager: manager, className: "M-LK2", subjectType: nil, teacher: "PST", subjectName: "M")
        let expected = ClassTestPlan(date: .init(timeIntervalSince1970: 1632898504), classTests: [
            .init(date: anyDate, classTestDate: d(month: 10, day: 29), start: 2, end: 5, room: "PR2", subject: sPH, teacher: "SEN", individual: true, opened: true, alias: "PH-LK1"),
            .init(date: anyDate, classTestDate: d(month: 11, day: 2), start: nil, end: nil, room: nil, subject: sSW, teacher: "HBS", individual: false, opened: true, alias: "SW-GK1"),
            .init(date: anyDate, classTestDate: d(month: 12, day: 1), start: nil, end: nil, room: nil, subject: sM, teacher: "PST", individual: true, opened: false, alias: "M-LK2")
        ])
        
        let result = try ClassTestPlanParser.parse(plan: MockData.validClassTestPlanString, with: manager).get()
        
        XCTAssertEqual(result.date, expected.date)
        XCTAssertEqual(result.classTests.count, expected.classTests.count)
        for i in 0 ..< expected.classTests.count {
            XCTAssertEqual(result.classTests[i].subject, expected.classTests[i].subject)
            XCTAssertEqual(result.classTests[i], expected.classTests[i])
        }
    }
    
    func testParseNoRootElement() {
        let result = ClassTestPlanParser.parse(plan: "", with: manager)
        XCTAssertEqual(result, .failure(.noRootElement))
    }
    
    func testParseInvalidRootElement() {
        let result = ClassTestPlanParser.parse(plan: "<Element></Element>", with: manager)
        XCTAssertEqual(result, .failure(.invalidRootElement))
    }
    
    func testParseNoTimestamp() {
        let result = ClassTestPlanParser.parse(plan: "<Klausurplan></Klausurplan>", with: manager)
        XCTAssertEqual(result, .failure(.noTimestamp))
    }
    
    func testSecondaryStageI() {
        let result = ClassTestPlanParser.parse(plan: MockData.emptyClassTestPlanString, with: manager)
        XCTAssertEqual(result, .failure(.noTimestamp))
    }
    
    func testParseInvalidTimestamp() {
        let plan = """
<Klausurplan Timestamp="2021-10-15T00:00:00Z"></Klausurplan>
"""
        
        let result = ClassTestPlanParser.parse(plan: plan, with: manager)
        
        XCTAssertEqual(result, .failure(.invalidTimestamp))
    }
}
