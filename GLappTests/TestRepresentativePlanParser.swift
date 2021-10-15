//
//  TestRepresentativePlanParser.swift
//  TestRepresentativePlanParser
//
//  Created by Miguel Themann on 09.10.21.
//

import XCTest
@testable import GLapp

class TestRepresentativePlanParser: XCTestCase {
    func testRepresentativePlanParserSuccess() throws {
        let input = """
<Vertretungsplan Stand="2000-01-01 00:00:00" Timestamp="946681200">
<Vertretungstag/>
<Informationen> </Informationen>
</Vertretungsplan>
"""
        let expected = RepresentativePlan(date: .init(timeIntervalSince1970: 946681200), representativeDays: [], lessons: [], notes: [])
        
        let result = RepresentativePlanParser.parse(plan: input)
        
        XCTAssertEqual(try result.get(), expected)
    }
}
