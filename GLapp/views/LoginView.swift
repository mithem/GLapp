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
    
    @AppStorage(UserDefaultsKeys.userIsTeacher) private var userIsTeacher = false
    
    @State private var error: NetworkError? = nil
    @State private var loading = false
    
    @State private var actionSheetReason = ActionSheetReason.error
    @State private var showingActionSheet = false
    
    @Environment(\.presentationMode) private var presentationMode
    
    @ObservedObject var appManager: AppManager
    @ObservedObject var dataManager: DataManager
    
    let delegate: LoginViewDelegate
    
    func getActionSheet() -> (title: String, action: () -> Button<Text>, actionText: Text, actionCallback: () -> Void, label: () -> Text) {
        switch actionSheetReason {
        case .error:
            return (title: NSLocalizedString("error_occured"), action: {
                if #available(iOS 15, *) {
                    return Button("ok", role: .cancel) {}
                } else {
                    return Button("ok") {}
                }
            }, actionText: Text("ok"), actionCallback: {}, label: {
                Text("error_colon_msg \(error?.localizedMessage ?? "unkown")")
            })
        case .demoMode:
            return (title: NSLocalizedString("user_credentials_empty"), action: {
                Button("enable", action: activateDemoMode)
            }, actionText: Text("enable"), actionCallback: activateDemoMode, label: {
                Text("user_credentials_empty_activate_demo_mode")
            })
        }
    }
    
    var Content: some View {
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
                    Button(action: submitLogin) {
                        HStack(spacing: 10) {
                            Text("send")
                            if loading {
                                ProgressView()
                            }
                        }
                    }
                    .keyboardShortcut(.defaultAction)
                    .disabled(loading)
                    Text("note_all_traffic_encrypted")
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("login")
        }
    }
    
    var body: some View {
        let actionSheet = getActionSheet()
        if #available(iOS 15, *) {
            Content
            .confirmationDialog(actionSheet.title, isPresented: $showingActionSheet, actions: actionSheet.action, message: actionSheet.label)
        } else {
            Content
                .actionSheet(isPresented: $showingActionSheet) {
                    ActionSheet(title: Text(actionSheet.title), message: actionSheet.label(), buttons: [.default(actionSheet.actionText, action: actionSheet.actionCallback)])
                }
        }
    }
    
    func submitLogin() {
        if username.isEmpty && password.isEmpty {
            actionSheetReason = .demoMode
            showingActionSheet = true
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
        actionSheetReason = .error
        showingActionSheet = true
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
    
    private enum ActionSheetReason {
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
