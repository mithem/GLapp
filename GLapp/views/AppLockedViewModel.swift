//
//  AppLockedViewModel.swift
//  GLapp
//
//  Created by Miguel Themann on 11.01.22.
//

import LocalAuthentication

@MainActor final class AppLockedViewModel: ObservableObject {
    @Published var unlocking: Bool
    
    private var settingsStore: SettingsStore
    
    var emptyViewIcon: String {
        if #available(iOS 15, *) {
            return "circle.slash"
        }
        return "slash.circle"
    }
    
    func unlock() {
        if !isAppLocked() || unlocking || settingsStore.isUnlocking.getCurrentValue() == true { return }
        settingsStore.isUnlocking.set(to: true)
        self.unlocking = true
        let didUnlockInCurrentSession = settingsStore.didUnlockInCurrentSession.getCurrentValue() == true
        guard !didUnlockInCurrentSession, FRequireAuthentication.checkIfEnabled().unwrapped else { return }
        let context = LAContext()
        let reason = NSLocalizedString("feature_authentication_description")
        context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, error in
            if success {
                self.settingsStore.didUnlockInCurrentSession.set(to: true)
            }
            DispatchQueue.main.async {
                self.unlocking = false
            }
        }
    }
    
    func enterForeground() {
        if settingsStore.isUnlocking.getCurrentValue() == true && !unlocking {
            settingsStore.isUnlocking.set(to: false)
        }
    }
    
    init() {
        unlocking = false
        settingsStore = .init()
    }
}
