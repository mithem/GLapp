//
//  TestRepresentativeLesson.swift
//  GLappTests
//
//  Created by Miguel Themann on 26.10.21.
//

import XCTest
@testable import GLapp

class TestRepresentativeLesson: XCTestCase {
    var dataManager: DataManager!
    var currentComponents: DateComponents!
    var date: Date!
    var berlinCalendar: Calendar!
    var sPH: Subject!
    var formatter: NumberFormatter!
    
    override func setUpWithError() throws {
        dataManager = MockDataManager()
        currentComponents = Calendar(identifier: .gregorian).dateComponents([.year, .month, .day, .weekday], from: .rightNow)
        berlinCalendar = .init(identifier: .gregorian)
        berlinCalendar.timeZone = .init(identifier: "Europe/Berlin")!
        date = berlinCalendar.date(from: .init(calendar: berlinCalendar, timeZone: .init(identifier: "Europe/Berlin"), year: currentComponents.year!, month: currentComponents.month!, day: currentComponents.day!))!
        sPH = Subject(dataManager: dataManager, className: "PH", teacher: "SEN", subjectName: "PH")
        formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
    }
    
    func testSummaryTodayFreeLesson() {
        let lesson = RepresentativeLesson(date: date, lesson: 1, room: "PR2", newRoom: nil, note: "(frei)", subject: sPH, normalTeacher: "SEN", representativeTeacher: nil)
        let todayLocalized = GLDateFormatter.namedRelativeDateTimeFormatter.localizedString(from: .init(day: 0))
        XCTAssertEqual(lesson.notificationSummary, "\(todayLocalized) \(formatter.string(from: .init(value: 1))!) PH (frei)")
    }
    
    func testSummaryTomorrowRoomChangeAndReprTeacher() {
        let date = Calendar.current.date(byAdding: .init(day: 1), to: date)!
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = .init(identifier: "Europe/Berlin")!
        let tomorrowComponents = calendar.dateComponents([.day], from: date)
        let todayComponents = calendar.dateComponents([.day], from: .rightNow)
        let weekdayStr = GLDateFormatter.namedRelativeDateTimeFormatter.localizedString(from: tomorrowComponents - todayComponents)
        let lesson = RepresentativeLesson(date: date, lesson: 4, room: "PR2", newRoom: "PR1", note: "Raumänderung", subject: sPH, normalTeacher: "SEN", representativeTeacher: "DOH")
        
        XCTAssertEqual(lesson.notificationSummary, "\(weekdayStr) \(formatter.string(from: .init(value: 4))!) PH \(NSLocalizedString("in_mid_sentence")) PR1 \(NSLocalizedString("with_mid_sentence")) DOH (Raumänderung)")
    }
    
    func testSummaryFixedTest() {
        let calendar = Calendar(identifier: .gregorian)
        let components = DateComponents(calendar: calendar, timeZone: .init(identifier: "Europe/Berlin"), year: 2022, month: 1, day: 1, hour: 0, minute: 0)
        let date = calendar.date(from: components)!
        let lesson = RepresentativeLesson(date: date, lesson: 5, room: "A11", newRoom: nil, note: nil, subject: sPH, normalTeacher: "SEN", representativeTeacher: nil)
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        let numStr = formatter.string(from: NSNumber(5))!
        let dateStr = GLDateFormatter.dateOnlyFormatter.string(from: date)
        
        XCTAssertEqual(lesson.notificationSummary, "\(dateStr) \(numStr) PH")
    }
}
