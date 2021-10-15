//
//  TestGLappUI.swift
//  TestGLappUI
//
//  Created by Miguel Themann on 15.10.21.
//

import XCTest

class TestGLappUI: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
        XCUIApplication().launch()
    }

    func testLaunchPerformance() {
        let app = XCUIApplication()
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            app.launch()
        }
    }
}
