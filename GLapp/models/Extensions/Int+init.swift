//
//  Int+init.swift
//  Int+init
//
//  Created by Miguel Themann on 10.10.21.
//

import Foundation

extension Int {
    init?(weekday: String) {
        guard let n = Constants.weekdayStringIDMap[weekday] else { return nil }
        self = n
    }
}
