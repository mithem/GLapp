//
//  RepresentativeLesson+CSIndexable.swift
//  GLapp
//
//  Created by Miguel Themann on 21.11.21.
//

import Foundation

extension RepresentativeLesson: CSIndexable {
    var indexItemTitle: String { subject.title }
    var keywords: [String] {
        ["representative_lesson", "representative_plan", "substitution_lesson", "substitution_plan"]
    }
}
