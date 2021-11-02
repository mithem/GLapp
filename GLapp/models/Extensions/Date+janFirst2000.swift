//
//  Date+janFirst2000.swift
//  GLapp
//
//  Created by Miguel Themann on 02.11.21.
//

import Foundation

extension Date {
    /// The first of january in the year 2000.
    static var janFirst2000: Self {
        .init(timeIntervalSince1970: 946681200)
    }
}
