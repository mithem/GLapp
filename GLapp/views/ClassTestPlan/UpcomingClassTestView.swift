//
//  UpcomingClassTestView.swift
//  UpcomingClassTestView
//
//  Created by Miguel Themann on 15.10.21.
//

import SwiftUI

struct UpcomingClassTestView: View {
    let classTest: ClassTest
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("upcoming")
                    .font(.headline)
                Text(classTest.subject.className)
                    .font(.subheadline)
            }
            Spacer()
            VStack {
                if let timeInterval = timeInterval {
                    Text(timeInterval)
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
        }
    }
    
    var timeInterval: String? {
        let classTestComponents = Calendar(identifier: .gregorian).dateComponents(from: classTest.classTestDate)
        let todayComponents = Calendar(identifier: .gregorian).dateComponents(from: .init(timeIntervalSinceNow: 0))
        if classTestComponents == todayComponents {
            return NSLocalizedString("today")
        }
        let formatter = GLDateFormatter.relativeDateTimeFormatter
        if #available(iOS 15, *) {
            return formatter.localizedString(for: classTest.classTestDate, relativeTo: .now)
        } else {
            return formatter.localizedString(for: classTest.classTestDate, relativeTo: .init(timeIntervalSinceNow: 0))
        }
    }
}

struct UpcomingClassTestView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            UpcomingClassTestView(classTest: MockData.classTest)
            UpcomingClassTestView(classTest: MockData.classTest2)
        }
    }
}
