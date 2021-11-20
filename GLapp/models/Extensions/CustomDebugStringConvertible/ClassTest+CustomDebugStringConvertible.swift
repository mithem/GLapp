//
//  ClassTest+CustomDebugStringConvertible.swift
//  GLapp
//
//  Created by Miguel Themann on 18.11.21.
//

import Foundation

#if DEBUG
extension ClassTest: CustomDebugStringConvertible {
    var debugDescription: String {
        "ClassTest(date: \(date), classTestDate: \(classTestDate), start: \(String(describing: start)), end: \(String(describing: end)), room: \(String(describing: room)), subject: \(subject), teacher: \(String(describing: teacher)), individual: \(individual), opened: \(opened), alias: \(alias))"
    }
}
#endif
