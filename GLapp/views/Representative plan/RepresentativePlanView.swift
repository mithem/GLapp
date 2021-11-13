//
//  RepresentativePlanView.swift
//  RepresentativePlanView
//
//  Created by Miguel Themann on 08.10.21.
//

import SwiftUI

struct RepresentativePlanView: View {
    @ObservedObject var appManager: AppManager
    @ObservedObject var dataManager: DataManager
    let startDate = Date.rightNow
    let timer = Timer.publish(every: Constants.timeIntervalRequiringUserActivityUntilNSUserActivityIsDonated, tolerance: nil, on: .current, in: .common).autoconnect()
    @State private var didDonateUserActivity = false
    var InnerView: some View {
        VStack {
            DataManagementTaskView(date: dataManager.representativePlan?.date, lastFetched: dataManager.representativePlan?.lastFetched, task: dataManager.tasks.getRepresentativePlan)
            Spacer()
            if let reprPlan = dataManager.representativePlan {
                VStack {
                    if reprPlan.isEmpty {
                        EmptyContentView(image: emptyViewIcon, text: "representative_plan_empty")
                    } else {
                        let list = List {
                            if !reprPlan.notes.isEmpty {
                                Section(content: {
                                    ForEach(reprPlan.notes) { note in
                                        Text(note)
                                    }
                                }, header: {
                                    Text("notes")
                                })
                            }
                            ForEach(reprPlan.representativeDays) { reprDay in
                                Section(content: {
                                    ForEach(reprDay.lessons) { lesson in
                                        RepresentativeLessonInlineView(lesson: lesson, appManager: appManager)
                                    }
                                }, header: {
                                    Text(reprDay.date?.formattedWithLocaleOnlyDay ?? NSLocalizedString("sometime"))
                                })
                            }
                        }
                        .listStyle(UIConstants.listStyle)
                        if #available(iOS 15, *) {
                            list
                                .refreshable {
                                    dataManager.loadRepresentativePlan()
                                }
                        } else {
                            list
                        }
                    }
                }
            } else {
                AccentColorButton(label: {Text("retry")}) {
                    dataManager.loadRepresentativePlan(withHapticFeedback: true)
                }
            }
            Spacer()
        }
        .onReceive(timer) { timer in
            if startDate.distance(to: .rightNow) >= Constants.timeIntervalRequiringUserActivityUntilNSUserActivityIsDonated && !didDonateUserActivity {
                IntentToHandle.showRepresentativePlan.donate()
                didDonateUserActivity = true
            }
        }
        .navigationTitle("representative_plan")
        .toolbar {
            Button(action: {
                dataManager.loadRepresentativePlan(withHapticFeedback: true)
            }) {
                Image(systemName: "arrow.clockwise")
            }
        }
    }
    
    var emptyViewIcon: String {
        if #available(iOS 15, *) {
            return "circle.slash"
        } else {
            return "slash.circle"
        }
    }
    
    var body: some View {
        if UIDevice.current.userInterfaceIdiom == .pad {
            InnerView
        } else if UIDevice.current.userInterfaceIdiom == .phone {
            NavigationView {
                InnerView
            }
            .navigationViewStyle(.stack)
        }
    }
}

struct RepresentativePlanView_Previews: PreviewProvider {
    static var previews: some View {
        RepresentativePlanView(appManager: .init(), dataManager: MockDataManager())
    }
}
