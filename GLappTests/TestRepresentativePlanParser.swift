//
//  TestRepresentativePlanParser.swift
//  TestRepresentativePlanParser
//
//  Created by Miguel Themann on 09.10.21.
//

import XCTest
@testable import GLapp

class TestRepresentativePlanParser: XCTestCase {
    func testParseEmpty() throws {
        let input = """
<Vertretungsplan Stand="2000-01-01 00:00:00" Timestamp="946681200">
<Vertretungstag/>
<Informationen> </Informationen>
</Vertretungsplan>
"""
        let expected = RepresentativePlan(date: .init(timeIntervalSince1970: 946681200), representativeDays: [.init()], lessons: [], notes: [])
        
        let result = RepresentativePlanParser.parse(plan: input, with: MockDataManager())
        
        XCTAssertEqual(try result.get(), expected)
    }
    
    func testParseNoRootElement() {
        let result = RepresentativePlanParser.parse(plan: "", with: MockDataManager())
        XCTAssertEqual(result, .failure(.noRootElement))
    }
    
    func testParseInvalidRootElement() {
        let result = RepresentativePlanParser.parse(plan: "<Root></Root>", with: MockDataManager())
        XCTAssertEqual(result, .failure(.invalidRootElement))
    }
    
    func testParseNoTimestamp() {
        let result = RepresentativePlanParser.parse(plan: "<Vertretungsplan></Vertretungsplan>", with: MockDataManager())
        XCTAssertEqual(result, .failure(.noTimestamp))
    }
    
    func testParseInvalidTimestamp() {
        let plan = """
<Vertretungsplan Timestamp="2021-10-15T00:00:00Z"></Vertretungsplan>
"""
        
        let result = RepresentativePlanParser.parse(plan: plan, with: MockDataManager())
        
        XCTAssertEqual(result, .failure(.invalidTimestamp))
    }
}
