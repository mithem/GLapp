//
//  RepresentativePlanView.swift
//  RepresentativePlanView
//
//  Created by Miguel Themann on 08.10.21.
//

import SwiftUI

struct RepresentativePlanView: View {
    @EnvironmentObject var dataManager: DataManager
    var body: some View {
        NavigationView {
            ZStack {
                if dataManager.tasks.getRepresentativePlan.isLoading {
                    LoadingView()
                } else if let error = dataManager.tasks.getRepresentativePlan.error {
                    ErrorView(error: error, callback: dataManager.loadRepresentativePlan)
                } else if let reprPlan = dataManager.representativePlan {
                    VStack {
                        HStack {
                            Text("date_colon \(reprPlan.date.formattedWithLocale)")
                            Spacer()
                        }
                        .padding()
                        Spacer()
                        if reprPlan.isEmpty {
                            EmptyContentView(image: "circle.slash", text: "representative_plan_empty")
                        } else {
                            List {
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
                                        Text(reprDay.date?.formattedWithLocaleOnlyDay ?? NSLocalizedString("sometime", comment: "sometime"))
                                    })
                                }
                            }
                            .listStyle(UIConstants.listStyle)
                        }
                        Spacer()
                    }
                } else {
                    Text("no_data")
                        .onAppear {
                            dataManager.setError(NetworkError.noData, for: \.getRepresentativePlan)
                        }
                }
            }
            .navigationTitle("representative_plan")
        }
    }
}

struct RepresentativePlanView_Previews: PreviewProvider {
    static var previews: some View {
        RepresentativePlanView()
            .environmentObject(MockDataManager())
    }
}
