//
//  ClassTestPlanView.swift
//  ClassTestPlanView
//
//  Created by Miguel Themann on 08.10.21.
//

import SwiftUI

struct ClassTestPlanView: View {
    @ObservedObject var model: ClassTestPlanViewModel
    var InnerView: some View {
        VStack {
            DataManagementTaskView(date: model.dataManager.classTestPlan?.date, lastFetched: model.dataManager.classTestPlan?.lastFetched, task: model.dataManager.tasks.getClassTestPlan)
            Spacer()
            if let plan = model.dataManager.classTestPlan {
                if plan.isEmpty {
                    EmptyContentView(image: "sparkles", text: "classTestPlan_empty")
                } else {
                    let list = List {
                        UpcomingClassTestView(appManager: model.appManager, classTests: plan.classTests)
                        ForEach(plan.classTests) { classTest in
                            ClassTestInlineView(classTest: classTest, appManager: model.appManager)
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
            } else {
                AccentColorButton(label: {
                    Text("retry")
                }) {
                    model.reload()
                }
            }
            Spacer()
        }
        .onReceive(model.timer) { timer in
            model.donateIntent()
        }
        .navigationTitle("classtests")
        .toolbar {
            Button(action: {
                model.reload()
            }) {
                Image(systemName: "arrow.clockwise")
            }
        }
    }
    
    var body: some View {
        Group {
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
    
    init(appManager: AppManager, dataManager: DataManager) {
        model = .init(appManager: appManager, dataManager: dataManager)
    }
}

struct ClassTestPlanView_Previews: PreviewProvider {
    static var previews: some View {
        ClassTestPlanView(appManager: .init(), dataManager: MockDataManager())
    }
}
