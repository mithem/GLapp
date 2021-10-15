//
//  ClassTestInlineView.swift
//  ClassTestInlineView
//
//  Created by Miguel Themann on 09.10.21.
//

import SwiftUI

struct ClassTestInlineView: View {
    let classTest: ClassTest
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                    .bold()
                Text(classTest.room ?? "")
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text("\(duration)\(classTest.classTestDate.formattedWithLocaleOnlyDay)")
                Text(classTest.teacher ?? "")
            }
                .foregroundColor(.secondary)
        }
    }
    
    var title: String {
        let subjectType: String
        if let sType = classTest.subject.subjectType {
            subjectType = " (\(sType))"
        } else {
            subjectType = ""
        }
        return "\(classTest.subject.subjectName ?? classTest.subject.className)\(subjectType)"
    }
    
    var duration: String {
        if let start = classTest.start, let end = classTest.end {
            let formatter = NumberFormatter()
            formatter.numberStyle = .ordinal
            let st = formatter.string(from: .init(value: start))!
            let en = formatter.string(from: .init(value: end))!
            return "\(st) - \(en), "
        } else {
            return ""
        }
    }
}

struct ClassTestInlineView_Previews: PreviewProvider {
    static var previews: some View {
        ClassTestInlineView(classTest: MockData.classTest)
    }
}
