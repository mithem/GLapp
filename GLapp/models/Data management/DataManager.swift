//
//  DataManager.swift
//  DataManager
//
//  Created by Miguel Themann on 08.10.21.
//

import Foundation
import Reachability
import SwiftUI

typealias SubjectColorMap = [String: CodableColor]

class DataManager: ObservableObject {
    @Published var representativePlan: RepresentativePlan?
    @Published var timetable: Timetable?
    @Published var classTestPlan: ClassTestPlan?
    @Published var tasks: Tasks
    @Published var subjectColorMap: SubjectColorMap
    @Published var demoMode: Bool
    private let reachability: Reachability
    
    init() {
        representativePlan = nil
        timetable = nil
        classTestPlan = nil
        tasks = Tasks()
        subjectColorMap = .init()
        demoMode = false
        reachability = try! .init()
        reachability.whenReachable = { reachability in
            if reachability.connection != .unavailable {
                self.loadData()
            }
        }
        try? reachability.startNotifier()
        do {
            try loadLocalData(for: \.getRepresentativePlan)
        } catch {}
        do {
            try loadLocalData(for: \.getClassTestPlan)
        } catch {}
        do {
            try loadLocalData(for: \.getTimetable)
        } catch {}
    }
    
    func setRepresentativePlan(_ plan: RepresentativePlan?) {
        DispatchQueue.main.async {
            self.representativePlan = plan
        }
        
        if let plan = plan {
            UserDefaults.standard.set(plan.date.timeIntervalSince1970, forKey: UserDefaultsKeys.lastReprPlanUpdateTimestamp)
        }
    }
    
    func setTimetable(_ timetable: Timetable?) {
        DispatchQueue.main.async {
            self.timetable = timetable
        }
    }
    
    func setClassTestPlan(_ plan: ClassTestPlan?) {
        DispatchQueue.main.async {
            self.classTestPlan = plan
        }
    }
    
    func setSubjectColorMap(_ map: SubjectColorMap) {
        DispatchQueue.main.async {
            self.subjectColorMap = map
            self.timetable?.reloadSubjects(with: self)
        }
    }
    
    func updateSubjectColorMap(className: String, color: CodableColor) {
        DispatchQueue.main.async {
            self.subjectColorMap[className] = color
            self.timetable?.reloadSubjects(with: self)
        }
    }
    
    func startTask<ContentType>(_ task: KeyPath<Tasks, DataManagementTask<ContentType>>) {
        self.tasks[keyPath: task].start()
    }
    
    func setIsLoading<ContentType>(_ isLoading: Bool, for task: KeyPath<Tasks, DataManagementTask<ContentType>>) {
        DispatchQueue.main.async {
            self.tasks[keyPath: task].isLoading = isLoading
        }
    }
    
    func setError<ContentType>(_ error: GLappError?, for task: KeyPath<Tasks, DataManagementTask<ContentType>>, with generator: UINotificationFeedbackGenerator? = nil) {
        DispatchQueue.main.async {
            self.tasks[keyPath: task].error = error
            if error != nil, let generator = generator {
                generator.notificationOccurred(.error)
            }
        }
    }
    
    func getLocalData<ContentType>(for task: KeyPath<Tasks, DataManagementTask<ContentType>>) throws -> ContentType {
        guard let url = self.tasks[keyPath: task].localDataURL else { throw GLappError.fsError(.noURL) }
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .useDefaultKeys
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(ContentType.self, from: data)
    }
    
    func loadLocalData<ContentType>(for task: KeyPath<Tasks, DataManagementTask<ContentType>>) throws {
        // that's elegant! (esp. as ContentType is inferred to adhere to Codable)
        let data = try getLocalData(for: task)
        setContent(data, for: task)
    }
    
    private func setContent<ContentType>(_ content: ContentType, for task: KeyPath<Tasks, DataManagementTask<ContentType>>, with generator: UINotificationFeedbackGenerator? = nil) {
        // can safely coerce types (without overriding data with nonexisting cache) as this will only be called when loadCache can decode content successfully
        // not so elegant anymore (safe coercion)
        switch task {
        case \.getRepresentativePlan:
            setRepresentativePlan(content as? RepresentativePlan)
        case \.getClassTestPlan:
            setClassTestPlan(content as? ClassTestPlan)
        case \.getTimetable:
            setTimetable(content as? Timetable)
        case \.subjectColorMap:
            setSubjectColorMap(content as? SubjectColorMap ?? .init())
        default:
            fatalError("setContent invoked for unsupported task '\(task)'.")
        }
        generator?.notificationOccurred(.success)
    }
    
