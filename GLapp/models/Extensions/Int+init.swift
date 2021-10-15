//
//  Int+init.swift
//  Int+init
//
//  Created by Miguel Themann on 10.10.21.
//

import Foundation

extension Int {
    init?(weekday: String) {
        let weekdays = [
            "Montag": 0,
            "Dienstag": 1,
            "Mittwoch": 2,
            "Donnerstag": 3,
            "Freitag": 4,
            "Samstag": 5,
            "Sonntag": 6
        ]
        guard let n = weekdays[weekday] else { return nil }
        self = n
    }
}
