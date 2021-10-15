//
//  TestTimetableParser.swift
//  TestTimetableParser
//
//  Created by Miguel Themann on 14.10.21.
//

import XCTest
@testable import GLapp

class TestTimetableParser: XCTestCase {
    func testTimetableParserSuccess() throws {
        let timetable = """
"""
        let expected = MockData.timetable
        
        let result = TimetableParser.parse(timetable: timetable)
        
        XCTAssertEqual(try result.get(), expected)
    }
}
