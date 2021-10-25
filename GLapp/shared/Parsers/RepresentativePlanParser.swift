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
        if reprPlanElem.name != "Vertretungsplan" {
            return .failure(.invalidRootElement)
        }
        guard let timestampText = reprPlanElem.attribute(by: "Timestamp")?.text else { return .failure(.noTimestamp) }
        guard let timestampInterval = TimeInterval(timestampText) else { return .failure(.invalidTimestamp) }
        let date = Date(timeIntervalSince1970: timestampInterval)
        var reprPlan = RepresentativePlan(date: date)
        
        for childIndex in reprPlanIndex.children {
            guard let childElem = childIndex.element else { continue }
            if childElem.name == "Vertretungstag" {
                var reprDay = RepresentativeDay()
                for dayIndex in childIndex.children {
                    guard let elem = dayIndex.element else { continue }
                    if elem.name.lowercased() == "stunde" { // just a guess at this point
                        guard let dateText = elem.attribute(by: "Datum")?.text else { continue }
                        guard let date = GLDateFormatter.formatter.date(from: dateText) else { continue }
                        guard let lessonNo = Int(elem.attribute(by: "Stunde")?.text ?? "") else { continue }
                        guard let subjectText = elem.attribute(by: "Fach")?.text else { continue }
                        let subject = Subject(dataManager: dataManager, className: subjectText)
                        let room = elem.attribute(by: "Raum")?.text
                        let newRoom = elem.attribute(by: "RaumNeu")?.text
                        let note = elem.attribute(by: "Hinweis")?.text // can't remember; TODO: Alter
                        
                        let lesson = RepresentativeLesson(date: date, lesson: lessonNo, room: room, newRoom: newRoom, note: note, subject: subject)
                        reprDay.lessons.append(lesson)
                        reprPlan.lessons.append(lesson)
                    }
                }
                reprPlan.representativeDays.append(reprDay)
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
