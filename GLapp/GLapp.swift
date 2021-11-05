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
    var body: some Scene {
        GLappScene()
    }
}
