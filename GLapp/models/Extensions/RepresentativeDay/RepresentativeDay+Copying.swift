//
//  RepresentativeDay+Copying.swift
//  GLapp
//
//  Created by Miguel Themann on 12.11.21.
//

import Foundation

extension RepresentativeDay: Copying {
    func copy() -> RepresentativeDay {
        .init(date: date, lessons: lessons.copy(), notes: notes)
    }
}
