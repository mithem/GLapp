//
//  Subject.swift
//  Subject
//
//  Created by Miguel Themann on 01.10.21.
//

import Foundation
import SwiftUI

final class Subject: ObservableObject, Codable, Hashable {
    @Published var className: String
    @Published var subjectType: String?
    @Published var teacher: String?
    @Published var subjectName: String?
    @Published var color: Color
    
    init(dataManager: DataManager, className: String, subjectType: String? = nil, teacher: String? = nil, subjectName: String? = nil, color: Color? = nil, onMainThread: Bool = false) {
        self.className = className
        self.subjectType = subjectType
        self.teacher = teacher
        self.subjectName = subjectName
        if className.lowercased().starts(with: "nachschrift") { // only used on class test plan
            self.color = .primary
        } else if let color = color {
            self.color = color
        } else {
            self.color = .random
            let color = dataManager.subjectColorMap[className]
            if let color = color {
                self.color = color
            } else {
                self.color = .random
                dataManager.updateSubjectColorMap(className: className, color: self.color, onMainThread: onMainThread)
            }
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(className)
        hasher.combine(subjectType)
        hasher.combine(teacher)
        hasher.combine(subjectName)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(className, forKey: .className)
        try container.encode(subjectType, forKey: .subjectType)
        try container.encode(teacher, forKey: .teacher)
        try container.encode(subjectName, forKey: .subjectName)
        try container.encode(color, forKey: .color)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        className = try container.decode(String.self, forKey: .className)
        subjectType = try container.decode(String.self, forKey: .subjectType)
        teacher = try container.decode(String.self, forKey: .teacher)
        subjectName = try container.decode(String.self, forKey: .subjectName)
        color = try container.decode(Color.self, forKey: .color)
    }
    
    private enum CodingKeys: CodingKey {
        case className, subjectType, teacher, subjectName, color
    }
}
