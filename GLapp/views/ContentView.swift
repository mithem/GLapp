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
    @ObservedObject var appManager: AppManager
    @ObservedObject var dataManager: DataManager
    @AppStorage(UserDefaultsKeys.lastTabView) var lastTabView = 0
    let timer = Timer.publish(every: 1, tolerance: nil, on: .current, in: .common).autoconnect() // I know that's less elegant and efficient, but how else would I do that?
    var iOSView: some View {
        TabView(selection: $lastTabView) {
            TimetableView(dataManager: dataManager)
                .tag(0)
                .tabItem {
                    Label("timetable", systemImage: "calendar")
                }
            if dataManager.tasks.getClassTestPlan.error != .classTestPlanNotSupported {
                ClassTestPlanView(appManager: appManager, dataManager: dataManager)
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
                NavigationLink(isActive: .init(get: {
                    lastTabView == 0
                }, set: { enabled in
                    if enabled {
                        lastTabView = 0
                    }
                }), destination: {
                    TimetableView(dataManager: dataManager)
                }, label: {
                    Label("timetable", systemImage: "calendar")
                })
                    .keyboardShortcut("1")
                if dataManager.tasks.getClassTestPlan.error != .classTestPlanNotSupported {
                    NavigationLink(isActive: .init(get: {
                        lastTabView == 1
                    }, set: { enabled in
                        if enabled {
                            lastTabView = 1
                        }
                    }), destination: {
                        ClassTestPlanView(appManager: appManager, dataManager: dataManager)
                    }, label: {
                        Label("classtests", systemImage: "doc.append")
                    })
                        .keyboardShortcut("2")
                }
                NavigationLink(isActive: .init(get: {
                    lastTabView == 2
                }, set: { enabled in
                    if enabled {
                        lastTabView = 2
                    }
                }), destination: {
                    RepresentativePlanView(appManager: appManager, dataManager: dataManager)
                }, label: {
                    reprPlanTabItemLabel
                })
                    .keyboardShortcut(appManager.classTestPlan.isEnabled.unwrapped ? "3" : "2")
                NavigationLink(isActive: .init(get: {
                    lastTabView == 3
                }, set: { enabled in
                    if enabled {
                        lastTabView = 3
                    }
                }), destination: {
                    SettingsView(dataManager: dataManager, appManager: appManager)
                }, label: {
                    Label("settings", systemImage: "gear")
                })
                    .keyboardShortcut(appManager.classTestPlan.isEnabled.unwrapped ? "4" : "3")
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
        .onReceive(timer) { timer in
            handleIntent()
        }
        .onAppear {
            appManager.reload(with: dataManager)
            checkForNeedingToShowLoginView()
            applyFirstLaunchedConfiguration()
            dataManager.loadData()
            NotificationManager.default.removeAllDeliveredAndAppropriate()
            handleIntent()
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
    
    func handleIntent() {
        let intentToHandle = UserDefaults.standard.string(forKey: UserDefaultsKeys.intentToHandle)
        if let intent = IntentToHandle(rawValue: intentToHandle ?? "") {
            switch intent {
            case .showTimetable:
                lastTabView = 0
            case .showClassTestPlan:
                if appManager.classTestPlan.isEnabled.unwrapped {
                    lastTabView = 1
                } else {
                    lastTabView = 0
                }
            case .showRepresentativePlan:
                lastTabView = 2
            }
            UserDefaults.standard.set(nil, forKey: UserDefaultsKeys.intentToHandle)
        }
    }
    
    func checkForNeedingToShowLoginView() {
        if !isLoggedIn() && appManager.demoMode.isEnabled.unwrapped {
            modalSheetView = .loginView
            showingModalSheetView = true
        }
    }
    
    func applyFirstLaunchedConfiguration() {
        let count = UserDefaults.standard.integer(forKey: UserDefaultsKeys.launchCount)
        switch count {
        case 1:
            NotificationManager.default.requestNotificationAuthorization()
        case 2:
            modalSheetView = .functionalityCheckView
            showingModalSheetView = true
        default:
            break
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
