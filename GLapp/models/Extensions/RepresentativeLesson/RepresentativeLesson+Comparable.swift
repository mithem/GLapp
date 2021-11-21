//
//  RepresentativeLesson+Comparable.swift
//  GLapp
//
//  Created by Miguel Themann on 12.11.21.
//

import Foundation

extension RepresentativeLesson: Comparable {
    static func < (lhs: RepresentativeLesson, rhs: RepresentativeLesson) -> Bool {
        lhs.startDate < rhs.startDate
    }
}
