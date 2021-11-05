//
//  EventManager.swift
//  GLapp
//
//  Created by Miguel Themann on 03.11.21.
//

import EventKit

class EventManager {
    class var `default`: EventManager { .init() }
    private var store: EKEventStore
    private var eventIds: [String]
    private var eventIdsURL: URL?
    
    func requestAuthorization(completion: @escaping (Result<Bool, Error>) -> Void) {
        store.requestAccess(to: .event) { granted, error in
            if let error = error {
                completion(.failure(.other(error)))
            } else {
                completion(.success(granted))
            }
        }
    }
    
    func getAuthorizatonStatus() -> EKAuthorizationStatus {
        EKEventStore.authorizationStatus(for: .event)
    }
    
    func createClassTestEvents(from classTests: [ClassTest], completion: @escaping (Result<Bool, Error>) -> Void) {
        requestAuthorization { result in
            switch result {
            case .success(let granted):
                if !granted {
                    completion(.failure(.notAuthorized))
                    return
                }
                for classTest in classTests {
                    let start = classTest.classTestDate - 1
                    let end = classTest.classTestDate + 60 * 60 * 24 + 1 // just to be safe
                    let predicate = self.store.predicateForEvents(withStart: start, end: end, calendars: nil)
                    let events = self.store.events(matching: predicate)
                    if let event = events.first(where: {$0.title == classTest.subject.className}) {
                        if let start = classTest.startDate, let end = classTest.endDate {
                            event.startDate = start
                            event.endDate = end
                            event.isAllDay = false
                            try? self.store.save(event, span: .thisEvent)
                        }
                    } else {
                        let event = EKEvent(eventStore: self.store)
                        guard let cal = self.store.defaultCalendarForNewEvents else { continue }
                        event.calendar = cal
                        event.title = classTest.subject.className
                        if let start = classTest.startDate, let end = classTest.endDate {
                            event.startDate = start
                            event.endDate = end
                        } else {
                            event.startDate = classTest.classTestDate
                            event.endDate = classTest.classTestDate
                            event.isAllDay = true
                        }
                        if let identifier = event.eventIdentifier {
                            self.eventIds.append(identifier)
                        }
                        try? self.store.save(event, span: .thisEvent)
                    }
                }
                try? self.store.commit()
                completion(.success(true))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func loadEventIds() throws {
        guard let eventIdsURL = eventIdsURL else { return }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .useDefaultKeys
        eventIds = try decoder.decode([String].self, from: try Data(contentsOf: eventIdsURL))
    }
    
    private func saveEventIds() throws {
        guard let eventIdsURL = eventIdsURL else { return }
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .useDefaultKeys
        try encoder.encode(eventIds).write(to: eventIdsURL)
    }
    
    required init() {
        store = .init()
        eventIds = .init()
        
        let appDirRoot = try? FileManager.default.url(for: .applicationDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let appDir = URL(string: Constants.Identifiers.appId, relativeTo: appDirRoot)
        eventIdsURL = appDir
        
        try? loadEventIds()
    }
    
    deinit {
        try? saveEventIds()
    }
    
    enum Error: Swift.Error {
        case other(_ error: Swift.Error)
        case notAuthorized
    }
}
