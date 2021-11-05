//
//  RepresentativeLessonInlineView.swift
//  RepresentativeLessonInlineView
//
//  Created by Miguel Themann on 09.10.21.
//

import SwiftUI

struct RepresentativeLessonInlineView: View {
    let lesson: RepresentativeLesson
    @ObservedObject var appManager: AppManager
    @Environment(\.colorScheme) private var colorScheme
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                    .bold()
                    .foregroundColor(titleColor)
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
            VStack(alignment: .trailing) {
                Text(lesson.normalTeacher)
                if let note = lesson.note {
                    Text(note)
                } else {
                    Spacer()
                }
            }
        }
        .foregroundColor(lesson.isOver ? .secondary : .primary)
    }
    
    var title: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        return "\(formatter.string(from: NSNumber(value: lesson.lesson))!) \(lesson.subject.subjectName ?? lesson.subject.className)"
    }
    
    var titleColor: Color {
        if lesson.isOver {
            return .secondary
        }
        if appManager.coloredInlineSubjects.isEnabled == .yes {
            return lesson.subject.color.getColoredForegroundColor(colorScheme: colorScheme)
        }
        return .primary
    }
}

struct RepresentativeLessonInlineView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RepresentativeLessonInlineView(lesson: MockData.representativeLesson, appManager: .init())
            RepresentativeLessonInlineView(lesson: MockData.representativeLesson2, appManager: .init())
        }
        .previewLayout(.sizeThatFits)
    }
}
