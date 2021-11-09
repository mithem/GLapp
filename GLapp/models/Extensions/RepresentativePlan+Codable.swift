//
//  RepresentativePlan+Codable.swift
//  GLapp
//
//  Created by Miguel Themann on 09.11.21.
//

import Foundation

extension RepresentativePlan: Codable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(date, forKey: .date)
        try container.encode(notes, forKey: .notes)
        try container.encode(lessons, forKey: .lessons)
        try container.encode(representativeDays, forKey: .days)
    }
    
    convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let date = try container.decode(Date.self, forKey: .date)
        let notes = try container.decode([String].self, forKey: .notes)
        let lessons = try container.decode([RepresentativeLesson].self, forKey: .lessons)
        let days = try container.decode([RepresentativeDay].self, forKey: .days)
        self.init(date: date, representativeDays: days, lessons: lessons, notes: notes)
    }
    
    private enum CodingKeys: CodingKey {
        case date, notes, lessons, days
    }
}
