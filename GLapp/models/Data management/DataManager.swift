//
//  DataManager.swift
//  DataManager
//
//  Created by Miguel Themann on 08.10.21.
//

import Foundation
import Reachability
import SwiftUI

class DataManager: ObservableObject {
    
    typealias SubjectColorMap = [String: CodableColor]
    
    @Published var representativePlan: RepresentativePlan?
    @Published var timetable: Timetable?
    @Published var classTestPlan: ClassTestPlan?
    @Published var tasks: Tasks
    @Published var subjectColorMap: SubjectColorMap
    @Published var demoMode: Bool
    private let reachability: Reachability
    private weak var appManager: AppManager?
    
    init(appManager: AppManager) {
        self.appManager = appManager
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
    
    var subjects: Set<Subject>? {
        timetable?.subjects
    }
    
    func getSubject(subjectName: String, className: String?, onMainThread: Bool = true) -> Subject {
        if let className = className {
            return subjects?.first(where: {$0.className == className}) ?? .init(dataManager: self, className: className, subjectName: subjectName, color: subjectColorMap[className], onMainThread: onMainThread)
        }
        return subjects?.first(where: {$0.subjectName == subjectName}) ?? .init(dataManager: self, className: subjectName, subjectName: subjectName, onMainThread: onMainThread)
    }
    
    func setRepresentativePlan(_ plan: RepresentativePlan?) {
        DispatchQueue.main.async {
            self.representativePlan = plan
            self.indexReprPlan()
        }
        
        if let plan = plan, !UserDefaults.standard.bool(for: \.dontSaveReprPlanUpdateTimestampWhenViewingReprPlan) {
            if let date = plan.date {
                UserDefaults.standard.set(date.timeIntervalSince1970, for: \.lastReprPlanUpdateTimestamp)
            }
        }
    }
    
    func setTimetable(_ timetable: Timetable?) {
        DispatchQueue.main.async {
            self.timetable = timetable
            self.indexTimetable()
        }
    }
    
    func setClassTestPlan(_ plan: ClassTestPlan?) {
        DispatchQueue.main.async {
            self.classTestPlan = plan
            self.indexClassTestPlan()
        }
        
        if let appManager = appManager {
            appManager.classTestReminders.scheduleClassTestRemindersIfAppropriate(with: self)
            appManager.classTestCalendarEvents.createOrModifyClassTestCalendarEventsIfAppropriate(with: appManager, dataManager: self)
        }
    }
    
    func setSubjectColorMap(_ map: SubjectColorMap) {
        DispatchQueue.main.async {
            self.subjectColorMap = map
        }
    }
    
    func indexReprPlan() {
        guard appManager?.spotlightIntegration.isEnabled.unwrapped == true else { return }
        if let plan = representativePlan {
            var toIndex = [RepresentativeLesson]()
            toIndex.append(contentsOf: plan.lessons)
            for day in plan.representativeDays {
                toIndex.append(contentsOf: day.lessons)
            }
            IntentsManager.index(items: toIndex)
        }
    }
    
    func indexTimetable() {
        guard appManager?.spotlightIntegration.isEnabled.unwrapped == true else { return }
        if let timetable = timetable {
            representativePlan?.updateSubjects(with: self) // in order for subjects to reload color after timetable is loaded (from network or disk)
            
            var toIndex = [Lesson]()
            for weekday in timetable.weekdays {
                toIndex.append(contentsOf: weekday.lessons)
            }
            IntentsManager.index(items: toIndex)
        }
    }
    
    func indexClassTestPlan() {
        guard appManager?.spotlightIntegration.isEnabled.unwrapped == true else { return }
        if let classTestPlan = classTestPlan {
            IntentsManager.index(items: classTestPlan.classTests)
        }
    }
    
    func indexContent() {
        indexReprPlan()
        indexTimetable()
        indexClassTestPlan()
    }
    
    func updateSubjectColorMap(className: SubjectColorMap.Key, color: SubjectColorMap.Value, onMainThread: Bool = true) {
        let changeSCM = {
            self.subjectColorMap[className] = color
        }
        if onMainThread {
            DispatchQueue.main.async(execute: changeSCM)
        } else {
            changeSCM()
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
        setContent(data, for: task, with: nil)
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
        } catch {
            print(error)
        }
    }
    
    func clearAllLocalData(withHapticFeedback: Bool = false) {
        let generator: UINotificationFeedbackGenerator? = withHapticFeedback ? .init() : nil
        generator?.prepare()
        
        setRepresentativePlan(nil)
        setClassTestPlan(nil)
        setTimetable(nil)
        setSubjectColorMap(.init())
        
        clearLocalData(for: \.getRepresentativePlan)
        clearLocalData(for: \.getClassTestPlan)
        clearLocalData(for: \.getTimetable)
        clearLocalData(for: \.subjectColorMap)
        
        generator?.notificationOccurred(.success)
    }
    
    func getRepresentativePlan(completion: @escaping (NetworkResult<String, NetworkError>) -> Void) {
        if demoMode {
            return completion(.successWithData(MockData.validReprPlanString))
        }
        let req: URLRequest
        do {
            guard let url = try getUrl(for: "/XML/vplan.php", authenticate: true) else {
                completion(.failure(.invalidURL))
                return
            }
            req = URLRequest(url: url, timeoutInterval: Constants.timeoutInterval)
        } catch {
            if let netError = error as? NetworkError {
                return completion(.failure(netError))
            } else {
                return completion(.failure(.other(error)))
            }

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
    
    func getRepresenativePlanUpdate(useTimestampQuery: Bool = true, completion: @escaping (Result<RepresentativePlan, GLappError>) -> Void) {
        let queryItems: Dictionary<String, String>
        if useTimestampQuery {
            var timestamp: Int? = UserDefaults.standard.integer(for: \.lastReprPlanUpdateTimestamp)
            if timestamp == 0 {
                timestamp = nil
            }
            if let timestamp = timestamp {
                queryItems = ["timestamp": String(timestamp)]
            } else {
                queryItems = [:]
            }
        } else {
            queryItems = [:]
        }
        let req: URLRequest
        do {
            guard let url = try getUrl(for: "/XML/vplan.php", queryItems: queryItems, authenticate: true) else {
                return completion(.failure(.networkError(.invalidURL)))
            }
            req = URLRequest(url: url, timeoutInterval: Constants.timeoutInterval)
        } catch {
            if let netError = error as? NetworkError {
                return completion(.failure(.networkError(netError)))
            } else {
                return completion(.failure(.networkError(.other(error))))
            }
        }
        try? loadLocalData(for: \.getRepresentativePlan) // otherwise just deliver the notification
        URLSession.shared.dataTask(with: req) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(.other(error))))
            } else if let data = data {
                guard let s = String(data: data, encoding: .utf8) else { completion(.failure(.networkError(.invalidResponse))); return }
                if s.count == 0 {
                    completion(.failure(.networkError(.noData)))
                } else if s == "0" {
                    // happens when choosing timestamps the system doesn't like, therefore try again without timestamp
                    self.getRepresenativePlanUpdate(useTimestampQuery: false, completion: completion)
                } else if s.lowercased() == "kein zugriff" {
                    completion(.failure(.networkError(.notAuthorized)))
                } else {
                    let result = RepresentativePlanParser.parse(plan: s, with: self)
                    switch result {
                    case .success(let plan):
                        if let date = plan.date, !UserDefaults.standard.bool(for: \.dontSaveReprPlanUpdateTimestampWhenViewingReprPlan) {
                            UserDefaults.standard.set(date.timeIntervalSince1970, for: \.lastReprPlanUpdateTimestamp)
                        }
                        if !UserDefaults.standard.bool(for: \.reprPlanNotificationsEntireReprPlan) {
                            if let previous = self.representativePlan {
                                completion(.success(plan - previous))
                                return
                            }
                        }
                        completion(.success(plan))
                    case .failure(let error):
                        completion(.failure(.parserError(error)))
                    }
                }
            }
        }.resume()
    }
    
    func getClassTestPlan(completion: @escaping (NetworkResult<String, NetworkError>) -> Void) {
        if demoMode {
            return completion(.successWithData(MockData.validClassTestPlanString))
        }
        let req: URLRequest
        do {
            guard let url = try getUrl(for: "/XML/klausur.php", authenticate: true) else {
                return completion(.failure(.invalidURL))
            }
            req = URLRequest(url: url, timeoutInterval: Constants.timeoutInterval)
        } catch {
            if let netError = error as? NetworkError {
                return completion(.failure(netError))
            } else {
                return completion(.failure(.other(error)))
            }
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
                        if let appManager = self.appManager {
                            DispatchQueue.main.async {
                                self.appManager?.classTestPlan.isSupported = .no
                                try? appManager.classTestPlan.reload(with: appManager, dataManager: self)
                            }
                        }
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
        if demoMode {
            return completion(.successWithData(MockData.validTimetableString))
        }
        let req: URLRequest
        do {
            guard let url = try getUrl(for: "/XML/stupla.php", authenticate: true) else {
                return completion(.failure(.invalidURL))
            }
            req = URLRequest(url: url, timeoutInterval: Constants.timeoutInterval)
        } catch(let error) {
            if let netError = error as? NetworkError {
                return completion(.failure(netError))
            } else {
                return completion(.failure(.other(error)))
            }
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
        startTask(\.getTimetable)
        getTimetable() { result in
            switch result {
            case .success:
                fatalError("getTimetable completed with success but no data.")
            case .successWithData(let timetable):
                TimetableParser.parse(timetable: timetable, with: self) { result in
                    switch result {
                    case .success(let timetable):
                        self.setContent(timetable, for: \.getTimetable, with: withHapticFeedback ? generator : nil)
                        self.saveLocalData(timetable, for: \.getTimetable)
                        self.saveSubjectColorMap()
                        DispatchQueue.main.async { // some methods above (like setContent) run there, so timetable otherwise may not already be accessible
                            self.classTestPlan?.reloadSubjects(with: self)
                        }
                    case .failure(let error):
                        self.setError(.parserError(error), for: \.getTimetable, with: withHapticFeedback ? generator : nil)
                    }
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
    
    func loadData(withHapticFeedBack: Bool = false) {
        let generator: UINotificationFeedbackGenerator? = withHapticFeedBack ? .init() : nil
        generator?.prepare()
        reloadDemoMode()
        loadRepresentativePlan()
        loadClassTestPlan()
        loadTimetable()
        loadSubjectColorMap()
        if let generator = generator {
            giveCorrectTapticFeedback(on: generator)
        }
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
    
    func regenerateColors() {
        setTimetable(nil)
        resetSubjectColorMap()
        clearLocalData(for: \.getTimetable)
        loadTimetable(withHapticFeedback: true)
    }
    
    func reloadDemoMode() {
        DispatchQueue.main.async {
            self.demoMode = UserDefaults.standard.bool(for: \.demoMode)
        }
    }
    
    func findIntent(with id: String) -> IntentToHandle? {
        if let intent = representativePlan?.findIntent(with: id) {
            return intent
        }
        if let intent = classTestPlan?.findIntent(with: id) {
            return intent
        }
        if let intent = timetable?.findIntent(with: id) {
            return intent
        }
        return nil
    }
    
    final class Tasks: ObservableObject {
        @Published var getRepresentativePlan: DataManagementTask<RepresentativePlan>
        @Published var getClassTestPlan: DataManagementTask<ClassTestPlan>
        @Published var getTimetable: DataManagementTask<Timetable>
        @Published var subjectColorMap: DataManagementTask<SubjectColorMap>
        
        init() {
            let cacheDir = try? FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let appCacheDir = cacheDir?.appendingPathComponent(Constants.Identifiers.appId)
            getRepresentativePlan = .init(localDataURL: appCacheDir?.appendingPathComponent("representativePlan.json"))
            getClassTestPlan = .init(localDataURL: appCacheDir?.appendingPathComponent("classTestPlan.json"))
            getTimetable = .init(localDataURL: appCacheDir?.appendingPathComponent("timetable.json"))
            subjectColorMap = .init(localDataURL: appCacheDir?.appendingPathComponent("subjectColorMap.json"))
        }
    }
    
    deinit {
        saveLocalData()
        reachability.stopNotifier()
    }
}
