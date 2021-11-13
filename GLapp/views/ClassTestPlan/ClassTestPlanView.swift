//
//  ClassTestPlanView.swift
//  ClassTestPlanView
//
//  Created by Miguel Themann on 08.10.21.
//

import SwiftUI

struct ClassTestPlanView: View {
    @ObservedObject var dataManager: DataManager
    @ObservedObject var appManager: AppManager
    let startDate = Date.rightNow
    let timer = Timer.publish(every: Constants.timeIntervalRequiringUserActivityUntilNSUserActivityIsDonated, tolerance: nil, on: .current, in: .common).autoconnect()
    @State private var didDonateUserActivity = false
    var InnerView: some View {
        VStack {
            DataManagementTaskView(date: dataManager.classTestPlan?.date, lastFetched: dataManager.classTestPlan?.lastFetched, task: dataManager.tasks.getClassTestPlan)
            Spacer()
            if let plan = dataManager.classTestPlan {
                if plan.isEmpty {
                    EmptyContentView(image: "sparkles", text: "classTestPlan_empty")
                } else {
                    let list = List {
                        UpcomingClassTestView(appManager: appManager, classTests: plan.classTests)
                        ForEach(plan.classTests) { classTest in
                            ClassTestInlineView(classTest: classTest, appManager: appManager)
                        }
                    }
                    .listStyle(UIConstants.listStyle)
                    if #available(iOS 15, *) {
                        list
                            .refreshable {
                                dataManager.loadClassTestPlan()
                            }
                    } else {
                        list
                    }
                }
            } else {
                AccentColorButton(label: {Text("retry")}) {
                    dataManager.loadClassTestPlan(withHapticFeedback: true)
                }
            }
            Spacer()
        }
        .onReceive(timer) { timer in
            if startDate.distance(to: .rightNow) >= Constants.timeIntervalRequiringUserActivityUntilNSUserActivityIsDonated && !didDonateUserActivity {
                IntentToHandle.showClassTestPlan.donate()
                didDonateUserActivity = true
            }
        }
        .navigationTitle("classtests")
        .toolbar {
            Button(action: {
                dataManager.loadClassTestPlan(withHapticFeedback: true)
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
}

struct ClassTestPlanView_Previews: PreviewProvider {
    static var previews: some View {
        ClassTestPlanView(dataManager: MockDataManager(), appManager: .init())
    }
}
