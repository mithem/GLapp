//
//  RepresentativePlan+Copying.swift
//  GLapp
//
//  Created by Miguel Themann on 12.11.21.
//

import Foundation

extension RepresentativePlan: Copying {
    func copy() -> RepresentativePlan {
        let plan = RepresentativePlan(date: date, representativeDays: representativeDays.copy(), lessons: lessons.copy(), notes: notes)
        plan.lastFetched = lastFetched
        return plan
    }
}
