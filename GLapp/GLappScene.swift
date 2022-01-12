//
//  GLappScene.swift
//  GLapp
//
//  Created by Miguel Themann on 05.11.21.
//

import SwiftUI

struct GLappScene: Scene {
    @ObservedObject var dataManager: DataManager
    @ObservedObject var appManager: AppManager
    var body: some Scene {
        WindowGroup {
            AppLockGateView(dataManager: dataManager, appManager: appManager)
        }
        .commands {
            CommandMenu("data_management") {
                Button("reload_all") {
                    dataManager.loadData(withHapticFeedBack: true) // maybe that day will come [where iPads have a taptic engine]
                }
                .keyboardShortcut("R", modifiers: [.command, .shift])
                Button("reload_timetable") {
                    dataManager.loadTimetable(withHapticFeedback: true)
                }
                .keyboardShortcut(.init(.init(NSLocalizedString("keyboard_shortcut_reload_timetable"))))
                Button("reload_class_tests") {
                    dataManager.loadClassTestPlan(withHapticFeedback: true)
                }
                .keyboardShortcut(.init(.init(NSLocalizedString("keyboard_shortcut_reload_class_test_plan"))))
                Button("reload_representative_plan") {
                    dataManager.loadRepresentativePlan(withHapticFeedback: true)
                }
                .keyboardShortcut(.init(.init(NSLocalizedString("keyboard_shortcut_reload_representative_plan"))))
                Button("clear_cache") {
                    dataManager.clearAllLocalData(withHapticFeedback: true)
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