    func saveLocalData<ContentType>(_ content: ContentType, for task: KeyPath<Tasks, DataManagementTask<ContentType>>) {
        guard let url = self.tasks[keyPath: task].localDataURL else { return }
        do {
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .useDefaultKeys
            encoder.dateEncodingStrategy = .iso8601
            let data = try encoder.encode(content)
            try data.write(to: url)
        } catch {
            print(error)
        }
    }
    
    func clearLocalData<ContentType>(for task: KeyPath<Tasks, DataManagementTask<ContentType>>) {
        guard let url = self.tasks[keyPath: task].localDataURL else { return }
        do {
            try FileManager.default.removeItem(at: url)
        } catch {}
    }
    
    func clearAllLocalData() {
        setRepresentativePlan(nil)
        setClassTestPlan(nil)
        setTimetable(nil)
        
        clearLocalData(for: \.getRepresentativePlan)
        clearLocalData(for: \.getClassTestPlan)
        clearLocalData(for: \.getTimetable)
    }
    
    func getRepresentativePlan(completion: @escaping (NetworkResult<String, NetworkError>) -> Void) {
        let req: URLRequest
        do {
            req = URLRequest(url: try getUrl(for: "/XML/vplan.php", authenticate: true)!, timeoutInterval: Constants.timeoutInterval)
        } catch {
            if let netError = error as? NetworkError {
                completion(.failure(netError))
            } else {
                completion(.failure(.other(error)))
            }
            return

        }
        URLSession.shared.dataTask(with: req) { data, response, error in
            if let error = error {
                completion(.failure(.other(error)))
            } else if let data = data {
                guard let str = String(data: data, encoding: .utf8) else { completion(.failure(.invalidResponse)); return }
                if str.count == 0 {
                    completion(.failure(.noData))
                } else if str == "0" {
                    completion(.failure(.badRequest))
                } else if str.lowercased() == "kein zugriff" {
                    completion(.failure(.notAuthorized))
                } else {
                    completion(.successWithData(str))
                }
            }
        }.resume()
    }
    
    func loadRepresentativePlan(withHapticFeedback: Bool = false) {
        let generator = UINotificationFeedbackGenerator()
        if withHapticFeedback {
            generator.prepare()
        }
        if demoMode {
            let plan = MockData.representativePlan
            setContent(plan, for: \.getRepresentativePlan, with: withHapticFeedback ? generator : nil)
            setError(nil, for: \.getRepresentativePlan)
            saveLocalData()
            return
        }
        startTask(\.getRepresentativePlan)
        getRepresentativePlan { result in
            switch result {
            case .success:
                fatalError("getRepresentativePlan completed with success but no data.")
            case .successWithData(let plan):
                let result = RepresentativePlanParser.parse(plan: plan, with: self)
                switch(result) {
                case .success(let plan):
                    self.setContent(plan, for: \.getRepresentativePlan, with: withHapticFeedback ? generator : nil)
                    self.saveLocalData(plan, for: \.getRepresentativePlan)
                case .failure(let error):
                    self.setError(.parserError(error), for: \.getRepresentativePlan, with: withHapticFeedback ? generator : nil)
                }
            case .failure(let error):
                self.setError(.networkError(error), for: \.getRepresentativePlan, with: withHapticFeedback ? generator : nil)
            }
            self.setIsLoading(false, for: \.getRepresentativePlan)
        }
    }
    
