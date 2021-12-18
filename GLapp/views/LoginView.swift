//
//  LoginView.swift
//  LoginView
//
//  Created by Miguel Themann on 08.10.21.
//

import SwiftUI

struct LoginView: View {
    
    @State private var username = ""
    @State private var password = ""
    
    @AppStorage(UserDefaultsKeys().userIsTeacher) private var userIsTeacher = false
    
    @State private var error: NetworkError? = nil
    @State private var loading = false
    
    @State private var confirmationDialogReason = ConfirmationDialogReason.error
    
    @Environment(\.presentationMode) private var presentationMode
    
    @ObservedObject var appManager: AppManager
    @ObservedObject var dataManager: DataManager
    @ObservedObject var confirmationDialogProvider = ConfirmationDialogProvider(title: "not_available", body: "not_available")
    
    let delegate: LoginViewDelegate
    
    var confirmationDialogButtons: (actionButton: ConfirmationDialog.Button?, cancelButton: ConfirmationDialog.Button) {
        switch confirmationDialogReason {
        case .error:
            return (actionButton: nil, cancelButton: (title: "ok", callback: {}))
        case .demoMode:
            return (actionButton: (title: "enable", callback: activateDemoMode), cancelButton: (title: "cancel", {}))
        }
    }
    
    private func showActionSheet(reason: ConfirmationDialogReason) {
        confirmationDialogReason = reason
        DispatchQueue.main.async {
            switch reason {
            case .error:
                confirmationDialogProvider.confirmationDialog = (title: "error_occured", body: NSLocalizedString("error_colon") + " \(error?.localizedMessage ?? "unkown_error")")
            case .demoMode:
                confirmationDialogProvider.confirmationDialog = (title: "user_credentials_empty", body: "user_credentials_empty_activate_demo_mode")
            }
            confirmationDialogProvider.showingConfirmationDialog = true
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    TextField(.init("username"), text: $username)
                        .textContentType(.username)
                        .disableAutocorrection(true)
                    SecureField(.init("password"), text: $password)
                        .textContentType(.password)
                        .disableAutocorrection(true)
                    Toggle("teacher", isOn: $userIsTeacher)
                    let actionButtons = [confirmationDialogButtons.actionButton].compactMap({$0})
                    let cancelButtons = [confirmationDialogButtons.cancelButton]
                    Button(action: submitLogin) {
                        HStack(spacing: 10) {
                            Text("send")
                            if loading {
                                ProgressView()
                            }
                        }
                    }
                    .confirmationDialog(provider: confirmationDialogProvider, actionButtons: actionButtons, cancelButtons: cancelButtons)
                    .keyboardShortcut(.defaultAction)
                    .disabled(loading)
                    Text("note_all_traffic_encrypted")
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("login")
        }
    }
    
    func submitLogin() {
        if username.isEmpty && password.isEmpty {
            showActionSheet(reason: .demoMode)
            return
        }
        if appManager.demoMode.isEnabled.unwrapped {
            do {
                try appManager.demoMode.disable(with: appManager, dataManager: dataManager)
            } catch {
                handle(error: error)
            }
        }
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        loading = true
        submitLoginAndSaveMobileKey(username: username, password: password) { result in
            loading = false
            switch (result) {
            case .success:
                appManager.reset()
                delegate.didSaveWithSuccess()
                generator.notificationOccurred(.success)
                error = nil
                presentationMode.wrappedValue.dismiss()
            case .successWithData(_):
                fatalError("error_submitting_login_information_returning_data")
            case .failure(let error):
                handle(error: error, generator: generator)
            }
        }
    }
    
    func handle(error: Error) {
        var netError = error as? NetworkError
        if netError == nil {
            netError = .other(error)
        }
        handle(error: netError!, generator: .init())
    }
    
    func handle(error: NetworkError, generator: UINotificationFeedbackGenerator) {
        self.error = error
        showActionSheet(reason: .error)
        generator.notificationOccurred(.error)
    }
    
    func activateDemoMode() {
        do {
            try appManager.demoMode.enable(with: appManager, dataManager: dataManager)
        } catch {
            handle(error: error)
        }
        delegate.didSaveWithSuccess()
        presentationMode.wrappedValue.dismiss()
    }
    
    private enum ConfirmationDialogReason {
        case error, demoMode
    }
}

struct LoginView_Previews: PreviewProvider, LoginViewDelegate {
    func didSaveWithSuccess() {}
    
    static var previews: some View {
        NavigationView {
            LoginView(appManager: .init(), dataManager: MockDataManager(), delegate: self as! LoginViewDelegate)
        }
    }
}

protocol LoginViewDelegate {
    func didSaveWithSuccess()
}
