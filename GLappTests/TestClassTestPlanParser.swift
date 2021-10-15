//
//  TestClassTestPlanParser.swift
//  TestClassTestPlanParser
//
//  Created by Miguel Themann on 14.10.21.
//

import XCTest
@testable import GLapp

class TestClassTestPlanParser: XCTestCase {
    func testClassTestPlanParserSuccess() throws {
        let plan = """
"""
        let expected = ClassTestPlan(date: .init(timeIntervalSince1970: 10000), classTests: [])
        
        let result = ClassTestPlanParser.parse(plan: plan)
        
        XCTAssertEqual(try result.get(), expected)
    }
}
