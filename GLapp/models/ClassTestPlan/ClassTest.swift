//
//  ClassTest.swift
//  ClassTest
//
//  Created by Miguel Themann on 08.10.21.
//

import Foundation

struct ClassTest: Identifiable {
    var id: Date { classTestDate }
    
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
}
