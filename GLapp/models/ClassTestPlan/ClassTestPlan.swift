//
//  ClassTestPlan.swift
//  ClassTestPlan
//
//  Created by Miguel Themann on 08.10.21.
//

import Foundation

struct ClassTestPlan: Equatable {
    var date: Date
    var classTests: [ClassTest]
    
    var isEmpty: Bool { classTests.isEmpty }
    
    init(date: Date, classTests: [ClassTest] = []) {
        self.date = date
        self.classTests = classTests
    }
}
