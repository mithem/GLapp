//
//  RepresentativeLessonInlineView.swift
//  RepresentativeLessonInlineView
//
//  Created by Miguel Themann on 09.10.21.
//

import SwiftUI

struct RepresentativeLessonInlineView: View {
    let lesson: RepresentativeLesson
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                    .bold()
                HStack {
                    if let room = lesson.room {
                        Text(room)
                            .strikethrough(lesson.newRoom != nil)
                        if let newRoom = lesson.newRoom {
                            Text(newRoom)
                        }
                    }
                }
            }
            Spacer()
            VStack {
                if let teacher = lesson.subject.teacher {
                    Text(teacher)
                    Spacer()
                }
            }
        }
    }
    
    var title: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        return "\(formatter.string(from: NSNumber(value: lesson.lesson))!) \(lesson.subject.subjectName ?? lesson.subject.className)"
    }
}

struct RepresentativeLessonInlineView_Previews: PreviewProvider {
    static var previews: some View {
        RepresentativeLessonInlineView(lesson: MockData.representativeLesson)
    }
}
