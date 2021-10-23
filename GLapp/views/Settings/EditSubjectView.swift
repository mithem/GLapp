//
//  EditSubjectView.swift
//  EditSubjectView
//
//  Created by Miguel Themann on 17.10.21.
//

import SwiftUI

struct EditSubjectView: View {
    @StateObject var lesson: Lesson
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.presentationMode) private var presentationMode
    var body: some View {
        NavigationView {
            Form {
                if let subjectName = lesson.subject.subjectName {
                    SubjectAttributeView("subject_name", value: subjectName)
                }
                if let subjectType = lesson.subject.subjectType {
                    SubjectAttributeView("subject_type", value: subjectType)
                }
                if let teacher = lesson.subject.teacher {
                    SubjectAttributeView("teacher", value: teacher)
                }
                if let room = lesson.room {
                    SubjectAttributeView("room", value: room)
                }
                ColorPicker(selection: .init(get: {
                    lesson.subject.getColor().colorBinding.wrappedValue
                }, set: { color in
                    lesson.subject.setColor(.init(color), with: dataManager)
                })) {
                    Text("color")
                        .bold()
                }
            }
            .navigationTitle(lesson.subject.className)
            .toolbar {
                Button("done") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .onDisappear {
                dataManager.saveSubjectColorMap()
                dataManager.timetable?.reloadSubjects(with: dataManager)
            }
        }
    }
}

struct EditSubjectView_Previews: PreviewProvider{
    static var previews: some View {
        EditSubjectView(lesson: MockData.lesson)
    }
}