    func getRepresenativePlanUpdate(completion: @escaping (Result<RepresentativePlan, GLappError>) -> Void) {
        let queryItems: Dictionary<String, String>
        var timestamp: Int? = UserDefaults.standard.integer(forKey: UserDefaultsKeys.lastReprPlanUpdateTimestamp)
        if timestamp == 0 {
            timestamp = nil
        }
        if let timestamp = timestamp {
            queryItems = ["timestamp": String(timestamp)]
        } else {
            queryItems = [:]
        }
        guard let url = try? getUrl(for: "/XML/vplan.php", queryItems: queryItems, authenticate: true) else { fatalError("Invalid URL for reprPlan update.") }
        let req = URLRequest(url: url, timeoutInterval: Constants.timeoutInterval)
        URLSession.shared.dataTask(with: req) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(.other(error))))
            } else if let data = data {
                guard let s = String(data: data, encoding: .utf8) else { completion(.failure(.networkError(.invalidResponse))); return }
                if s.count == 0 {
                    completion(.failure(.networkError(.noData)))
                } else if s == "0" {
                    completion(.failure(.networkError(.badRequest)))
                } else if s.lowercased() == "kein zugriff" {
                    completion(.failure(.networkError(.notAuthorized)))
                } else {
                    let result = RepresentativePlanParser.parse(plan: s, with: self)
                    switch result {
                    case .success(let plan):
                        UserDefaults.standard.set(plan.date.timeIntervalSince1970, forKey: UserDefaultsKeys.lastReprPlanUpdateTimestamp)
                        completion(.success(plan))
                    case .failure(let error):
                        completion(.failure(.parserError(error)))
                    }
                }
            }
        }.resume()
    }
    
    func getClassTestPlan(completion: @escaping (NetworkResult<String, NetworkError>) -> Void) {
        let req: URLRequest
        do {
            req = URLRequest(url: try getUrl(for: "/XML/klausur.php", authenticate: true)!, timeoutInterval: Constants.timeoutInterval)
        } catch(let error) {
            if let netError = error as? NetworkError {
                completion(.failure(netError))
            } else {
                completion(.failure(.other(error)))
            }
            return
        }
        URLSession.shared.dataTask(with: req) { data, response, error in
            if let error = error {
                completion(.failure(.other(error)))
            } else if let data = data {
                guard let str = String(data: data, encoding: .utf8) else { completion(.failure(.invalidResponse)); return }
                let lower = str.lowercased()
                if str.count == 0 {
                    completion(.failure(.noData))
                } else if str == "0" {
                    completion(.failure(.badRequest))
                } else if lower == "kein zugriff" || lower == "unbekannter benutzer" {
                    completion(.failure(.notAuthorized))
                } else {
                    completion(.successWithData(str))
                }
            }
        }.resume()
    }
    
    func loadClassTestPlan(withHapticFeedback: Bool = false) {
        let generator = UINotificationFeedbackGenerator()
        if withHapticFeedback {
            generator.prepare()
        }
        if demoMode {
            let plan = MockData.classTestPlan
            setContent(plan, for: \.getClassTestPlan, with: withHapticFeedback ? generator : nil)
            setError(nil, for: \.getClassTestPlan)
            saveLocalData()
            return
        }
        startTask(\.getClassTestPlan)
        getClassTestPlan() { result in
            switch result {
            case .success:
                fatalError("getClassTestPlan completed with success but no data.")
            case .successWithData(let plan):
                let result = ClassTestPlanParser.parse(plan: plan, with: self)
                switch result {
                case .success(let plan):
                    self.setContent(plan, for: \.getClassTestPlan, with: withHapticFeedback ? generator : nil)
                    self.saveLocalData(plan, for: \.getClassTestPlan)
                case .failure(let error):
                    if error == .noTimestamp { // Unter-/ Mittelstufe
                        self.setClassTestPlan(nil)
                        self.setError(.classTestPlanNotSupported, for: \.getClassTestPlan, with: withHapticFeedback ? generator : nil)
                    } else {
                        self.setError(.parserError(error), for: \.getClassTestPlan)
                    }
                }
            case .failure(let error):
                self.setError(.networkError(error), for: \.getClassTestPlan, with: withHapticFeedback ? generator : nil)
            }
            self.setIsLoading(false, for: \.getClassTestPlan)
        }
    }
    
    func getTimetable(completion: @escaping (NetworkResult<String, NetworkError>) -> Void) {
        let req: URLRequest
        do {
            req = URLRequest(url: try getUrl(for: "/XML/stupla.php", authenticate: true)!, timeoutInterval: Constants.timeoutInterval)
        } catch(let error) {
            if let netError = error as? NetworkError {
                completion(.failure(netError))
            } else {
                completion(.failure(.other(error)))
            }
            return
        }
        URLSession.shared.dataTask(with: req) { data, response, error in
            if let error = error {
                completion(.failure(.other(error)))
            } else if let data = data {
                guard let str = String(data: data, encoding: .utf8) else { completion(.failure(.invalidResponse)); return }
                if str.count == 0 {
                    completion(.failure(.noData))
                } else if str == "0" {
                    completion(.failure(.badRequest))
                } else if str.lowercased() == "kein zugriff" {
                    completion(.failure(.notAuthorized))
                } else {
                    completion(.successWithData(str))
                }
            }
        }.resume()
    }
    
    func loadTimetable(withHapticFeedback: Bool = false) {
        let generator = UINotificationFeedbackGenerator()
        if withHapticFeedback {
            generator.prepare()
        }
        if demoMode {
            let timetable = MockData.timetable
            setContent(timetable, for: \.getTimetable, with: withHapticFeedback ? generator : nil)
            setError(nil, for: \.getTimetable)
            saveLocalData()
            return
        }
        startTask(\.getTimetable)
        getTimetable() { result in
            switch result {
            case .success:
                fatalError("getTimetable completed with success but no data.")
            case .successWithData(let timetable):
                let result = TimetableParser.parse(timetable: timetable, with: self)
                switch result {
                case .success(let timetable):
                    self.setContent(timetable, for: \.getTimetable, with: withHapticFeedback ? generator : nil)
                    self.saveLocalData(timetable, for: \.getTimetable)
                case .failure(let error):
                    self.setError(.parserError(error), for: \.getTimetable, with: withHapticFeedback ? generator : nil)
                }
            case .failure(let error):
                self.setError(.networkError(error), for: \.getTimetable, with: withHapticFeedback ? generator : nil)
            }
            self.setIsLoading(false, for: \.getTimetable)
        }
    }
    
    func loadSubjectColorMap() {
        guard let map = try? getLocalData(for: \.subjectColorMap) else { return }
        setContent(map, for: \.subjectColorMap)
    }
    
    func saveSubjectColorMap() {
        saveLocalData(subjectColorMap, for: \.subjectColorMap)
    }
    
    /// Save local data that's not intended for caching (as that is written to disk when receiving the data from the network)
    func saveLocalData() {
        saveSubjectColorMap()
    }
    
    func loadData() {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        loadRepresentativePlan()
        loadClassTestPlan()
        loadTimetable()
        loadSubjectColorMap()
        reloadDemoMode()
        giveCorrectTapticFeedback(on: generator)
    }
    
    func giveCorrectTapticFeedback(on generator: UINotificationFeedbackGenerator) {
        if tasks.getRepresentativePlan.error != nil || tasks.getTimetable.error != nil || tasks.getClassTestPlan.error != nil {
            generator.notificationOccurred(.error)
        } else {
            generator.notificationOccurred(.success)
        }
    }
    
    func reset() {
        clearAllLocalData()
        resetSubjectColorMap()
        DispatchQueue.main.async {
            self.tasks = Tasks()
            self.demoMode = false
        }
    }
    
    func resetSubjectColorMap() {
        DispatchQueue.main.async {
            self.subjectColorMap.removeAll()
            self.clearLocalData(for: \.subjectColorMap)
        }
    }
    
    func reloadDemoMode() {
        DispatchQueue.main.async {
            self.demoMode = UserDefaults.standard.bool(forKey: UserDefaultsKeys.demoMode)
        }
    }
    
    final class Tasks: ObservableObject {
        @Published var getRepresentativePlan: DataManagementTask<RepresentativePlan>
        @Published var getClassTestPlan: DataManagementTask<ClassTestPlan>
        @Published var getTimetable: DataManagementTask<Timetable>
        @Published var subjectColorMap: DataManagementTask<SubjectColorMap>
        
        init() {
            let cacheDir = try? FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let appCacheDir = URL(string: Constants.Identifiers.appId, relativeTo: cacheDir)
            getRepresentativePlan = .init(localDataURL: URL(string: "representativePlan.json", relativeTo: appCacheDir))
            getClassTestPlan = .init(localDataURL: URL(string: "classTestPlan.json", relativeTo: appCacheDir))
            getTimetable = .init(localDataURL: URL(string: "timetable.json", relativeTo: appCacheDir))
            subjectColorMap = .init(localDataURL: URL(string: "subjectColorMap.json", relativeTo: appCacheDir))
        }
    }
    
    deinit {
        saveLocalData()
    }
}
