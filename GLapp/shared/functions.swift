//
//  functions.swift
//  functions
//
//  Created by Miguel Themann on 01.10.21.
//

import Foundation

func getUrl(for path: String, queryItems: Dictionary<String, String>) -> URL? {
    guard var components = URLComponents(string: Constants.apiHostname + path) else { return nil }
    components.queryItems = []
    for key in queryItems.keys {
        components.queryItems?.append(.init(name: key, value: queryItems[key]))
    }
    return components.url
}

func getUrl(for path: String) throws -> URL? {
    let ud = UserDefaults()
    let isTeacher = ud.bool(forKey: UserDefaultsKeys.userIsTeacher)
    guard let mobileKey = ud.string(forKey: UserDefaultsKeys.mobileKey) else { throw NetworkError.mobileKeyNotConfigured }
    let keyKey: String
    if isTeacher {
        keyKey = "mobilKey_lehrer"
    } else {
        keyKey = "mobilKey"
    }
    return getUrl(for: path, queryItems: [keyKey: mobileKey])
}

func submitLoginAndSaveMobileKey(username: String, password: String, completion: @escaping (NetworkResult<Void, NetworkError>) -> Void) {
    let req = URLRequest(url: getUrl(for: "/XML/anmelden.php", queryItems: ["username": username, "passwort": password])!, timeoutInterval: Constants.timeoutInterval)
    URLSession.shared.dataTask(with: req) { data, response, error in
        if let error = error {
            completion(.failure(.other(error)))
        } else if let data = data {
            let str = String(data: data, encoding: .utf8)
            if let str = str {
                if str.lowercased() == "kein zugriff" {
                    completion(.failure(.notAuthorized))
                } else if str.count == 0 {
                    completion(.failure(.noData))
                } else if str == "0" {
                    completion(.failure(.badRequest))
                } else {
                    UserDefaults().set(str, forKey: UserDefaultsKeys.mobileKey)
                    completion(.success)
                }
            } else {
                completion(.failure(.noData))
            }
        }
    }.resume()
}

func resetLoginInfo() {
    removeMobileKey()
    removeTeacherInformation()
}

func removeMobileKey() {
    UserDefaults().set("", forKey: UserDefaultsKeys.mobileKey)
}

func removeTeacherInformation() {
    UserDefaults().set(false, forKey: UserDefaultsKeys.userIsTeacher)
}

func isLoggedIn() -> Bool {
    let key = UserDefaults().string(forKey: UserDefaultsKeys.mobileKey)
    return key != nil && key != ""
}
