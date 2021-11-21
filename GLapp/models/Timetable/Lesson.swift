//
//  Lesson.swift
//  Lesson
//
//  Created by Miguel Themann on 08.10.21.
//

import Foundation

final class Lesson: ObservableObject, Identifiable, Codable {
    var id: String { "\(String(weekday) ?? "")\(subject)\(lesson)\(lesson)" }
    
    @Published var lesson: Int
    @Published var room: String
    @Published var subject: Subject
    weak var weekday: Weekday?
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(lesson, forKey: .lesson)
        try container.encode(room, forKey: .room)
        try container.encode(subject, forKey: .subject)
    }
    
    init(lesson: Int, weekday: Weekday? = nil, room: String, subject: Subject) {
        self.lesson = lesson
        self.weekday = weekday
        self.room = room
        self.subject = subject
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        lesson = try container.decode(Int.self, forKey: .lesson)
        room = try container.decode(String.self, forKey: .room)
        subject = try container.decode(Subject.self, forKey: .subject)
    }
    
    private enum CodingKeys: CodingKey {
        case lesson, room, subject
    }
}
