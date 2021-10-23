//
//  ClassTestPlan+Equatable.swift
//  ClassTestPlan+Equatable
//
//  Created by Miguel Themann on 20.10.21.
//

import Foundation

extension ClassTestPlan: Equatable {
    static func == (lhs: ClassTestPlan, rhs: ClassTestPlan) -> Bool {
        lhs.date == rhs.date && lhs.classTests == rhs.classTests
    }
}
