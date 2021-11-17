//
//  ClassTestInlineViewModel.swift
//  GLapp
//
//  Created by Miguel Themann on 16.11.21.
//

import SwiftUI

@MainActor final class ClassTestInlineViewModel: ObservableObject {
    @Published var classTest: ClassTest
    @Published var appManager: AppManager
    
    init(classTest: ClassTest, appManager: AppManager) {
        self.classTest = classTest
        self.appManager = appManager
    }
    
    var isOver: Bool {
        if let endDate = classTest.endDate {
            if .rightNow > endDate { return true }
        }
        return false
    }
    
    var title: String {
        let subjectType: String
        if let sType = classTest.subject.subjectType {
            subjectType = " (\(sType))"
        } else {
            subjectType = ""
        }
        return "\(classTest.subject.subjectName ?? classTest.subject.className)\(subjectType)"
    }
    
    func titleColor(colorScheme: ColorScheme) -> Color {
        if isOver {
            return .secondary
        }
        if appManager.coloredInlineSubjects.isEnabled.unwrapped {
            return classTest.subject.color.getColoredForegroundColor(colorScheme: colorScheme)
        }
        return .primary
    }

    var duration: String {
        if let start = classTest.start, let end = classTest.end {
            let formatter = NumberFormatter()
            formatter.numberStyle = .ordinal
            let st = formatter.string(from: .init(value: start))!
            let en = formatter.string(from: .init(value: end))!
            return "\(st) - \(en), "
        } else {
            return ""
        }
    }
}
