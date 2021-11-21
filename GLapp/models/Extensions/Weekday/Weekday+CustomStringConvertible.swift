//
//  Weekday+CustomStringConvertible.swift
//  GLapp
//
//  Created by Miguel Themann on 21.11.21.
//

import Foundation

extension Weekday: CustomStringConvertible {
    var description: String {
        NSLocalizedString(Constants.weekdayIDStringMap[id]!)
    }
}
