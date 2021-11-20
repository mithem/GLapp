//
//  Date+Identifiable.swift
//  GLapp
//
//  Created by Miguel Themann on 18.11.21.
//

import Foundation

extension Date: Identifiable {
    public var id: TimeInterval { timeIntervalSince1970 }
}
