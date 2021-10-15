//
//  ContentView.swift
//  GLapp
//
//  Created by Miguel Themann on 08.10.21.
//

import SwiftUI

struct ContentView: View {
    @State private var showingLoginView = false
    @ObservedObject var dataManager = DataManager()
    @AppStorage(UserDefaultsKeys.lastTabView) var lastTabView = 0
    var body: some View {
        TabView(selection: $lastTabView) {
            TimetableView(dataManager: dataManager)
                .tag(0)
                .tabItem {
                    Image(systemName: "calendar")
                    Text("timetable")
                }
            ClassTestPlanView()
                .tag(1)
                .tabItem {
                    Image(systemName: "doc.append")
                    Text("classtests")
                }
            RepresentativePlanView()
                .tag(2)
                .tabItem {
                    Image(systemName: "clock")
                    Text("representative_plan")
                }
            SettingsView()
                .tag(3)
                .tabItem {
                    Image(systemName: "gear")
                    Text("settings")
                }
        }
        .environmentObject(dataManager)
        .onAppear {
            BackgroundTaskManager.registerRepresentativeCheckTask()
            checkForNeedingToShowLoginView()
            dataManager.loadData()
        }
        .sheet(isPresented: $showingLoginView) {
            LoginView(delegate: self)
        }
    }
    func checkForNeedingToShowLoginView() {
        if !isLoggedIn() {
            showingLoginView = true
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
