//
//  ClassTest.swift
//  ClassTest
//
//  Created by Miguel Themann on 08.10.21.
//

import Foundation

struct ClassTest: Identifiable, Codable {
    var id: Date { startDate ?? classTestDate } // who knows..
    
    var date: Date
    var classTestDate: Date
    var start: Int?
    var end: Int?
    var room: String?
    var subject: Subject
    var teacher: String?
    var individual: Bool
    var opened: Bool
    var alias: String
    
    var startDate: Date? {
        guard let start = start else { return nil }
        return Calendar.current.date(byAdding: Constants.lessonStartDateComponents[start]!, to: classTestDate)
    }
    
    var endDate: Date? {
        guard let end = end else { return nil }
        return Calendar.current.date(byAdding: Constants.lessonEndDateComponents[end]!, to: classTestDate)
    }
}
