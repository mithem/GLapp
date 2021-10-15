//
//  LessonInlineView.swift
//  LessonInlineView
//
//  Created by Miguel Themann on 09.10.21.
//

import SwiftUI

struct LessonInlineView: View {
    let lesson: TimetableViewModel.TimetableViewLesson
    var body: some View {
        VStack {
            Spacer()
            if let title = title {
                Text(title)
            } else {
                RoundedRectangle(cornerRadius: UIConstants.rrCornerRadius)
                    .foregroundColor(.accentColor)
            }
            Spacer()
        }
    }
    
    var title: String? {
        guard let lesson = lesson.lesson else { return nil }
        return lesson.subject.subjectName ?? lesson.subject.className
    }
}

struct LessonInlineView_Previews: PreviewProvider {
    static var previews: some View {
        LessonInlineView(lesson: .init(id: 0, lesson: MockData.lesson))
    }
}
