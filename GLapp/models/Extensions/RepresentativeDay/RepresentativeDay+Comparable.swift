//
//  RepresentativeDay+Comparable.swift
//  GLapp
//
//  Created by Miguel Themann on 12.11.21.
//

import Foundation

extension RepresentativeDay: Comparable {
    static func < (lhs: RepresentativeDay, rhs: RepresentativeDay) -> Bool {
        guard let l = lhs.date, let r = rhs.date else { return rhs.date == nil } // so days without date are greater than those with
        return l < r
    }
}
