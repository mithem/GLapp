//
//  ContentView.swift
//  GLapp
//
//  Created by Miguel Themann on 08.10.21.
//

import SwiftUI
import Combine

struct ContentView: View {
    @ObservedObject var model: ContentViewModel
    @State var currentiPadOSView: ContentViewModel.SubView? = .timetable // when using custom bindings created in VM, SwiftUI isn't notified of any change, so the view doesn't update (my best guess, anyways)
    @State private var modalSheetView = ContentViewModel.ModalSheetView.none
    @State private var showingModalSheetView = false
    @AppStorage(UserDefaultsKeys().lastTabView) var lastTabView = 0 // using a state keeper in VM always leads to **some** unexpected behavior
    
    var iOSView: some View {
        TabView(selection: $lastTabView) {
            TimetableView(appManager: model.appManager, dataManager: model.dataManager)
                .tag(0)
                .tabItem {
                    Label("timetable", systemImage: "calendar")
                }
            ClassTestPlanView(appManager: model.appManager, dataManager: model.dataManager)
                .tag(1)
                .tabItem {
                    Label("classtests", systemImage: "doc.append")
                }
            RepresentativePlanView(appManager: model.appManager, dataManager: model.dataManager)
                .tag(2)
                .tabItem {
                    reprPlanTabItemLabel
                }
            SettingsView(dataManager: model.dataManager, appManager: model.appManager)
                .tag(3)
                .tabItem {
                    Label("settings", systemImage: "gear")
                }
        }
    }
    
    var iPadOSView: some View {
        NavigationView {
            List {
                NavigationLink(
                    destination: TimetableView(appManager: model.appManager, dataManager: model.dataManager),
                    tag: .timetable,
                    selection: $currentiPadOSView,
                    label: {
                        Label("timetable", systemImage: "calendar")
                })
                    .keyboardShortcut("1")
                NavigationLink(
                    destination: ClassTestPlanView(appManager: model.appManager, dataManager: model.dataManager),
                    tag: .classTestPlan,
                    selection: $currentiPadOSView,
                    label: {
                        Label("classtests", systemImage: "doc.append")
                })
                    .keyboardShortcut("2")
                NavigationLink(
                    destination: RepresentativePlanView(appManager: model.appManager, dataManager: model.dataManager),
                    tag: .reprPlan,
                    selection: $currentiPadOSView,
                    label: {
                        reprPlanTabItemLabel
                })
                    .keyboardShortcut(model.appManager.classTestPlan.isEnabled.unwrapped ? "3" : "2")
                NavigationLink(
                    destination: SettingsView(dataManager: model.dataManager, appManager: model.appManager),
                    tag: .settings,
                    selection: $currentiPadOSView,
                    label: {
                        Label("settings", systemImage: "gear")
                })
                    .keyboardShortcut(model.appManager.classTestPlan.isEnabled.unwrapped ? "4" : "3")
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
                    LoginView(appManager: model.appManager, dataManager: model.dataManager, delegate: self)
                case .functionalityCheckView:
                    FunctionalityCheckView(appManager: model.appManager, dataManager: model.dataManager)
                case .versionUpdatePromoView:
                    VersionUpdatePromoView(appManager: model.appManager, dataManager: model.dataManager, showCloseButton: true)
                    .onAppear {
                        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                    }
                case .none:
                    Text("(empty)")
            }
        }
        .onReceive(model.timer) { timer in
            model.tick()
        }
        .onAppear {
            model.onAppear()
            modalSheetView = model.showModalSheetView()
            if modalSheetView != .none {
                showingModalSheetView = true
            }
        }
        .onDisappear(perform: model.onDisappear)
    }
    
    
    var reprPlanTabItemLabel: some View {
        Group {
            if #available(iOS 15, *), model.dataManager.representativePlan?.isEmpty == false {
                Label(title: {
                    Text("representative_plan")
                }, icon: {
                    Image(systemName: model.reprPlanTabItemIcon)
                        .foregroundStyle(.orange, Color.accentColor)
                })
            } else {
                Label("representative_plan", systemImage: model.reprPlanTabItemIcon)
            }
        }
    }
    
    init(dataManager: DataManager, appManager: AppManager) {
        model = ContentViewModel(appManager: appManager, dataManager: dataManager)
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(dataManager: MockDataManager(), appManager: .init())
    }
}
#endif
