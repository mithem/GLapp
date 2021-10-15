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
    var iOSView: some View {
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
    }
    
    var iPadOSView: some View {
        NavigationView {
            List {
                NavigationLink(destination: {TimetableView(dataManager: dataManager)}, label: {
                    Image(systemName: "calendar")
                        .foregroundColor(.accentColor)
                    Text("timetable")
                })
                NavigationLink(destination: {ClassTestPlanView()}, label: {
                    Image(systemName: "doc.append")
                        .foregroundColor(.accentColor)
                    Text("classtests")
                })
                NavigationLink(destination: {RepresentativePlanView()}, label: {
                    Image(systemName: "clock")
                        .foregroundColor(.accentColor)
                    Text("representative_plan")
                })
                NavigationLink(destination: {SettingsView()}, label: {
                    Image(systemName: "gear")
                        .foregroundColor(.accentColor)
                    Text("settings")
                })
            }
            .listStyle(.sidebar)
        }
    }
    
    var OSSpecificView: some View {
        let idiom = UIDevice.current.userInterfaceIdiom
        return Group {
            if idiom == .phone {
                iOSView
            } else if idiom == .pad {
                iPadOSView
            }
        }
    }
    
    var body: some View {
        OSSpecificView
        .environmentObject(dataManager)
        .onAppear {
            checkForNeedingToShowLoginView()
            dataManager.loadData()
            NotificationManager.requestNotificationAuthorization()
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
