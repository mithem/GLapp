//
//  ContentView.swift
//  GLapp
//
//  Created by Miguel Themann on 08.10.21.
//

import SwiftUI
import Combine

struct ContentView: View {
    @State private var showingModalSheetView = false
    @State private var modalSheetView = ModalSheetView.loginView
    /// just for the iPadOS version to the first navlink (timetable) without the need to select something on the sidebar
    @State private var showingFirstNavigationLink = true
    @ObservedObject var appManager: AppManager
    @ObservedObject var dataManager: DataManager
    @AppStorage(UserDefaultsKeys.lastTabView) var lastTabView = 0
    var iOSView: some View {
        TabView(selection: $lastTabView) {
            TimetableView(dataManager: dataManager)
                .tag(0)
                .tabItem {
                    Label("timetable", systemImage: "calendar")
                }
            if dataManager.tasks.getClassTestPlan.error != .classTestPlanNotSupported {
                ClassTestPlanView(dataManager: dataManager, appManager: appManager)
                    .tag(1)
                    .tabItem {
                        Label("classtests", systemImage: "doc.append")
                    }
            }
            RepresentativePlanView(appManager: appManager, dataManager: dataManager)
                .tag(2)
                .tabItem {
                    reprPlanTabItemLabel
                }
            SettingsView(dataManager: dataManager, appManager: appManager)
                .tag(3)
                .tabItem {
                    Label("settings", systemImage: "gear")
                }
        }
    }
    
    var iPadOSView: some View {
        NavigationView {
            List {
                NavigationLink(isActive: $showingFirstNavigationLink, destination: {
                    TimetableView(dataManager: dataManager)
                }, label: {
                    Label("timetable", systemImage: "calendar")
                })
                    .keyboardShortcut("1")
                if dataManager.tasks.getClassTestPlan.error != .classTestPlanNotSupported {
                    NavigationLink(destination: {
                        ClassTestPlanView(dataManager: dataManager, appManager: appManager)
                    }, label: {
                        Label("classtests", systemImage: "doc.append")
                    })
                        .keyboardShortcut("2")
                }
                NavigationLink(destination: {
                    RepresentativePlanView(appManager: appManager, dataManager: dataManager)
                }, label: {
                    reprPlanTabItemLabel
                })
                    .keyboardShortcut(appManager.classTestPlan.isEnabled != .no ? "3" : "2")
                NavigationLink(destination: {
                    SettingsView(dataManager: dataManager, appManager: appManager)
                }, label: {
                    Label("settings", systemImage: "gear")
                })
                    .keyboardShortcut(appManager.classTestPlan.isEnabled != .no ? "4" : "3")
            }
            .listStyle(.sidebar)
            .navigationTitle("navigation")
            .navigationViewStyle(.stack)
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
        .sheet(isPresented: $showingModalSheetView) {
            switch modalSheetView {
            case .loginView:
                LoginView(appManager: appManager, dataManager: dataManager, delegate: self)
            case .functionalityCheckView:
                FunctionalityCheckView(appManager: appManager, dataManager: dataManager)
            }
        }
        .onAppear {
            appManager.reload(with: dataManager)
            checkForNeedingToShowLoginView()
            checkForNeedingToShowFunctionalityCheckView()
            dataManager.loadData()
            NotificationManager.default.removeAllDeliveredAndAppropriate()
        }
        .onDisappear {
            dataManager.saveLocalData()
            appManager.classTestReminders.scheduleClassTestRemindersIfAppropriate(with: dataManager)
        }
    }
    
    var reprPlanTabItemIcon: String {
        if #available(iOS 15, *) {
            if dataManager.representativePlan?.isEmpty == false {
                return "clock.badge.exclamationmark"
            }
        }
        return "clock"
    }
    
    var reprPlanTabItemLabel: some View {
        Group {
            if #available(iOS 15, *), dataManager.representativePlan?.isEmpty == false {
                Label(title: {
                    Text("representative_plan")
                }, icon: {
                    Image(systemName: reprPlanTabItemIcon)
                        .foregroundStyle(.orange, Color.accentColor)
                })
            } else {
                Label("representative_plan", systemImage: reprPlanTabItemIcon)
            }
        }
    }
    
    func checkForNeedingToShowLoginView() {
        if !isLoggedIn() && appManager.demoMode.isEnabled != .yes {
            modalSheetView = .loginView
            showingModalSheetView = true
        }
    }
    
    func checkForNeedingToShowFunctionalityCheckView() {
        let count = UserDefaults.standard.integer(forKey: UserDefaultsKeys.launchCount)
        // show it on second launch
        if count == 2 {
            modalSheetView = .functionalityCheckView
            showingModalSheetView = true
        }
    }
    
    init(dataManager: DataManager, appManager: AppManager) {
        self.dataManager = dataManager
        self.appManager = appManager
    }
    
    private enum ModalSheetView {
        case loginView, functionalityCheckView
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(dataManager: MockDataManager(), appManager: .init())
    }
}
