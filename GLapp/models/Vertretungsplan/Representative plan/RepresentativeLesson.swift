//
//  RepresentativeLesson.swift
//  RepresentativeLesson
//
//  Created by Miguel Themann on 01.10.21.
//

import Foundation

final class RepresentativeLesson: ObservableObject, Identifiable {
    var id: Double { startDate.timeIntervalSince1970 }
    @Published var date: Date
    @Published var lesson: Int
    @Published var room: String?
    @Published var newRoom: String?
    @Published var note: String?
    @Published var subject: Subject?
    @Published var normalTeacher: String?
    @Published var representativeTeacher: String?
    
    var startDate: Date {
        return Calendar.current.date(byAdding: Constants.lessonStartDateComponents[lesson]!, to: date)!
    }
    
    var endDate: Date {
        return Calendar.current.date(byAdding: Constants.lessonEndDateComponents[lesson]!, to: date)!
    }
    
    var isOver: Bool {
        return .rightNow > endDate
    }
    
    var isInvalid: Bool {
        normalTeacher == "" || subject?.isInvalid != false || room == nil
    }
    
    func updateSubject(with dataManager: DataManager) {
        if let subject = subject {
            self.subject = dataManager.getSubject(subjectName: subject.subjectName ?? subject.className, className: nil) // assume className is unknown
        }
    }
    
    init(date: Date, lesson: Int, room: String?, newRoom: String?, note: String?, subject: Subject?, normalTeacher: String?, representativeTeacher: String? = nil) {
        self.date = date
        self.lesson = lesson
        self.room = room
        self.newRoom = newRoom
        self.note = note
        self.subject = subject
        self.normalTeacher = normalTeacher
        self.representativeTeacher = representativeTeacher
    }
    
    /// The difference between two `RepresentativeLesson`s, with "objective truth" / a new value saved in this class's attributes
    struct Difference {
        // date & subject used to identify single lessons
        var room: String?
        var newRoom: String?
        var note: String?
        var normalTeacher: String?
        var representativeTeacher: String?
        
        var isEmpty: Bool {
            room == nil && newRoom == nil && note == nil && normalTeacher == nil && representativeTeacher == nil
        }
        
        init(room: String? = nil, newRoom: String? = nil, note: String? = nil, normalTeacher: String? = nil, representativeTeacher: String? = nil) {
            self.room = room
            self.newRoom = newRoom
            self.note = note
            self.normalTeacher = normalTeacher
            self.representativeTeacher = representativeTeacher
        }
        
        func newLesson(old: RepresentativeLesson) -> RepresentativeLesson {
            let lesson = old.copy()
            if let room = room {
                lesson.room = room
            }
            if let newRoom = newRoom {
                lesson.newRoom = newRoom
            }
            if let note = note {
                lesson.note = note
            }
            if let normalTeacher = normalTeacher {
                lesson.normalTeacher = normalTeacher
            }
            if let representativeTeacher = representativeTeacher {
                lesson.representativeTeacher = representativeTeacher
            }
            return lesson
        }
    }
}
