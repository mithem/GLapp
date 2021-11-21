//
//  ClassTest+Comparable.swift
//  ClassTest+Comparable
//
//  Created by Miguel Themann on 15.10.21.
//

import Foundation

extension ClassTest: Comparable {
    static func < (lhs: ClassTest, rhs: ClassTest) -> Bool {
        lhs.classTestDate < rhs.classTestDate
    }
}
