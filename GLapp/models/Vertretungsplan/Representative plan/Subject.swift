//
//  Subject.swift
//  Subject
//
//  Created by Miguel Themann on 01.10.21.
//

import Foundation
import SwiftUI

final class Subject: ObservableObject, Codable {
    @Published var className: String
    @Published var subjectType: String?
    @Published var teacher: String?
    @Published var subjectName: String?
    @Published var color: CodableColor
    
    func getColor() -> CodableColor {
        color
    }
    
    func setColor(_ color: CodableColor, with dataManager: DataManager) {
        self.color = color
        dataManager.updateSubjectColorMap(className: className, color: color)
    }
    
    func reload(with dataManager: DataManager) {
        self.color = dataManager.subjectColorMap[className] ?? .random
    }
    
    init(dataManager: DataManager, className: String, subjectType: String? = nil, teacher: String? = nil, subjectName: String? = nil) {
        self.className = className
        self.subjectType = subjectType
        self.teacher = teacher
        self.subjectName = subjectName
        self.color = .random
        let color = dataManager.subjectColorMap[className]
        if let color = color {
            self.color = color
        } else {
            setColor(.random, with: dataManager)
        }
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
        color = try container.decode(CodableColor.self, forKey: .color)
    }
    
    private enum CodingKeys: CodingKey {
        case className, subjectType, teacher, subjectName, color
    }
}
