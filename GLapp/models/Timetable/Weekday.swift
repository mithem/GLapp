//
//  Weekday.swift
//  Weekday
//
//  Created by Miguel Themann on 08.10.21.
//

import Foundation

final class Weekday: ObservableObject, Identifiable, Codable {
    /// Weekday number from 0 (Mon) to 6 (Sun)
    @Published var id: Int
    @Published var lessons: [Lesson]
    
    init(id: Int, lessons: [Lesson] = []) {
        self.id = id
        self.lessons = lessons
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        lessons = try container.decode([Lesson].self, forKey: .lessons)
    }
    
    var subjects: Set<Subject> {
        var subjects = Set<Subject>()
        for lesson in lessons {
            subjects.insert(lesson.subject)
        }
        return subjects
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(lessons, forKey: .lessons)
    }
    
    private enum CodingKeys: CodingKey {
        case id, lessons
    }
}
