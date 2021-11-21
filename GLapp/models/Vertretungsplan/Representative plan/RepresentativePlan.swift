//
//  RepresentativePlan.swift
//  RepresentativePlan
//
//  Created by Miguel Themann on 08.10.21.
//

import Foundation

final class RepresentativePlan: ObservableObject {
    @Published var date: Date?
    @Published var representativeDays: [RepresentativeDay]
    @Published var lessons: [RepresentativeLesson]
    @Published var notes: [String]
    @Published var lastFetched: Date
    
    init(date: Date?, representativeDays: [RepresentativeDay] = [], lessons: [RepresentativeLesson] = [], notes: [String] = []) {
        self.date = date
        self.representativeDays = representativeDays
        self.lessons = lessons
        self.notes = notes
        self.lastFetched = .rightNow
    }
    
    var isEmpty: Bool {
        let days = representativeDays.isEmpty || (representativeDays.count == 1 && representativeDays.first?.isEmpty == true)
        let lessons = lessons.isEmpty
        let notes = notes.isEmpty
        return days && lessons && notes
    }
    
    func updateSubjects(with dataManager: DataManager) {
        for day in representativeDays {
            day.updateSubjects(with: dataManager)
        }
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
        for day in representativeDays {
            if let intent = day.findIntent(with: id) {
                return intent
            }
        }
        return nil
    }
}
