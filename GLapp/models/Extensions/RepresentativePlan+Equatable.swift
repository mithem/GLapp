//
//  RepresentativePlan+Equatable.swift
//  RepresentativePlan+Equatable
//
//  Created by Miguel Themann on 20.10.21.
//

import Foundation

extension RepresentativePlan: Equatable {
    static func == (lhs: RepresentativePlan, rhs: RepresentativePlan) -> Bool {
        lhs.date == rhs.date && lhs.lessons == rhs.lessons && lhs.representativeDays == rhs.representativeDays && lhs.notes == rhs.notes
    }
}
