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
                HStack {
                    if let room = model.lesson.room {
                        Text(room)
                            .strikethrough(model.lesson.newRoom != nil)
                        if let newRoom = model.lesson.newRoom {
                            Text(newRoom)
                        }
                    }
                }
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(model.lesson.normalTeacher)
                if let note = model.lesson.note {
                    Text(note)
                } else {
                    Spacer()
                }
            }
        }
        .foregroundColor(model.lesson.isOver ? .secondary : .primary)
        .contextMenu {
            Button(action: {
                model.showingLessonOrSubjectInfoView = true
            }) {
                Label("more", systemImage: "ellipsis.circle")
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
        }
        .previewLayout(.sizeThatFits)
    }
}
