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
    
    var iOSView: some View {
        TabView(selection: $model.currentView) {
            TimetableView(dataManager: model.dataManager)
                .tag(ContentViewModel.SubView.timetable)
                .tabItem {
                    Label("timetable", systemImage: "calendar")
                }
            if model.dataManager.tasks.getClassTestPlan.error != .classTestPlanNotSupported {
                ClassTestPlanView(appManager: model.appManager, dataManager: model.dataManager)
                    .tag(ContentViewModel.SubView.classTestPlan)
                    .tabItem {
                        Label("classtests", systemImage: "doc.append")
                    }
            }
            RepresentativePlanView(appManager: model.appManager, dataManager: model.dataManager)
                .tag(ContentViewModel.SubView.reprPlan)
                .tabItem {
                    reprPlanTabItemLabel
                }
            SettingsView(dataManager: model.dataManager, appManager: model.appManager)
                .tag(ContentViewModel.SubView.settings)
                .tabItem {
                    Label("settings", systemImage: "gear")
                }
        }
    }
    
    var iPadOSView: some View {
        NavigationView {
            List {
                NavigationLink(
                    destination: TimetableView(dataManager: model.dataManager),
                    tag: .timetable,
                    selection: $currentiPadOSView,
                    label: {
                        Label("timetable", systemImage: "calendar")
                })
                if model.dataManager.tasks.getClassTestPlan.error != .classTestPlanNotSupported {
                    NavigationLink(
                        destination: ClassTestPlanView(appManager: model.appManager, dataManager: model.dataManager),
                        tag: .classTestPlan,
                        selection: $currentiPadOSView,
                        label: {
                            Label("classtests", systemImage: "doc.append")
                    })
                        .keyboardShortcut("2")
                }
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
            .sheet(isPresented: $model.showingModalSheetView) {
            switch model.modalSheetView {
                case .loginView:
                    LoginView(appManager: model.appManager, dataManager: model.dataManager, delegate: self)
                case .functionalityCheckView:
                    FunctionalityCheckView(appManager: model.appManager, dataManager: model.dataManager)
                case .none:
                    Text("(empty)")
            }
        }
        .onReceive(model.timer) { timer in
            model.handleIntent()
        }
        .onAppear(perform: model.onAppear)
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
        model = .init(appManager: appManager, dataManager: dataManager)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(dataManager: MockDataManager(), appManager: .init())
    }
}
