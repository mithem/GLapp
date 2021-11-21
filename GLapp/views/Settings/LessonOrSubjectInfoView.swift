//
//  LessonOrSubjectInfoView.swift
//  LessonOrSubjectInfoView
//
//  Created by Miguel Themann on 17.10.21.
//

import SwiftUI

struct LessonOrSubjectInfoView: View {
    @ObservedObject var model: LessonOrSubjectInfoViewModel
    @Environment(\.presentationMode) private var presentationMode
    var body: some View {
        NavigationView {
            Form {
                if let subjectName = model.content.subject.subjectName {
                    SubjectAttributeView("subject_name", value: subjectName)
                }
                if let subjectType = model.content.subject.subjectType {
                    SubjectAttributeView("subject_type", value: subjectType)
                }
                if let teacher = model.content.subject.teacher {
                    SubjectAttributeView("teacher", value: teacher)
                }
                if let room = model.content.room {
                    SubjectAttributeView("room", value: room)
                }
                ColorPicker(selection: model.content.subjectColorBinding)
                {
                    Text("color")
                        .bold()
                }
            }
            .navigationTitle(model.content.subject.className)
            .toolbar {
                Button("done") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .onDisappear {
                guard let timetable = model.dataManager.timetable else { return }
                model.dataManager.saveLocalData(timetable, for: \.getTimetable)
                model.dataManager.representativePlan?.updateSubjects(with: model.dataManager)
            }
        }
    }
    
    init(lesson: Lesson? = nil, subject: Subject? = nil, dataManager: DataManager) {
        model = .init(lesson: lesson, subject: subject, dataManager: dataManager)
    }
}

struct EditSubjectView_Previews: PreviewProvider{
    static var previews: some View {
        LessonOrSubjectInfoView(lesson: MockData.lesson, dataManager: MockDataManager())
    }
}
