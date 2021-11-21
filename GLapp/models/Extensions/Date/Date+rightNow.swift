//
//  Date+rightNow.swift
//  GLapp
//
//  Created by Miguel Themann on 29.10.21.
//

import Foundation

extension Date {
    static var rightNow: Self {
        if #available(iOS 15, *) {
            return .now
        }
        return .init(timeIntervalSinceNow: 0)
    }
}
