//
//  EventManager.swift
//  GLapp
//
//  Created by Miguel Themann on 03.11.21.
//

import EventKit

final class EventManager {
    class var `default`: EventManager { .init() }
    private var store: EKEventStore
    private var eventIds: [String]
    private static let eventIdsURL = Constants.appDataDir?.appendingPathComponent("eventIds.json")
    
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
    
    func removeAllCreatedEvents(subjects: [Subject]) throws {
        let classNames = subjects.map { $0.className }
        let yTimeInterval: TimeInterval = 60 * 60 * 24 * 365
        let start = Date.rightNow.addingTimeInterval(-yTimeInterval)
        let end = Date.rightNow.addingTimeInterval(yTimeInterval)
        let predicate = self.store.predicateForEvents(withStart: start, end: end, calendars: nil)
        let events = store.events(matching: predicate)
        for event in events {
            if eventIds.contains(event.eventIdentifier) || classNames.contains(event.title) {
                try store.remove(event, span: .thisEvent)
            } else if event.title.isRewrite {
                try store.remove(event, span: .thisEvent)
            }
        }
    }
    
    func createClassTestEvents(from classTests: [ClassTest], completion: @escaping (Result<Bool, Error>) -> Void) {
        requestAuthorization { result in
            switch result {
            case .success(let granted):
                if !granted {
                    completion(.failure(.notAuthorized))
                    return
                }
                try? self.removeAllCreatedEvents(subjects: classTests.map { $0.subject })
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
        guard let eventIdsURL = Self.eventIdsURL else { return }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .useDefaultKeys
        eventIds = try decoder.decode([String].self, from: try Data(contentsOf: eventIdsURL))
    }
    
    private func saveEventIds() throws {
        guard let eventIdsURL = Self.eventIdsURL else { return }
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .useDefaultKeys
        try encoder.encode(eventIds).write(to: eventIdsURL)
    }
    
    required init() {
        store = .init()
        eventIds = .init()
        
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
