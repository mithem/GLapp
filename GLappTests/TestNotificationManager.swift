//
//  TestNotificationManager.swift
//  GLappTests
//
//  Created by Miguel Themann on 18.12.21.
//

import XCTest
@testable import GLapp

class TestNotificationManager: XCTestCase {
    
    static var beforeDays = 5
    static let distantYear = Calendar.current.dateComponents([.year], from: .distantFuture).year!
    static let distantClassTestDate = Calendar.current.date(from: .init(calendar: .init(identifier: .gregorian), year: distantYear, month: 12, day: 3))! // when choosing a sooner date, it runs the risk of finding the appropriate time to schedule to be a "dateInPast"
    static let distantClassTest = ClassTest(date: .rightNow, classTestDate: distantClassTestDate, start: 1, end: 5, room: nil, subject: MockData.subject, teacher: nil, individual: true, opened: true, alias: "")
    
    override func setUpWithError() throws {
        UserDefaults.standard.set(Self.beforeDays, for: \.classTestReminderNotificationBeforeDays)
    }
    
    func atClassTestTime() {
        UserDefaults.standard.set(ClassTestReminderTimeMode.atClassTestTime, for: \.classTestReminderTimeMode)
    }
    
    func manualTime() {
        UserDefaults.standard.set(ClassTestReminderTimeMode.manual.rawValue, for: \.classTestReminderTimeMode)
        UserDefaults.standard.set(Date.today(at: .init(hour: 10, minute: 37)), for: \.classTestReminderManualTime)
    }
    
    func testGetClassTestReminderDeliveryComponentsTimeOfClassTestAtClassTestTime() throws {
        atClassTestTime()
        let expected = DateComponents(year: Self.distantYear, month: 11, day: 28, hour: 7, minute: 45)
        
        let result = NotificationManager._getClassTestReminderDeliveryComponents(for: Self.distantClassTest)
        
        XCTAssertEqual(try result.get(), expected)
    }
    
    func testGetClassTestReminderDeliveryComponentsTimeOfClassTestManualTime() throws {
        manualTime()
        let expected = DateComponents(year: Self.distantYear, month: 11, day: 28, hour: 10, minute: 37)
        
        let result = NotificationManager._getClassTestReminderDeliveryComponents(for: Self.distantClassTest)
        
        XCTAssertEqual(try result.get(), expected)
    }
    
    func testGetClassTestReminderDeliveryComponentsTimeOfClassTestPastDeliveryDate() throws {
        let classTestDate = Date.today(at: .init(hour: 0, minute: 0))
        let classTest = ClassTest(date: .rightNow, classTestDate: classTestDate, start: 4, end: 6, room: nil, subject: MockData.subject, teacher: nil, individual: true, opened: true, alias: "")
        
        let result = NotificationManager._getClassTestReminderDeliveryComponents(for: classTest)
        
        switch result {
        case .success(_):
            XCTFail("Did success but delivery date should be in past")
        case .failure(let error):
            XCTAssertEqual(error, .dateInPast)
        }
    }
}
