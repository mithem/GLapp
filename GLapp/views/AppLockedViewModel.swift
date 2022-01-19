//
//  AppLockedViewModel.swift
//  GLapp
//
//  Created by Miguel Themann on 11.01.22.
//

import LocalAuthentication

@MainActor final class AppLockedViewModel: ObservableObject {
    /// Currently using LA to unlock the app (e.g. showing FaceID view).
    @Published var unlocking: Bool
    /// To track when unlocking starts and disabled when app reenters foreground after authentication.
    @Published var unlockingForegroundTracker: Bool
    
    var emptyViewIcon: String {
        if #available(iOS 15, *) {
            return "circle.slash"
        }
        return "slash.circle"
    }
    
    func unlock() {
        if !isAppLocked() || unlocking || unlockingForegroundTracker { return }
        unlockingForegroundTracker = true
        unlocking = true
        let didUnlockInCurrentSession = UserDefaults.standard.bool(for: \.didUnlockInCurrentSession)
        guard !didUnlockInCurrentSession, FRequireAuthentication.checkIfEnabled().unwrapped else { return }
        let context = LAContext()
        let reason = NSLocalizedString("feature_authentication_description")
        context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, error in
            if success {
                UserDefaults.standard.set(true, for: \.didUnlockInCurrentSession)
            }
            DispatchQueue.main.async {
                self.unlocking = false
            }
        }
    }
    
    func enterForeground() {
        if unlockingForegroundTracker && !unlocking {
            unlockingForegroundTracker = false
        }
    }
    
    init() {
        unlocking = false
        unlockingForegroundTracker = false
    }
}
