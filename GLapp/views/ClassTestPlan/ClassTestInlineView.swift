//
//  ClassTestInlineView.swift
//  ClassTestInlineView
//
//  Created by Miguel Themann on 09.10.21.
//

import SwiftUI

struct ClassTestInlineView: View {
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject var model: ClassTestInlineViewModel
    @State private var showingLessonOrSubjectInfoView = false
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(model.classTest.notificationTitle)
                    .bold()
                    .foregroundColor(model.titleColor(colorScheme: colorScheme))
                Text(model.classTest.room ?? "")
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text("\(model.duration)\(model.classTest.classTestDate.formattedWithLocaleOnlyDay)")
                Text(model.classTest.teacher ?? "")
            }
                .foregroundColor(.secondary)
        }
            .foregroundColor(model.isOver ? .secondary : .primary)
            .sheet(isPresented: $showingLessonOrSubjectInfoView) {
                LessonOrSubjectInfoView(subject: model.classTest.subject, dataManager: model.dataManager)
            }
            .contextMenu {
                if !model.classTest.isRewrite {
                    Button(action: {
                        showingLessonOrSubjectInfoView = true
                    }, label: {
                        Label("more", systemImage: "ellipsis.circle")
                    })
                }
                if !model.appManager.classTestReminders.isEnabled.unwrapped {
                    Button(action: {
                        NotificationManager.default.scheduleClassTestReminder(for: model.classTest)
                    }) {
                        Label("set_reminder", systemImage: "clock")
                    }
                }
            }
    }
    
    init(classTest: ClassTest, appManager: AppManager, dataManager: DataManager) {
        model = .init(classTest: classTest, appManager: appManager, dataManager: dataManager)
    }
}

struct ClassTestInlineView_Previews: PreviewProvider {
    static var previews: some View {
        ClassTestInlineView(classTest: MockData.classTest, appManager: .init(), dataManager: MockDataManager())
    }
}
