//
//  DataManager.swift
//  DataManager
//
//  Created by Miguel Themann on 08.10.21.
//

import Foundation

class DataManager: ObservableObject {
    @Published var representativePlan: RepresentativePlan?
    @Published var timetable: Timetable?
    @Published var classTestPlan: ClassTestPlan?
    @Published var tasks: Tasks
    
    
    init() {
        representativePlan = nil
        timetable = nil
        classTestPlan = nil
        tasks = Tasks()
    }
    
    func setRepresentativePlan(_ plan: RepresentativePlan?) {
        DispatchQueue.main.async {
            self.representativePlan = plan
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
    
    func startTask(_ task: KeyPath<Tasks, DataManagementTask>) {
        self.tasks[keyPath: task].start()
    }
    
    func setIsLoading(_ isLoading: Bool, for task: KeyPath<Tasks, DataManagementTask>) {
        self.tasks[keyPath: task].isLoading = isLoading
    }
    
    func setError(_ error: GLappError?, for task: KeyPath<Tasks, DataManagementTask>) {
        self.tasks[keyPath: task].error = error
    }
    
    func getRepresentativePlan(completion: @escaping (NetworkResult<String, NetworkError>) -> Void) {
        let req: URLRequest
        do {
            req = URLRequest(url: try getUrl(for: "/XML/vplan.php")!, timeoutInterval: Constants.timeoutInterval)
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
    
    func loadRepresentativePlan() {
        startTask(\.getRepresentativePlan)
        getRepresentativePlan { result in
            switch result {
            case .success:
                fatalError("getRepresentativePlan completed with success but no data.")
            case .successWithData(let plan):
                let result = RepresentativePlanParser.parse(plan: plan)
                switch(result) {
                case .success(let plan):
                    self.setRepresentativePlan(plan)
                case .failure(let error):
                    self.setError(error, for: \.getRepresentativePlan)
                }
            case .failure(let error):
                self.setError(error, for: \.getRepresentativePlan)
            }
            self.setIsLoading(false, for: \.getRepresentativePlan)
        }
    }
    
    func getClassTestPlan(completion: @escaping (NetworkResult<String, NetworkError>) -> Void) {
        let req: URLRequest
        do {
            req = URLRequest(url: try getUrl(for: "/XML/klausur.php")!, timeoutInterval: Constants.timeoutInterval)
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
    
    func loadClassTestPlan() {
        startTask(\.getClassTestPlan)
        getClassTestPlan() { result in
            switch result {
            case .success:
                fatalError("getClassTestPlan completed with success but no data.")
            case .successWithData(let plan):
                let result = ClassTestPlanParser.parse(plan: plan)
                switch result {
                case .success(let plan):
                    self.setClassTestPlan(plan)
                case .failure(let error):
                    self.setError(error, for: \.getClassTestPlan)
                }
            case .failure(let error):
                self.setError(error, for: \.getClassTestPlan)
            }
            self.setIsLoading(false, for: \.getClassTestPlan)
        }
    }
    
    func getTimetable(completion: @escaping (NetworkResult<String, NetworkError>) -> Void) {
        let req: URLRequest
        do {
            req = URLRequest(url: try getUrl(for: "/XML/stupla.php")!, timeoutInterval: Constants.timeoutInterval)
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
    
    func loadTimetable() {
        startTask(\.getTimetable)
        getTimetable() { result in
            switch result {
            case .success:
                fatalError("getTimetable completed with success but no data.")
            case .successWithData(let timetable):
                let result = TimetableParser.parse(timetable: timetable)
                switch result {
                case .success(let timetable):
                    self.setTimetable(timetable)
                case .failure(let error):
                    self.setError(error, for: \.getTimetable)
                }
            case .failure(let error):
                self.setError(error, for: \.getTimetable)
            }
            self.setIsLoading(false, for: \.getTimetable)
        }
    }
    
    func loadData() {
        loadRepresentativePlan()
        loadClassTestPlan()
        loadTimetable()
    }
    
    func reset() {
        DispatchQueue.main.async {
            self.timetable = nil
            self.classTestPlan = nil
            self.representativePlan = nil
            self.tasks = Tasks()
        }
    }
    
    final class Tasks {
        @Published var getRepresentativePlan: DataManagementTask
        @Published var getClassTestPlan: DataManagementTask
        @Published var getTimetable: DataManagementTask
        
        init() {
            getRepresentativePlan = .init()
            getClassTestPlan = .init()
            getTimetable = .init()
        }
    }
}
