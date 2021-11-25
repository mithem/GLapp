//
//  ClassTestPlan.swift
//  ClassTestPlan
//
//  Created by Miguel Themann on 08.10.21.
//

import Foundation

class ClassTestPlan: ObservableObject, Codable {
    @Published var date: Date
    private var _classTests: [ClassTest]
    @Published var lastFetched: Date
    
    var isEmpty: Bool { classTests.isEmpty }
    
    var classTests: [ClassTest] {
        get {
            _classTests
        }
        set {
            _classTests = newValue.sorted()
        }
    }
    
    init(date: Date, classTests: [ClassTest] = []) {
        self.date = date
        self._classTests = classTests.sorted()
        self.lastFetched = .rightNow
    }
    
    func findIntent(with id: String) -> IntentToHandle? {
        for classTest in classTests {
            if classTest.id == id {
                return .showClassTestPlan
            }
        }
        return nil
    }
    
    func reloadSubjects(with dataManager: DataManager) {
        for classTest in classTests {
            classTest.reloadSubject(with: dataManager)
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(date, forKey: .date)
        try container.encode(classTests, forKey: .classTests)
        try container.encode(lastFetched, forKey: .lastFetched)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        date = try container.decode(Date.self, forKey: .date)
        _classTests = try container.decode([ClassTest].self, forKey: .classTests)
        lastFetched = try container.decode(Date.self, forKey: .lastFetched)
    }
    
    enum CodingKeys: CodingKey {
        case date, classTests, lastFetched
    }
}
