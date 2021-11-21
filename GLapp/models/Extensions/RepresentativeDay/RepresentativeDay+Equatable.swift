//
//  RepresentativeDay+Equatable.swift
//  GLapp
//
//  Created by Miguel Themann on 09.11.21.
//

import Foundation

extension RepresentativeDay: Equatable {
    static func == (lhs: RepresentativeDay, rhs: RepresentativeDay) -> Bool {
        lhs.date == rhs.date && lhs.lessons == rhs.lessons && lhs.notes == rhs.notes
    }
}
