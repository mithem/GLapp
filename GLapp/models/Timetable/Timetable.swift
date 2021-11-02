//
//  Timetable.swift
//  Timetable
//
//  Created by Miguel Themann on 08.10.21.
//

import Foundation

final class Timetable: ObservableObject, Codable {
    @Published var date: Date
    @Published var weekdays: [Weekday]
    @Published var lastFetched: Date
    
    var isEmpty: Bool {
        weekdays.isEmpty
    }
    
    var maxHours: Int {
        var max = 0
        for wday in weekdays {
            let tmp = wday.lessons.max(by: { lhs, rhs in
                rhs.lesson > lhs.lesson
            })
            if let tmp = tmp {
                if tmp.lesson > max {
                    max = tmp.lesson
                }
            }
        }
        return max
    }
    
    var subjects: Set<Subject> {
        var subjects = Set<Subject>()
        for weekday in weekdays {
            subjects = subjects.union(weekday.subjects)
        }
        return subjects
    }
    
    init(date: Date, weekdays: [Weekday] = []) {
        self.date = date
        self.weekdays = weekdays
        self.lastFetched = .rightNow
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        date = try container.decode(Date.self, forKey: .date)
        weekdays = try container.decode([Weekday].self, forKey: .weekdays)
        lastFetched = try container.decode(Date.self, forKey: .lastFetched)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(date, forKey: .date)
        try container.encode(weekdays, forKey: .weekdays)
        try container.encode(lastFetched, forKey: .lastFetched)
    }
    
    private enum CodingKeys: CodingKey {
        case date, weekdays, lastFetched
    }
}
