//
//  RepresentativeLessonInlineViewModel.swift
//  GLapp
//
//  Created by Miguel Themann on 22.11.21.
//

import SwiftUI

final class RepresentativeLessonInlineViewModel: ObservableObject {
    @Published var appManager: AppManager
    @Published var dataManager: DataManager
    @Published var lesson: RepresentativeLesson
    @Published var showingLessonOrSubjectInfoView: Bool
    
    var title: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        return "\(formatter.string(from: NSNumber(value: lesson.lesson))!) \(lesson.subject.subjectName ?? lesson.subject.className)"
    }
    
    @MainActor func titleColor(colorScheme: ColorScheme) -> Color {
        if lesson.isOver {
            return .secondary
        }
        if appManager.coloredInlineSubjects.isEnabled.unwrapped {
            return .init(lesson.subject.color.getColoredForegroundColor(colorScheme: colorScheme))
        }
        return .primary
    }
    
    init(lesson: RepresentativeLesson, appManager: AppManager, dataManager: DataManager) {
        self.appManager = appManager
        self.dataManager = dataManager
        self.lesson = lesson
        self.showingLessonOrSubjectInfoView = false
    }
}
