//
//  Subject.swift
//  Subject
//
//  Created by Miguel Themann on 01.10.21.
//

import Foundation

struct Subject: Equatable {
    var className: String
    var subjectType: String?
    var teacher: String?
    var subjectName: String?
    
    init(className: String, subjectType: String? = nil, teacher: String? = nil, subjectName: String? = nil) {
        self.className = className
        self.subjectType = subjectType
        self.teacher = teacher
        self.subjectName = subjectName
    }
}
