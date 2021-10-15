//
//  TestClassTestPlanParser.swift
//  TestClassTestPlanParser
//
//  Created by Miguel Themann on 14.10.21.
//

import XCTest
@testable import GLapp

class TestClassTestPlanParser: XCTestCase {
    func testParseSuccess() throws {
        let plan = """
<Klausurplan Stand="29.09.2021 08:55:04" Timestamp="1632898504">
<Klausur individuell="1" Datum="29.10.2021" freigegeben="1" vonStd="2" bisStd="5" raum="PR2" bezeichnung="PH-LK1" fach="PH" stand="2021-09-29 08:55:05" lehrer="SEN"/>
<Klausur individuell="0" Datum="02.11.2021" freigegeben="1" vonStd="-" bisStd="-" raum="-" bezeichnung="SW-GK1" fach="SW" stand="2021-09-29 08:55:05" lehrer="HBS"/>
<Klausur individuell="1" Datum="01.12.2021" freigegeben="0" vonStd="-" bisStd="-" raum="-" bezeichnung="M-LK2" fach="M" stand="2021-09-29 08:55:07" lehrer="PST"/>
</Klausurplan>
"""
        func d(month: Int, day: Int) -> Date {
            let components = DateComponents(year: 2021, month: month, day: day)
            return Calendar.current.date(from: components)!
        }
        let anyDate = Date(timeIntervalSinceNow: 0)
        let sPH = Subject(className: "PH-LK1", subjectType: nil, teacher: "SEN", subjectName: "PH")
        let sSW = Subject(className: "SW-GK1", subjectType: nil, teacher: "HBS", subjectName: "SW")
        let sM = Subject(className: "M-LK2", subjectType: nil, teacher: "PST", subjectName: "M")
        let expected = ClassTestPlan(date: .init(timeIntervalSince1970: 1632898504), classTests: [
            .init(date: anyDate, classTestDate: d(month: 10, day: 29), start: 2, end: 5, room: "PR2", subject: sPH, teacher: "SEN", individual: true, opened: true, alias: "PH-LK1"),
            .init(date: anyDate, classTestDate: d(month: 11, day: 2), start: nil, end: nil, room: nil, subject: sSW, teacher: "HBS", individual: false, opened: true, alias: "SW-GK1"),
            .init(date: anyDate, classTestDate: d(month: 12, day: 1), start: nil, end: nil, room: nil, subject: sM, teacher: "PST", individual: true, opened: false, alias: "M-LK2")
        ])
        
        let result = ClassTestPlanParser.parse(plan: plan)
        
        XCTAssertEqual(try result.get(), expected)
    }
    
    func testParseNoRootElement() {
        let result = ClassTestPlanParser.parse(plan: "")
        XCTAssertEqual(result, .failure(.noRootElement))
    }
    
    func testParseInvalidRootElement() {
        let result = ClassTestPlanParser.parse(plan: "<Element></Element>")
        XCTAssertEqual(result, .failure(.invalidRootElement))
    }
    
    func testParseNoTimestamp() {
        let result = ClassTestPlanParser.parse(plan: "<Klausurplan></Klausurplan>")
        XCTAssertEqual(result, .failure(.noTimestamp))
    }
    
    func testParseInvalidTimestamp() {
        let plan = """
<Klausurplan Timestamp="2021-10-15T00:00:00Z"></Klausurplan>
"""
        
        let result = ClassTestPlanParser.parse(plan: plan)
        
        XCTAssertEqual(result, .failure(.invalidTimestamp))
    }
}
