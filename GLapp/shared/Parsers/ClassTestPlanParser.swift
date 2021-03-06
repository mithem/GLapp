//
//  ClassTestPlanParser.swift
//  ClassTestPlanParser
//
//  Created by Miguel Themann on 08.10.21.
//

import Foundation
import SWXMLHash

class ClassTestPlanParser {
    static func parse(plan: String, with dataManager: DataManager) -> Result<ClassTestPlan, ParserError> {
        let hash = XMLHash.parse(plan)
        guard let classTestPlanIndex = hash.children.first else { return .failure(.noRootElement) }
        guard let classTestPlanElem = classTestPlanIndex.element else { return .failure(.noRootElement) }
        if classTestPlanElem.name != "Klausurplan" {
            return .failure(.invalidRootElement)
        }
        guard let timestampText = classTestPlanElem.attribute(by: "Timestamp")?.text.trimmed() else { return .failure(.noTimestamp) }
        guard let timestampInterval = TimeInterval(timestampText) else { return .failure(.invalidTimestamp) }
        let date = Date(timeIntervalSince1970: timestampInterval)
        let classTestPlan = ClassTestPlan(date: date)
        
        for childIdx in classTestPlanIndex.children {
            guard let childElem = childIdx.element else { continue }
            if childElem.name != "Klausur" {
                continue
            }
            
            guard let classTestDateText = childElem.attribute(by: "Datum")?.text.trimmed() else { continue }
            guard let classTestDate = GLDateFormatter.classTestDateParsingFormatter.date(from: classTestDateText) else { continue }
            guard let alias = childElem.attribute(by: "bezeichnung")?.text.trimmed() else { continue }
            guard let dateText = childElem.attribute(by: "stand")?.text.trimmed() else { continue }
            guard let date = GLDateFormatter.parsingClassTestDateFormatter.date(from: dateText) else { continue }
            
            let individual = childElem.attribute(by: "individuell")?.text.trimmed() == "1"
            let opened = childElem.attribute(by: "freigegeben")?.text.trimmed() == "1"
            
            var startN: Int? = nil
            if let startNText = childElem.attribute(by: "vonStd")?.text.trimmed() {
                startN = Int(startNText)
            }
            var endN: Int? = nil
            if let endNText = childElem.attribute(by: "bisStd")?.text.trimmed() {
                endN = Int(endNText)
            }
            var room = childElem.attribute(by: "raum")?.text.trimmed()
            if room == "-" {
                room = nil
            }
            var subjectName = childElem.attribute(by: "fach")?.text.trimmed()
            if subjectName == "-" {
                subjectName = nil
            }
            var teacher = childElem.attribute(by: "lehrer")?.text.trimmed()
            if teacher == "-" {
                teacher = nil
            }
            
            let subject = dataManager.getSubject(subjectName: subjectName ?? alias, className: alias)
            if subject.teacher == nil {
                subject.teacher = teacher
            }
            if subject.subjectName == nil {
                subject.subjectName = subjectName
            }
            let classTest = ClassTest(date: date, classTestDate: classTestDate, start: startN, end: endN, room: room, subject: subject, teacher: teacher, individual: individual, opened: opened, alias: alias)
            classTestPlan.classTests.append(classTest)
        }
        
        return .success(classTestPlan)
    }
}
