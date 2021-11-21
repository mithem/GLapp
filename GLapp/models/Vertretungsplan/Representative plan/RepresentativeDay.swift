//
//  RepresentativeDay.swift
//  RepresentativeDay
//
//  Created by Miguel Themann on 01.10.21.
//

import Foundation

final class RepresentativeDay: ObservableObject, Identifiable {
    var id: Date? { date }
    
    @Published var lessons: [RepresentativeLesson]
    @Published var date: Date?
    @Published var notes: [String]
    
    init(date: Date? = nil, lessons: [RepresentativeLesson] = [], notes: [String] = []) {
        self.date = date
        self.lessons = lessons
        self.notes = notes
    }
    
    var isEmpty: Bool {
        return lessons.isEmpty && notes.isEmpty
    }
    
    
    func updateSubjects(with dataManager: DataManager) {
        for lesson in lessons {
            lesson.updateSubject(with: dataManager)
        }
    }
    
    func findIntent(with id: String) -> IntentToHandle? {
        for lesson in lessons {
            if lesson.id == id {
                return .showRepresentativePlan
            }
        }
        return nil
    }
}
