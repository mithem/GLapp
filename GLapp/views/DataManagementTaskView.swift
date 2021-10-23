//
//  DataManagementTaskView.swift
//  DataManagementTaskView
//
//  Created by Miguel Themann on 16.10.21.
//

import SwiftUI

struct DataManagementTaskView<ContentType>: View where ContentType: Codable {
    let date: Date?
    let lastFetched: Date?
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var pseudoBool = false
    @ObservedObject var task: DataManagementTask<ContentType>
    var body: some View {
        VStack {
            HStack(spacing: 30) {
                if let date = date {
                    Text("date_colon \(date.formattedWithLocale)")
                }
                if date == nil && task.isLoading {
                    Text("loading_msg")
                }
                if task.isLoading {
                    ProgressView()
                }
            }
            Text(caption)
                .font(.caption)
                .foregroundColor(.secondary)
            if pseudoBool { // might be some well-working bodge
                EmptyView()
            }
        }
        .onReceive(timer) { _ in
            pseudoBool.toggle()
        }
    }
    
    var caption: String {
        var msgs = [String]()
        if let lastFetched = lastFetched {
            let date = Date(timeIntervalSinceNow: 1) // prevent "last fetched in 0 seconds"
            let lastFetchedStr = GLDateFormatter.relativeDateTimeFormatter.localizedString(for: lastFetched, relativeTo: date)
            msgs.append(NSLocalizedString("last_fetched") + " " + lastFetchedStr)
        }
        if let error = task.error {
            msgs.append(.init(error.localizedMessage))
        }
        return msgs.lazy.map {String($0)}.joined(separator: ", ")
    }
}

struct DataManagementTaskView_Previews: PreviewProvider {
    static var previews: some View {
        DataManagementTaskView(date: MockData.timetable.date, lastFetched: MockData.timetable.lastFetched, task: MockDataManager().tasks.getTimetable)
    }
}
