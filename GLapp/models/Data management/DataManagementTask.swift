//
//  DataManagementTask.swift
//  DataManagementTask
//
//  Created by Miguel Themann on 10.10.21.
//

import Foundation

final class DataManagementTask { // if this was a struct, KeyPaths wouldn't be able to mutate it (as of right now i guess)
    @Published var isLoading = false
    @Published var error: GLappError?
    
    init() {
        isLoading = false
        error = nil
    }
    
    func start() {
        isLoading = true
        error = nil
    }
}
