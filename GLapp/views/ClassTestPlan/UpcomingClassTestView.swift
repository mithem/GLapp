//
//  UpcomingClassTestView.swift
//  UpcomingClassTestView
//
//  Created by Miguel Themann on 15.10.21.
//

import SwiftUI

struct UpcomingClassTestView: View {
    let classTests: [ClassTest]
    var body: some View {
        if let classTest = classTest {
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
        } else {
            EmptyView()
        }
    }
    
    var classTest: ClassTest? {
        guard classTests.count > 0 else { return nil }
        for i in 0 ..< classTests.count {
            let classTest = classTests[i]
            if let endDate = classTest.endDate {
                if .justNow > endDate {
                    continue
                }
            }
            return classTest
        }
        return nil
    }
    
    var timeInterval: String? {
        guard let classTest = classTest else { return nil }

        let formatter = GLDateFormatter.relativeDateTimeFormatter
        return formatter.localizedString(for: classTest.startDate ?? classTest.classTestDate, relativeTo: .justNow)
    }
}

struct UpcomingClassTestView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            UpcomingClassTestView(classTests: [MockData.classTest2])
            UpcomingClassTestView(classTests: [MockData.classTest3])
        }
    }
}
