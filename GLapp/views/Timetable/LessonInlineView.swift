//
//  LessonInlineView.swift
//  LessonInlineView
//
//  Created by Miguel Themann on 09.10.21.
//

import SwiftUI

struct LessonInlineView: View {
    @ObservedObject var lesson: TimetableViewModel.TimetableViewLesson
    @ObservedObject var dataManager: DataManager
    @State private var showingLessonOrSubjectInfoView = false
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        let content = Button(action: {
            showingLessonOrSubjectInfoView = true
        }) {
            Spacer()
            if let title = title {
                Text(title)
                    .foregroundColor(.init(lesson.lesson?.subject.color.getForegroundColor(colorScheme: colorScheme) ?? .primary))
            }
            Spacer()
        }
            .frame(width: size.width)
            .frame(minHeight: size.height)
            .hoverEffect()
        if let lesson = lesson.lesson {
            content
                .background(
                    RoundedRectangle(cornerRadius: UIConstants.rrCornerRadius)
                        .foregroundColor(.init(lesson.subject.color))
                )
            .contextMenu {
                Button(action: {
                    showingLessonOrSubjectInfoView = true
                }, label: {
                    Label("more", systemImage: "ellipsis.circle")
                })
            }
            .sheet(isPresented: $showingLessonOrSubjectInfoView) {
                LessonOrSubjectInfoView(lesson: lesson, dataManager: dataManager)
            }
        } else {
            content
        }
    }
    
    var title: String? {
        guard let lesson = lesson.lesson else { return nil }
        return lesson.subject.subjectName ?? lesson.subject.className
    }
    
    var size: (width: CGFloat, height: CGFloat) {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return (width: 60, height: 30)
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            if horizontalSizeClass == .compact {
                return (width: 50, height: 30)
            }
            return (width: 120, height: 35)
        }
        fatalError("Unsupported userInterfaceIdiom (LessonInlineView.size)")
    }
}

struct LessonInlineView_Previews: PreviewProvider{
    static var previews: some View {
        LessonInlineView(lesson: .init(id: 0, lesson: MockData.lesson), dataManager: MockDataManager())
    }
}
