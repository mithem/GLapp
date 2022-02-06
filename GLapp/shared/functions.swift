//
//  functions.swift
//  functions
//
//  Created by Miguel Themann on 01.10.21.
//

import Foundation
import UIKit

func getUrl(for path: String, queryItems: Dictionary<String, String> = [:], authenticate: Bool = false) throws -> URL? {
    guard var components = URLComponents(string: Constants.apiHostname + path) else { return nil }
    components.queryItems = []
    if authenticate {
        let isTeacher = UserDefaults.standard.bool(for: \.userIsTeacher)
        guard let mobileKey = UserDefaults.standard.string(for: \.mobileKey) else { throw NetworkError.mobileKeyNotConfigured }
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
                    UserDefaults.standard.set(str, for: \.mobileKey)
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
    UserDefaults.standard.set("", for: \.mobileKey)
}

func removeTeacherInformation() {
    UserDefaults.standard.set(false, for: \.userIsTeacher)
}

func isLoggedIn() -> Bool {
    let key = UserDefaults.standard.string(for: \.mobileKey)
    return key != nil && key != ""
}

func resetOnboarding(withHapticFeedback: Bool = false) {
    let generator: UINotificationFeedbackGenerator? = withHapticFeedback ? .init() : nil
    generator?.prepare()
    UserDefaults.standard.set(0, for: \.launchCount)
    UserDefaults.standard.set(false, for: \.didShowFunctionalityCheck)
    UserDefaults.standard.set(false, for: \.showVersionUpdatePromoView)
    IntentsManager.reset()
    removeLastReprPlanUpdateTimestamp()
    generator?.notificationOccurred(.success)
}

func removeLastReprPlanUpdateTimestamp() {
    UserDefaults.standard.set(0.0, for: \.lastReprPlanUpdateTimestamp)
}

func NSLocalizedString(_ key: String) -> String {
    NSLocalizedString(key, comment: key)
}

func createAppDataDirIfAppropriate() throws {
    if let url = Constants.appDataDir {
        var isDir: ObjCBool = false
        let exists = FileManager.default.fileExists(atPath: url.path, isDirectory: &isDir)
        if exists && isDir.boolValue || !exists {
            if !isDir.boolValue {
                try FileManager.default.removeItem(at: url)
            }
            try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
        }
    }
}

func resetAllDataOn(dataManager: DataManager? = nil, appManager: AppManager? = nil) {
    dataManager?.reset()
    NotificationManager.default.reset()
    IntentsManager.reset()
    resetLoginInfo()
    resetOnboarding()
    UserDefaults.standard.set(0, for: \.launchCount)
    UserDefaults.standard.set(date: nil, for: \.lastVersionUpdateDate)
    // Don't reset last requested reviews as that might shoot itself in the foot (e.g. when resetting accidentially I guess)
    if let dataManager = dataManager {
        appManager?.reload(with: dataManager)
    }
}

#if DEBUG
/// In addition to the normal `resetAllDataOn(_:_:)`, reset stuff that's just supposed to be reset be a dev (e.g. last requested review)
func devReset(appManager: AppManager? = nil, dataManager: DataManager? = nil) {
    resetAllDataOn(dataManager: dataManager, appManager: appManager)
    UserDefaults.standard.set(date: nil, for: \.lastReviewRequested)
}
#endif

func isAppLocked() -> Bool {
    UserDefaults.standard.bool(for: \.requireAuthentication) && !UserDefaults.standard.bool(for: \.didUnlockInCurrentSession)
}

func lockApp() {
    UserDefaults.standard.set(false, for: \.didUnlockInCurrentSession)
}
