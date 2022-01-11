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
        var date: Date? = Date(timeIntervalSince1970: timestampInterval)
        if date == .janFirst2000 { // gets sent for whatever reason when reprPlan is empty
            date = nil
        }
        let reprPlan = RepresentativePlan(date: date)
        
        for childIndex in reprPlanIndex.children {
            guard let childElem = childIndex.element else { continue }
            if childElem.name.lowercased() == "vertretungstag" {
                guard var dateText = childElem.attribute(by: "Datum")?.text else { continue }
                dateText = String(dateText.suffix(10)) // dd.MM.yyyy
                guard let date = GLDateFormatter.berlinFormatter.date(from: dateText) else { continue }
                let reprDay = RepresentativeDay(date: date)
                for dayIndex in childIndex.children {
                    guard let elem = dayIndex.element else { continue }
                    if elem.name.lowercased() == "stunde" {
                        guard let lessonNo = Int(elem.attribute(by: "Std")?.text ?? "") else { continue }
                        guard let normalTeacher = elem.attribute(by: "FLehrer")?.text else { continue }
                        guard let subjectText = elem.attribute(by: "Fach")?.text else { continue }
                        if subjectText.isEmpty || normalTeacher.isEmpty { // did happen. For an example, see `TestRepresentativePlanParser.testParseBrokenServerResponse`
                            reprDay.lessons.append(.invalid)
                            continue
                        }
                        let subject = dataManager.getSubject(subjectName: subjectText, className: nil)
                        if subject.subjectName == nil {
                            subject.subjectName = subjectText
                        }
                        if subject.teacher == nil {
                            subject.teacher = normalTeacher
                        }
                        let room = elem.attribute(by: "Raum")?.text
                        var newRoom = elem.attribute(by: "RaumNeu")?.text
                        if newRoom?.isEmpty == true {
                            newRoom = nil
                        }
                        var note = elem.attribute(by: "Bemerkung")?.text
                        if note == nil || note?.isEmpty == true {
                            note = newRoom != nil ? "Raumänderung" : nil
                        } else if note != nil {
                            if newRoom != nil, (try? NSRegularExpression(pattern: #"raum(ä|\?)nderung"#, options: [.caseInsensitive]).firstMatch(in: note!, range: .init(location: 0, length: note!.utf16.count))) != nil { // utf16 seems to deal with emojis and other strange 'characters' better
                                note = note!.lowercased().replacingOccurrences(of: "raum?nderung", with: "raumänderung").localizedCapitalized
                            }
                        }
                        var reprTeacher = elem.attribute(by: "VLehrer")?.text
                        if reprTeacher?.isEmpty == true || reprTeacher == normalTeacher { // yep, just another reality
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
