//
//  RepresentativePlan+Differentiable.swift
//  GLapp
//
//  Created by Miguel Themann on 12.11.21.
//

import Foundation

extension RepresentativePlan: Differentiable {
    static func difference(_ lhs: RepresentativePlan, to rhs: RepresentativePlan) -> RepresentativePlan {
        let differencePlan = RepresentativePlan(date: lhs.date)
        differencePlan.lastFetched = lhs.lastFetched > rhs.lastFetched ? lhs.lastFetched : rhs.lastFetched
        // left sorted days
        let lsd = lhs.representativeDays.sorted()
        let rsd = rhs.representativeDays.sorted()
        let lc = lsd.count
        let rc = rsd.count
        let maxCount = lc > rc ? lc : rc
        for i in 0 ..< maxCount {
            if i + 1 > lc || i + 1 > rc {
                if i < lc {
                    differencePlan.representativeDays.append(lsd[i])
                } else if i < rc {
                    differencePlan.representativeDays.append(rsd[i])
                }
            } else if lsd[i].id == rsd[i].id {
                let dif = RepresentativeDay.difference(lsd[i], to: rsd[i])
                if !dif.isEmpty {
                    differencePlan.representativeDays.append(dif)
                }
            }
        }
        var notes = Set(lhs.notes)
        notes.formSymmetricDifference(rhs.notes)
        differencePlan.notes = .init(notes)
        return differencePlan
    }
}
