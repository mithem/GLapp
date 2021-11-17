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
    var body: some View {
        let hstack = HStack {
            VStack(alignment: .leading) {
                Text(model.title)
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
        if !model.appManager.classTestReminders.isEnabled.unwrapped {
            hstack
                .contextMenu {
                    Button(action: {
                        NotificationManager.default.scheduleClassTestReminder(for: model.classTest)
                    }) {
                        Label("set_reminder", systemImage: "clock")
                    }
                }
        } else {
            hstack
        }
    }
    
    init(classTest: ClassTest, appManager: AppManager) {
        model = .init(classTest: classTest, appManager: appManager)
    }
}

struct ClassTestInlineView_Previews: PreviewProvider {
    static var previews: some View {
        ClassTestInlineView(classTest: MockData.classTest, appManager: .init())
    }
}
