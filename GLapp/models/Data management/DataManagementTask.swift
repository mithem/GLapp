//
//  DataManagementTask.swift
//  DataManagementTask
//
//  Created by Miguel Themann on 10.10.21.
//

import Foundation

class DataManagementTask<ContentType>: ObservableObject where ContentType: Codable { // if this was a struct, KeyPaths wouldn't be able to mutate it (as of right now i guess)
    @Published var isLoading = false
    @Published var error: GLappError?
    let localDataURL: URL?
    
    init(localDataURL: URL? = nil) {
        isLoading = false
        error = nil
        self.localDataURL = localDataURL
    }
    
    func start() {
        DispatchQueue.main.async {
            self.isLoading = true
            self.error = nil
        }
    }
}
