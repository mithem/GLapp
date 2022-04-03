//
//  RepresentativePlanView.swift
//  RepresentativePlanView
//
//  Created by Miguel Themann on 08.10.21.
//

import SwiftUI

struct RepresentativePlanView: View {
    @ObservedObject var model: RepresentativePlanViewModel
    var InnerView: some View {
        VStack {
            if model.appManager.demoMode.isEnabled.unwrapped {
                DemoModeWarningView(appManager: model.appManager, dataManager: model.dataManager)
            }
            DataManagementTaskView(date: model.dataManager.representativePlan?.date, lastFetched: model.dataManager.representativePlan?.lastFetched, task: model.dataManager.tasks.getRepresentativePlan)
            Spacer()
            if let reprPlan = model.dataManager.representativePlan {
                VStack {
                    if reprPlan.isEmpty {
                        EmptyContentView(image: model.emptyViewIcon, text: "representative_plan_empty")
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
                                    ForEach(reprDay.notes) { note in
                                        Text(note)
                                    }
                                    ForEach(reprDay.lessons) { lesson in
                                        RepresentativeLessonInlineView(lesson: lesson, appManager: model.appManager, dataManager: model.dataManager)
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
                                    model.reload()
                                }
                        } else {
                            list
                        }
                    }
                }
            } else {
                AccentColorButton(label: {Text("retry")}) {
                    model.reload()
                }
            }
            Spacer()
        }
        .onReceive(model.timer) { timer in
            model.donateIntent()
        }
        .navigationTitle("representative_plan")
        .toolbar {
            Button(action: {
                model.reload()
            }) {
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
    
    init(appManager: AppManager, dataManager: DataManager) {
        model = .init(appManager: appManager, dataManager: dataManager)
    }
}

#if DEBUG
struct RepresentativePlanView_Previews: PreviewProvider {
    static var previews: some View {
        RepresentativePlanView(appManager: .init(), dataManager: MockDataManager())
    }
}
#endif
