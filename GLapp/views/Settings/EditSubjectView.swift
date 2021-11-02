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
                    lesson.subject.color
                }, set: { newColor in
                    lesson.subject.color = newColor
                    dataManager.updateSubjectColorMap(className: lesson.subject.className, color: newColor)
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
                guard let timetable = dataManager.timetable else { return }
                dataManager.saveLocalData(timetable, for: \.getTimetable)
            }
        }
    }
}

struct EditSubjectView_Previews: PreviewProvider{
    static var previews: some View {
        EditSubjectView(lesson: MockData.lesson)
    }
}
