//
//  RepresentativeLessonInlineViewModel.swift
//  GLapp
//
//  Created by Miguel Themann on 22.11.21.
//

import SwiftUI

@MainActor final class RepresentativeLessonInlineViewModel: ObservableObject {
    @Published var appManager: AppManager
    @Published var dataManager: DataManager
    @Published var lesson: RepresentativeLesson
    @Published var showingLessonOrSubjectInfoView: Bool
    @Published var confirmationDialogProvider: ConfirmationDialogProvider
    
    var title: String {
        if lesson.isInvalid {
            return NSLocalizedString("invalid_with_advice")
        }
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        return "\(formatter.string(from: NSNumber(value: lesson.lesson))!) \(lesson.subject.subjectName ?? lesson.subject.className)"
    }
    
    func titleColor(colorScheme: ColorScheme) -> Color {
        if lesson.isInvalid {
            return .red
        }
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
        confirmationDialogProvider = .init(title: "repr_plan_contains_invalid_lessons_title", body: "repr_plan_contains_invalid_lessons_description")
    }
    
    var actionButtons: [ConfirmationDialog.Button] {
        [(title: "open_interner_bereich", callback: {
            self.openInternerBereich()
        })]
    }
    
    var cancelButtons: [ConfirmationDialog.Button] {
        [(title: "cancel", callback: {})]
    }
    
    func openInternerBereich() {
        UIApplication.shared.open(Constants.internerBereichReprPlanURL)
    }
    
    func onTapTitle() {
        if lesson.isInvalid {
            confirmationDialogProvider.showingConfirmationDialog = true
        }
    }
}
