//
//  RepresentativeDay+Differentiable.swift
//  GLapp
//
//  Created by Miguel Themann on 12.11.21.
//

import Foundation

extension RepresentativeDay: Differentiable {
    static func difference(_ lhs: RepresentativeDay, to rhs: RepresentativeDay) -> RepresentativeDay {
        let differenceDay = RepresentativeDay(date: lhs.date, lessons: [], notes: [])
        let lsl = lhs.lessons.sorted()
        let rsl = rhs.lessons.sorted()
        let lc = lsl.count
        let rc = rsl.count
        let maxCount = lc > rc ? lc : rc
        for i in 0 ..< maxCount {
            if i + 1 > lc || i + 1 > rc {
                if i < lc {
                    differenceDay.lessons.append(lsl[i])
                } else if i < rc {
                    differenceDay.lessons.append(rsl[i])
                }
            } else if lsl[i].date == rsl[i].date && lsl[i].subject == rsl[i].subject {
                let dif = RepresentativeLesson.difference(of: lsl[i], to: rsl[i])
                if !dif.isEmpty {
                    differenceDay.lessons.append(dif.newLesson(old: lsl[i]))
                }
            }
        }
        var notes = Set(lhs.notes)
        notes.formSymmetricDifference(rhs.notes)
        differenceDay.notes.append(contentsOf: notes)
        return differenceDay
    }
}
