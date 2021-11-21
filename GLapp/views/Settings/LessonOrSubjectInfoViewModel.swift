//
//  LessonOrSubjectInfoViewModel.swift
//  GLapp
//
//  Created by Miguel Themann on 20.11.21.
//

import Foundation
import SwiftUI

final class LessonOrSubjectInfoViewModel: ObservableObject {
    @Published var content: Content
    @Published var dataManager: DataManager
    
    init(lesson: Lesson? = nil, subject: Subject? = nil, dataManager: DataManager) {
        self.dataManager = dataManager
        if let lesson = lesson {
            content = .init(subject: lesson.subject, room: lesson.room, dataManager: dataManager)
        } else if let subject = subject {
            content = .init(subject: subject, room: nil, dataManager: dataManager)
        } else {
            fatalError("Did not provide lesson nor subject")
        }
    }
    
    final class Content: ObservableObject {
        @Published var subject: Subject
        @Published var room: String?
        private var dataManager: DataManager
        
        init(subject: Subject, room: String?, dataManager: DataManager) {
            self.subject = subject
            self.room = room
            self.dataManager = dataManager
        }
        
        var subjectColorBinding: Binding<Color> { Binding(get: {
            self.subject.color
            }, set: { newValue in
                self.subject.color = newValue
                self.dataManager.updateSubjectColorMap(className: self.subject.className, color: newValue)
            })
        }
    }
}
