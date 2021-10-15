//
//  SettingsView.swift
//  SettingsView
//
//  Created by Miguel Themann on 08.10.21.
//

import SwiftUI

struct SettingsView: View {
    @State private var showingLoginView = false
    @State private var showingFunctionalityCheckView = false
    @EnvironmentObject var dataManager: DataManager
    var InnerView: some View {
        Form {
            Group {
                if #available(iOS 15, *) {
                    Button("reset_all_data", role: .destructive, action: resetAllData)
                } else {
                    Button("reset_all_data", action: resetAllData)
                        .foregroundColor(.red)
                }
            }
            .sheet(isPresented: $showingLoginView) {
                LoginView(delegate: self)
            }
            Button("check_for_functionality") {
                showingFunctionalityCheckView = true
            }
            .sheet(isPresented: $showingFunctionalityCheckView) {
                FunctionalityCheckView()
            }
        }
        .navigationTitle("settings")
    }
    
    var body: some View {
        if UIDevice.current.userInterfaceIdiom == .pad {
            InnerView
        } else if UIDevice.current.userInterfaceIdiom == .phone {
            NavigationView {
                InnerView
            }
        }
    }
    
    func resetAllData() {
        dataManager.reset()
        resetLoginInfo()
        showingLoginView = true
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
