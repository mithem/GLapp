//
//  LessonInlineView.swift
//  LessonInlineView
//
//  Created by Miguel Themann on 09.10.21.
//

import SwiftUI

struct LessonInlineView: View {
    @ObservedObject var lesson: TimetableViewModel.TimetableViewLesson
    @State private var showingEditSubjectView = false
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    var body: some View {
        let vstack = VStack {
            Spacer()
            if let title = title {
                Text(title)
            }
            Spacer()
        }
            .frame(width: size.width, height: size.height)
            .onTapGesture {
                showingEditSubjectView = true
            }
        if let lesson = lesson.lesson {
            vstack
                .background(RoundedRectangle(cornerRadius: UIConstants.rrCornerRadius).foregroundColor(lesson.subject.getColor().colorBinding.wrappedValue))
            .contextMenu {
                Button("more") {
                    showingEditSubjectView = true
                }
            }
            .sheet(isPresented: $showingEditSubjectView) {
                EditSubjectView(lesson: lesson)
            }
        } else {
            vstack
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
        LessonInlineView(lesson: .init(id: 0, lesson: MockData.lesson))
    }
}
