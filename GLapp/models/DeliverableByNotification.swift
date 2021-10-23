//
//  DeliverableByNotification.swift
//  DeliverableByNotification
//
//  Created by Miguel Themann on 19.10.21.
//

import Foundation

protocol DeliverableByNotification {
    var title: String? { get }
    var summary: String { get }
}

extension DeliverableByNotification {
    var title: String? { nil }
}
