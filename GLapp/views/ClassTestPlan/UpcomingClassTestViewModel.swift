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
        
        let interval = classTest.classTestDate.timeIntervalSince(.rightNow)
        
        let components = Set([Calendar.Component.year, .month, .day, .hour, .minute])
        let classTestComponents = Calendar.current.dateComponents(components, from: classTest.startDate ?? classTest.classTestDate)
        let todayComponents = Calendar.current.dateComponents(components, from: .rightNow)
        
        let difComponents = classTestComponents - todayComponents
        
        let formatter = GLDateFormatter.dateComponentsFormatter
        formatter.allowedUnits = [.month, .day]
        
        if interval < Constants.relativeDateTimeFormatterTimeIntervalToIncreasePrecision {
            formatter.allowedUnits.insert(.hour)
        }
        if interval < Constants.relativeDateTimeFormatterTimeIntervalToIncreasePrecision / 3 {
            formatter.allowedUnits.insert(.minute)
        }
        
        return formatter.string(from: difComponents)
    }
    
    func subjectColor(colorScheme: ColorScheme) -> Color {
        if appManager.coloredInlineSubjects.isEnabled.unwrapped {
            return .init(classTest?.subject.color.getColoredForegroundColor(colorScheme: colorScheme) ?? .primary)
        }
        return .primary
    }
}
