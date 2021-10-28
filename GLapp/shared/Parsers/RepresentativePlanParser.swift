//
//  RepresentativePlanParser.swift
//  RepresentativePlanParser
//
//  Created by Miguel Themann on 01.10.21.
//

import Foundation
import SWXMLHash

class RepresentativePlanParser {
    static func parse(plan: String, with dataManager: DataManager) -> Result<RepresentativePlan, ParserError> {
        let hash = XMLHash.parse(plan)
        guard let reprPlanIndex = hash.children.first else { return .failure(.noRootElement) }
        guard let reprPlanElem = reprPlanIndex.element else { return .failure(.noRootElement) }
        if reprPlanElem.name.lowercased() != "vertretungsplan" {
            return .failure(.invalidRootElement)
        }
        guard let timestampText = reprPlanElem.attribute(by: "Timestamp")?.text else { return .failure(.noTimestamp) }
        guard let timestampInterval = TimeInterval(timestampText) else { return .failure(.invalidTimestamp) }
        let date = Date(timeIntervalSince1970: timestampInterval)
        var reprPlan = RepresentativePlan(date: date)
        
        for childIndex in reprPlanIndex.children {
            guard let childElem = childIndex.element else { continue }
            if childElem.name.lowercased() == "vertretungstag" {
                guard var dateText = childElem.attribute(by: "Datum")?.text else { continue }
                dateText = String(dateText.suffix(10)) // dd.MM.yyyy
                guard let date = GLDateFormatter.berlinFormatter.date(from: dateText) else { continue }
                var reprDay = RepresentativeDay(date: date)
                for dayIndex in childIndex.children {
                    guard let elem = dayIndex.element else { continue }
                    if elem.name.lowercased() == "stunde" {
                        guard let lessonNo = Int(elem.attribute(by: "Std")?.text ?? "") else { continue }
                        guard let normalTeacher = elem.attribute(by: "FLehrer")?.text else { continue }
                        guard let subjectText = elem.attribute(by: "Fach")?.text else { continue }
                        let subject = Subject(dataManager: dataManager, className: subjectText, teacher: normalTeacher, subjectName: subjectText) // minor inconsistencies (className being something like 'PH') always arise, i guess..
                        let room = elem.attribute(by: "Raum")?.text
                        var newRoom = elem.attribute(by: "RaumNeu")?.text
                        if newRoom?.isEmpty == true {
                            newRoom = nil
                        }
                        var note = elem.attribute(by: "Bemerkung")?.text
                        if note?.isEmpty == true {
                            note = nil
                        }
                        var reprTeacher = elem.attribute(by: "VLehrer")?.text
                        if reprTeacher?.isEmpty == true {
                            reprTeacher = nil
                        }
                        
                        let lesson = RepresentativeLesson(date: date, lesson: lessonNo, room: room, newRoom: newRoom, note: note, subject: subject, normalTeacher: normalTeacher, representativeTeacher: reprTeacher)
                        reprDay.lessons.append(lesson)
                    } else if elem.name.lowercased() == "informationen" {
                        var note = elem.text
                        note = note.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\t", with: "")
                        if note != "" && note != " " {
                            reprDay.notes.append(note)
                        }
                    }
                }
                if !reprDay.isEmpty {
                    reprPlan.representativeDays.append(reprDay)
                }
            } else if childElem.name == "Informationen" {
                var note = childElem.text
                note = note.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\t", with: "")
                if note != ""  && note != " " {
                    reprPlan.notes.append(note)
                }
            }
        }
        return .success(reprPlan)
    }
}
