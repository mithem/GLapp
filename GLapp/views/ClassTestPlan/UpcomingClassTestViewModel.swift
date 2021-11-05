//
//  UpcomingClassTestViewModel.swift
//  GLapp
//
//  Created by Miguel Themann on 02.11.21.
//

import SwiftUI

class UpcomingClassTestViewModel: ObservableObject {
    @Published var appManager: AppManager
    @Published var classTests: [ClassTest]
    
    init(appManager: AppManager, classTests: [ClassTest]) {
        self.appManager = appManager
        self.classTests = classTests
    }
    
    var classTest: ClassTest? {
        guard classTests.count > 0 else { return nil }
        for i in 0 ..< classTests.count {
            let classTest = classTests[i]
            if let endDate = classTest.endDate {
                if .rightNow > endDate {
                    continue
                }
            }
            return classTest
        }
        return nil
    }
    
    var timeInterval: String? {
        guard let classTest = classTest else { return nil }

        let formatter = GLDateFormatter.relativeDateTimeFormatter
        return formatter.localizedString(for: classTest.startDate ?? classTest.classTestDate, relativeTo: .rightNow)
    }
    
    func subjectColor(colorScheme: ColorScheme) -> Color {
        if appManager.coloredInlineSubjects.isEnabled == .yes {
            return classTest?.subject.color.getColoredForegroundColor(colorScheme: colorScheme) ?? .primary
        }
        return .primary
    }
}
