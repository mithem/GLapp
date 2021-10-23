//
//  RepresentativePlanView.swift
//  RepresentativePlanView
//
//  Created by Miguel Themann on 08.10.21.
//

import SwiftUI

struct RepresentativePlanView: View {
    @EnvironmentObject var dataManager: DataManager
    var InnerView: some View {
        VStack {
            DataManagementTaskView(date: dataManager.representativePlan?.date, lastFetched: dataManager.representativePlan?.lastFetched, task: dataManager.tasks.getRepresentativePlan)
            Spacer()
            if let reprPlan = dataManager.representativePlan {
                VStack {
                    if reprPlan.isEmpty {
                        EmptyContentView(image: "circle.slash", text: "representative_plan_empty")
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
                                        RepresentativeLessonInlineView(lesson: lesson)
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
                AccentColorButton(label: {Text("retry")}, action: dataManager.loadRepresentativePlan)
                    .disabled(dataManager.tasks.getRepresentativePlan.isLoading)
            }
            Spacer()
        }
        .navigationTitle("representative_plan")
        .toolbar {
            Button(action: dataManager.loadRepresentativePlan) {
                Image(systemName: "arrow.clockwise")
            }
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
        RepresentativePlanView()
            .environmentObject(MockDataManager())
    }
}
