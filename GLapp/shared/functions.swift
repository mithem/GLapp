//
//  functions.swift
//  functions
//
//  Created by Miguel Themann on 01.10.21.
//

import Foundation

func getUrl(for path: String, queryItems: Dictionary<String, String> = [:], authenticate: Bool = false) throws -> URL? {
    guard var components = URLComponents(string: Constants.apiHostname + path) else { return nil }
    components.queryItems = []
    if authenticate {
        let isTeacher = UserDefaults.standard.bool(forKey: UserDefaultsKeys.userIsTeacher)
        guard let mobileKey = UserDefaults.standard.string(forKey: UserDefaultsKeys.mobileKey) else { throw NetworkError.mobileKeyNotConfigured }
        let keyKey: String
        if isTeacher {
            keyKey = "mobilKey_lehrer"
        } else {
            keyKey = "mobilKey"
        }
        components.queryItems?.append(.init(name: keyKey, value: mobileKey))
    }
    for key in queryItems.keys {
        components.queryItems?.append(.init(name: key, value: queryItems[key]))
    }
    return components.url
}

func submitLoginAndSaveMobileKey(username: String, password: String, completion: @escaping (NetworkResult<Void, NetworkError>) -> Void) {
    guard let url = try? getUrl(for: "/XML/anmelden.php", queryItems: ["username": username, "passwort": password])! else { fatalError("Invalid URL for logging in.") }
    let req = URLRequest(url: url, timeoutInterval: Constants.timeoutInterval)
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
                    completion(.failure(.notAuthorized))
                } else {
                    UserDefaults.standard.set(str, forKey: UserDefaultsKeys.mobileKey)
                    completion(.success)
                }
            } else {
                completion(.failure(.noData))
            }
        }
    }.resume()
}

@available(iOS 15, *)
func submitLoginAndSaveMobileKey(username: String, password: String) async throws {
    do {
        let url = try getUrl(for: "/XML/anmelden.php", queryItems: ["username": username, "passwort": password])!
        let req = URLRequest(url: url, timeoutInterval: Constants.timeoutInterval)
        let (data, _) = try await URLSession.shared.data(for: req)
        let str = String(data: data, encoding: .utf8)
        if let str = str {
            if str.lowercased() == "kein zugriff" || str == "0" {
                throw NetworkError.notAuthorized
            } else if str.count == 0 {
                throw NetworkError.noData
            } else {
                UserDefaults.standard.set(str, forKey: UserDefaultsKeys.mobileKey)
            }
        } else {
            throw NetworkError.noData
        }
    } catch {
        if let error = error as? NetworkError {
            throw error
        } else {
            throw NetworkError.other(error)
        }
    }
}

func resetLoginInfo() {
    removeMobileKey()
    removeTeacherInformation()
}

func removeMobileKey() {
    UserDefaults.standard.set("", forKey: UserDefaultsKeys.mobileKey)
}

func removeTeacherInformation() {
    UserDefaults.standard.set(false, forKey: UserDefaultsKeys.userIsTeacher)
}

func isLoggedIn() -> Bool {
    let key = UserDefaults.standard.string(forKey: UserDefaultsKeys.mobileKey)
    return key != nil && key != ""
}

func resetOnboarding() {
    UserDefaults.standard.set(0, forKey: UserDefaultsKeys.launchCount)
}

func NSLocalizedString(_ key: String) -> String {
    NSLocalizedString(key, comment: key)
}
