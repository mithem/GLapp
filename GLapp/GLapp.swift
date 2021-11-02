//
//  GLapp.swift
//  GLapp
//
//  Created by Miguel Themann on 08.10.21.
//

import SwiftUI

@main
struct GLapp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @ObservedObject var dataManager: DataManager
    @ObservedObject var appManager: AppManager
    var body: some Scene {
        WindowGroup {
            ContentView(dataManager: dataManager, appManager: appManager)
        }
        .commands {
            CommandMenu("data_management") {
                Button("reload_all") {
                    dataManager.loadData()
                }
                .keyboardShortcut("R", modifiers: [.command, .shift])
                Button("reload_timetable") {
                    dataManager.loadTimetable()
                }
                .keyboardShortcut(.init(.init(NSLocalizedString("keyboard_shortcut_reload_timetable"))))
                Button("reload_class_tests") {
                    dataManager.loadClassTestPlan()
                }
                .keyboardShortcut(.init(.init(NSLocalizedString("keyboard_shortcut_reload_class_test_plan"))))
                Button("reload_representative_plan") {
                    dataManager.loadRepresentativePlan()
                }
                .keyboardShortcut(.init(.init(NSLocalizedString("keyboard_shortcut_reload_representative_plan"))))
                Button("clear_cache") {
                    dataManager.clearAllLocalData()
                }
                .keyboardShortcut(KeyEquivalent.delete, modifiers: [.command, .shift])
            }
        }
    }
    
    init() {
        let appManager = AppManager()
        dataManager = .init(appManager: appManager)
        self.appManager = appManager
    }
}
