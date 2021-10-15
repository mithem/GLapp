//
//  ClassTestPlanView.swift
//  ClassTestPlanView
//
//  Created by Miguel Themann on 08.10.21.
//

import SwiftUI

struct ClassTestPlanView: View {
    @EnvironmentObject private var dataManager: DataManager
    var body: some View {
        NavigationView {
            ZStack {
                if dataManager.tasks.getClassTestPlan.isLoading {
                    LoadingView()
                } else if let error = dataManager.tasks.getClassTestPlan.error {
                    ErrorView(error: error, callback: dataManager.loadClassTestPlan)
                } else if let plan = dataManager.classTestPlan {
                    VStack {
                        HStack {
                            Text("date_colon \(plan.date.formattedWithLocale)")
                            Spacer()
                        }
                        .padding()
                        Spacer()
                        if plan.isEmpty {
                            EmptyContentView(image: "sparkles", text: "classTestPlan_empty")
                        } else {
                            List {
                                ForEach(plan.classTests) { classTest in
                                    ClassTestInlineView(classTest: classTest)
                                }
                            }
                            .listStyle(UIConstants.listStyle)
                        }
                        Spacer()
                    }
                } else {
                    Text("no_data")
                        .onAppear {
                            dataManager.setError(NetworkError.noData, for: \.getClassTestPlan)
                        }
                }
            }
            .navigationTitle("classtests")
        }
    }
}

struct ClassTestPlanView_Previews: PreviewProvider {
    static var previews: some View {
        ClassTestPlanView()
            .environmentObject(MockDataManager())
    }
}
