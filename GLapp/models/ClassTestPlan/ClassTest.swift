//
//  ClassTest.swift
//  ClassTest
//
//  Created by Miguel Themann on 08.10.21.
//

import Foundation

class ClassTest: ObservableObject, Identifiable, Codable {
    var id: String { subject.className + GLDateFormatter.berlinFormatter.string(from: date)}
    
    @Published var date: Date
    @Published var classTestDate: Date
    @Published var start: Int?
    @Published var end: Int?
    @Published var room: String?
    @Published var subject: Subject
    @Published var teacher: String?
    @Published var individual: Bool
    @Published var opened: Bool
    @Published var alias: String
    
    var startDate: Date? {
        guard let start = start else { return nil }
        return Calendar.current.date(byAdding: Constants.lessonStartDateComponents[start]!, to: classTestDate)
    }
    
    var endDate: Date? {
        guard let end = end else { return nil }
        return Calendar.current.date(byAdding: Constants.lessonEndDateComponents[end]!, to: classTestDate)
    }
    
    func reloadSubject(with dataManager: DataManager) {
        subject = dataManager.getSubject(subjectName: subject.subjectName ?? subject.className, className: subject.className)
    }
    
    init(date: Date, classTestDate: Date, start: Int?, end: Int?, room: String?, subject: Subject, teacher: String?, individual: Bool, opened: Bool, alias: String) {
        self.date = date
        self.classTestDate = classTestDate
        self.start = start
        self.end = end
        self.room = room
        self.subject = subject
        self.teacher = teacher
        self.individual = individual
        self.opened = opened
        self.alias = alias
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(date, forKey: .date)
        try container.encode(classTestDate, forKey: .classTestDate)
        try container.encode(start, forKey: .start)
        try container.encode(end, forKey: .end)
        try container.encode(room, forKey: .room)
        try container.encode(subject, forKey: .subject)
        try container.encode(teacher, forKey: .teacher)
        try container.encode(individual, forKey: .individual)
        try container.encode(opened, forKey: .opened)
        try container.encode(alias, forKey: .alias)
    }
    
    required  init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        date = try container.decode(Date.self, forKey: .date)
        classTestDate = try container.decode(Date.self, forKey: .classTestDate)
        start = try container.decode(Int?.self, forKey: .start)
        end = try container.decode(Int?.self, forKey: .end)
        room = try container.decode(String?.self, forKey: .room)
        subject = try container.decode(Subject.self, forKey: .subject)
        teacher = try container.decode(String?.self, forKey: .teacher)
        individual = try container.decode(Bool.self, forKey: .individual)
        opened = try container.decode(Bool.self, forKey: .opened)
        alias = try container.decode(String.self, forKey: .alias)
    }
    
    enum CodingKeys: CodingKey {
        case date, classTestDate, start, end, room, subject, teacher, individual, opened, alias
    }
}
