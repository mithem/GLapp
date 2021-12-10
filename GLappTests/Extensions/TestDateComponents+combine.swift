//
//  TestDateComponents+combine.swift
//  GLappTests
//
//  Created by Miguel Themann on 10.12.21.
//

import XCTest
@testable import GLapp

class TestDateComponents_combine: XCTestCase {
    func testAdd() {
        let c1 = DateComponents(year: 2021, month: 12, day: 10, hour: 12, minute: 53, second: 45)
        let c2 = DateComponents(month: 2, day: 5, hour: 5, minute: 10, second: 25)
        let expected = DateComponents(year: 2021, month: 14, day: 15, hour: 17, minute: 63, second: 70)
        
        XCTAssertEqual(c1 + c2, expected)
    }
    
    func testSubtract() {
        let c1 = DateComponents(year: 2021, month: 12, day: 10, hour: 12, minute: 53, second: 30)
        let c2 = DateComponents(hour: 4, minute: 30, second: 35)
        let expected = DateComponents(year: 2021, month: 12, day: 10, hour: 8, minute: 23, second: -5)
        
        XCTAssertEqual(c1 - c2, expected)
    }
    
    func testIgnoredNilComponentsOnLHS() {
        let c1 = DateComponents(year: 2021, day: 10, minute: 10)
        let c2 = DateComponents(month: 5, hour: 10, minute: 15, second: 10)
        let expected = DateComponents(year: 2021, day: 10, minute: 25)
        
        XCTAssertEqual(c1 + c2, expected)
    }
}
