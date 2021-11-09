//
//  RepresentativeLesson+Codable.swift
//  GLapp
//
//  Created by Miguel Themann on 09.11.21.
//

import Foundation

extension RepresentativeLesson: Codable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(date, forKey: .date)
        try container.encode(lesson, forKey: .lesson)
        try container.encode(room, forKey: .room)
        try container.encode(newRoom, forKey: .newRoom)
        try container.encode(note, forKey: .note)
        try container.encode(subject, forKey: .subject)
        try container.encode(normalTeacher, forKey: .normalTeacher)
        try container.encode(representativeTeacher, forKey: .representativeTeacher)
    }
    
    convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let date = try container.decode(Date.self, forKey: .date)
        let lesson = try container.decode(Int.self, forKey: .lesson)
        let room = try container.decode(String.self, forKey: .room)
        let newRoom = try container.decode(String.self, forKey: .newRoom)
        let note = try container.decode(String.self, forKey: .note)
        let subject = try container.decode(Subject.self, forKey: .subject)
        let normalTeacher = try container.decode(String.self, forKey: .normalTeacher)
        let representativeTeacher = try container.decode(String.self, forKey: .representativeTeacher)
        self.init(date: date, lesson: lesson, room: room, newRoom: newRoom, note: note, subject: subject, normalTeacher: normalTeacher, representativeTeacher: representativeTeacher)
    }
    
    private enum CodingKeys: CodingKey {
        case date, lesson, room, newRoom, note, subject, normalTeacher, representativeTeacher
    }
}
