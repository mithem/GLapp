//
//  Weekday+Equatable.swift
//  Weekday+Equatable
//
//  Created by Miguel Themann on 18.10.21.
//

import Foundation

extension Weekday: Equatable {
    static func == (lhs: Weekday, rhs: Weekday) -> Bool {
        lhs.id == rhs.id && lhs.lessons == rhs.lessons
    }
}
