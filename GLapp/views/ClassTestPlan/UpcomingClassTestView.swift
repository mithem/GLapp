//
//  UpcomingClassTestView.swift
//  UpcomingClassTestView
//
//  Created by Miguel Themann on 15.10.21.
//

import SwiftUI

struct UpcomingClassTestView: View {
    @ObservedObject private var model: UpcomingClassTestViewModel
    @Environment(\.colorScheme) private var colorScheme
    var body: some View {
        if let classTest = model.classTest {
            HStack {
                VStack(alignment: .leading) {
                    Text("upcoming")
                        .font(.headline)
                    Text(classTest.subject.className)
                        .font(.subheadline)
                        .foregroundColor(model.subjectColor(colorScheme: colorScheme))
                }
                Spacer()
                VStack {
                    if let timeInterval = model.timeInterval {
                        Text(timeInterval)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                }
            }
            if model.pseudoBool {
                EmptyView()
            }
        } else {
            EmptyView()
        }
    }
    
    
    init(appManager: AppManager, classTests: [ClassTest]) {
        self.model = .init(appManager: appManager, classTests: classTests)
    }
}

struct UpcomingClassTestView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            UpcomingClassTestView(appManager: .init(), classTests: [MockData.classTest2])
            UpcomingClassTestView(appManager: .init(), classTests: [MockData.classTest3])
        }
    }
}
