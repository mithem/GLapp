//
//  Subject+CustomDebugStringConvertible.swift
//  GLapp
//
//  Created by Miguel Themann on 02.11.21.
//

import Foundation

#if DEBUG
extension Subject: CustomDebugStringConvertible {
    var debugDescription: String {
        "Subject(className: \(className), subjectName: \(String(describing: subjectName)), subjectType: \(String(describing: subjectType)), teacher: \(String(describing: teacher)))"
    }
}
#endif
