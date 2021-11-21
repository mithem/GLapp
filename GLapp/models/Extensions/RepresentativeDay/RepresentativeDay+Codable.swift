//
//  RepresentativeDay+Codable.swift
//  GLapp
//
//  Created by Miguel Themann on 09.11.21.
//

import Foundation

extension RepresentativeDay: Codable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(date, forKey: .date)
        try container.encode(lessons, forKey: .lessons)
        try container.encode(notes, forKey: .notes)
    }
    
    convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let date = try container.decode(Date.self, forKey: .date)
        let lessons = try container.decode([RepresentativeLesson].self, forKey: .lessons)
        let notes = try container.decode([String].self, forKey: .notes)
        self.init(date: date, lessons: lessons, notes: notes)
    }
    
    private enum CodingKeys: CodingKey {
        case date, lessons, notes
    }
}
