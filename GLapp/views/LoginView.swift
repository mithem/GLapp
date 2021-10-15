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
    
    @State private var showingErrorActionSheet = false
    
    @Environment(\.presentationMode) private var presentationMode
    
    let delegate: LoginViewDelegate
    
    var Content: some View {
        NavigationView {
            VStack {
                Form {
                    TextField(.init("username"), text: $username)
                        .disableAutocorrection(true)
                    SecureField(.init("password"), text: $password)
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
                    .disabled(loading)
                    Text("note_all_traffic_encrypted")
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("login")
        }
    }
    
    var body: some View {
        if #available(iOS 15, *) {
                Content
                    .confirmationDialog("error_occured", isPresented: $showingErrorActionSheet, titleVisibility: .visible, actions: {
                    Button("ok", role: .cancel) {}}) {
                        Text("error_colon_msg \(error?.localizedMessage ?? "unkown")")
                    }
        } else {
            Content
                .actionSheet(isPresented: $showingErrorActionSheet) {
                    return ActionSheet(title: Text("error_occured"), message: Text("error_colon_msg \(error?.localizedMessage ?? "unkown")"), buttons: [.default(Text("ok"))])
                }
                
        }
    }
    
    func submitLogin() {
        loading = true
        submitLoginAndSaveMobileKey(username: username, password: password) { result in
            loading = false
            switch (result) {
            case .success:
                delegate.didSaveWithSuccess()
                error = nil
                presentationMode.wrappedValue.dismiss()
            case .successWithData(_):
                fatalError("error_submitting_login_information_returning_data")
            case .failure(let error):
                self.error = error
                self.showingErrorActionSheet = true
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider, LoginViewDelegate {
    func didSaveWithSuccess() {}
    
    static var previews: some View {
        NavigationView {
            LoginView(delegate: self as! LoginViewDelegate)
        }
    }
}

protocol LoginViewDelegate {
    func didSaveWithSuccess()
}
