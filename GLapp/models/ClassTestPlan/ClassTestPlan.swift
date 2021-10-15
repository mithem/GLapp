//
//  ClassTestPlan.swift
//  ClassTestPlan
//
//  Created by Miguel Themann on 08.10.21.
//

import Foundation

struct ClassTestPlan: Equatable {
    var date: Date
    var _classTests: [ClassTest]
    
    var isEmpty: Bool { classTests.isEmpty }
    
    var classTests: [ClassTest] {
        get {
            _classTests
        }
        set {
            _classTests = newValue.sorted()
        }
    }
    
    init(date: Date, classTests: [ClassTest] = []) {
        self.date = date
        self._classTests = classTests.sorted()
    }
}
