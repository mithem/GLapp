//
//  RepresentativeLessonInlineView.swift
//  RepresentativeLessonInlineView
//
//  Created by Miguel Themann on 09.10.21.
//

import SwiftUI

struct RepresentativeLessonInlineView: View {
    @ObservedObject var model: RepresentativeLessonInlineViewModel
    @Environment(\.colorScheme) private var colorScheme
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(model.title)
                    .bold()
                    .foregroundColor(model.titleColor(colorScheme: colorScheme))
                    .confirmationDialog(provider: model.confirmationDialogProvider, actionButtons: model.self.actionButtons, cancelButtons: model.self.cancelButtons)
                    .onTapGesture {
                        model.onTapTitle()
                    }
                HStack {
                    if let room = model.lesson.room {
                        Text(room)
                            .strikethrough(model.lesson.newRoom != nil)
                    }
                    if let newRoom = model.lesson.newRoom {
                        Text(newRoom)
                    }
                }
            }
            Spacer()
            VStack(alignment: .trailing) {
                HStack {
                    if let normalTeacher = model.lesson.normalTeacher {
                        Text(normalTeacher)
                            .strikethrough(model.lesson.representativeTeacher != nil)
                    }
                    if let reprTeacher = model.lesson.representativeTeacher {
                        Text(reprTeacher)
                    }
                }
                if let note = model.lesson.note {
                    Text(note)
                } else {
                    Spacer()
                }
            }
        }
        .foregroundColor(model.lesson.isOver ? .secondary : .primary)
        .contextMenu {
            if !model.lesson.isInvalid {
                Button(action: {
                    model.showingLessonOrSubjectInfoView = true
                }) {
                    Label("more", systemImage: "ellipsis.circle")
                }
            }
        }
        .sheet(isPresented: $model.showingLessonOrSubjectInfoView) {
            LessonOrSubjectInfoView(subject: model.lesson.subject, dataManager: model.dataManager)
        }
    }
    
    init(lesson: RepresentativeLesson, appManager: AppManager, dataManager: DataManager) {
        model = .init(lesson: lesson, appManager: appManager, dataManager: dataManager)
    }
}

struct RepresentativeLessonInlineView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RepresentativeLessonInlineView(lesson: MockData.representativeLesson, appManager: .init(), dataManager: MockDataManager())
            RepresentativeLessonInlineView(lesson: MockData.representativeLesson2, appManager: .init(), dataManager: MockDataManager())
            RepresentativeLessonInlineView(lesson: .init(date: .rightNow, lesson: 3, room: nil, newRoom: nil, note: nil, subject: nil, normalTeacher: nil, representativeTeacher: nil), appManager: .init(), dataManager: MockDataManager())
            RepresentativeLessonInlineView(lesson: MockData.representativeLesson3, appManager: .init(), dataManager: MockDataManager())
        }
        .previewLayout(.sizeThatFits)
    }
}
