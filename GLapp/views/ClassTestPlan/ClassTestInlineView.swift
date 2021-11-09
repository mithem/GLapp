//
//  ClassTestInlineView.swift
//  ClassTestInlineView
//
//  Created by Miguel Themann on 09.10.21.
//

import SwiftUI

struct ClassTestInlineView: View {
    let classTest: ClassTest
    @ObservedObject var appManager: AppManager
    @AppStorage(UserDefaultsKeys.automaticallyRemindBeforeClassTests) var autoRemindBeforeClassTests = false // can't use appManager.classTestReminders.isEnabled as that's not refreshed when the view loads and the latter doesn't update when .isEnabled changes 🤨
    @Environment(\.colorScheme) private var colorScheme
    var body: some View {
        let hstack = HStack {
            VStack(alignment: .leading) {
                Text(title)
                    .bold()
                    .foregroundColor(titleColor)
                Text(classTest.room ?? "")
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text("\(duration)\(classTest.classTestDate.formattedWithLocaleOnlyDay)")
                Text(classTest.teacher ?? "")
            }
                .foregroundColor(.secondary)
        }
            .foregroundColor(isOver ? .secondary : .primary)
        if !autoRemindBeforeClassTests {
            hstack
                .contextMenu {
                    Button(action: {
                        NotificationManager.default.scheduleClassTestReminder(for: classTest)
                    }) {
                        Text("set_reminder")
                        Image(systemName: "clock")
                    }
                }
        } else {
            hstack
        }
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
    
    @MainActor var titleColor: Color {
        if isOver {
            return .secondary
        }
        if appManager.coloredInlineSubjects.isEnabled == .yes {
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

struct ClassTestInlineView_Previews: PreviewProvider {
    static var previews: some View {
        ClassTestInlineView(classTest: MockData.classTest, appManager: .init())
    }
}
