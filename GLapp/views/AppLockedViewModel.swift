//
//  AppLockedViewModel.swift
//  GLapp
//
//  Created by Miguel Themann on 11.01.22.
//

import LocalAuthentication

@MainActor final class AppLockedViewModel: ObservableObject {
    @Published var unlocking: Bool
    
    var emptyViewIcon: String {
        if #available(iOS 15, *) {
            return "circle.slash"
        }
        return "slash.circle"
    }
    
    func unlock() {
        unlocking = true
        let didUnlockInCurrentSession = UserDefaults.standard.bool(for: \.didUnlockInCurrentSession)
        guard !didUnlockInCurrentSession, FRequireAuthentication.checkIfEnabled().unwrapped else { return }
        let context = LAContext()
        let reason = NSLocalizedString("feature_authentication_description")
        context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, error in
            DispatchQueue.main.async {
                if success {
                    UserDefaults.standard.set(true, for: \.didUnlockInCurrentSession)
                }
                self.unlocking = false
            }
        }
    }
    
    init() {
        unlocking = false
    }
}
