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
        guard let timestampText = reprPlanElem.attribute(by: "Timestamp")?.text.trimmed() else { return .failure(.noTimestamp) }
        guard let timestampInterval = TimeInterval(timestampText) else { return .failure(.invalidTimestamp) }
        var date: Date? = Date(timeIntervalSince1970: timestampInterval)
        if date == .janFirst2000 { // gets sent for whatever reason when reprPlan is empty
            date = nil
        }
        let reprPlan = RepresentativePlan(date: date)
        
        for childIndex in reprPlanIndex.children {
            guard let childElem = childIndex.element else { continue }
            if childElem.name.lowercased() == "vertretungstag" {
                guard var dateText = childElem.attribute(by: "Datum")?.text.trimmed() else { continue }
                dateText = String(dateText.suffix(10)) // dd.MM.yyyy
                guard let date = GLDateFormatter.berlinFormatter.date(from: dateText) else { continue }
                let reprDay = RepresentativeDay(date: date)
                for dayIndex in childIndex.children {
                    guard let elem = dayIndex.element else { continue }
                    if elem.name.lowercased() == "stunde" {
                        guard let lessonNo = Int(elem.attribute(by: "Std")?.text.trimmed() ?? "") else { continue }
                        var normalTeacher = elem.attribute(by: "FLehrer")?.text.trimmed()
                        if normalTeacher?.isEmpty == true {
                            normalTeacher = nil
                        }
                        let subjectText = elem.attribute(by: "Fach")?.text.trimmed()
                        var subject: Subject?
                        if subjectText?.isEmpty ?? true && normalTeacher?.isEmpty ?? true {
                            subject = nil
                        } else if let subjectText = subjectText {
                            subject = dataManager.getSubject(subjectName: subjectText, className: nil)
                            if subject?.subjectName == nil {
                                subject?.subjectName = subjectText
                            }
                            if subject?.teacher == nil {
                                subject?.teacher = normalTeacher
                            }
                        }
                        var room = elem.attribute(by: "Raum")?.text.trimmed()
                        if room?.isEmpty == true {
                            room = nil
                        }
                        var newRoom = elem.attribute(by: "RaumNeu")?.text.trimmed()
                        if newRoom?.isEmpty == true {
                            newRoom = nil
                        }
                        var note = elem.attribute(by: "Bemerkung")?.text.trimmed()
                        if note == nil || note?.isEmpty == true {
                            note = newRoom != nil ? "Raumänderung" : nil
                        } else if note != nil {
                            if newRoom != nil, (try? NSRegularExpression(pattern: #"raum(ä|\?)nderung"#, options: [.caseInsensitive]).firstMatch(in: note!, range: .init(location: 0, length: note!.utf16.count))) != nil { // utf16 seems to deal with emojis and other strange 'characters' better
                                note = note!.lowercased().replacingOccurrences(of: "raum?nderung", with: "raumänderung").localizedCapitalized
                            }
                        }
                        var reprTeacher = elem.attribute(by: "VLehrer")?.text.trimmed()
                        if reprTeacher?.isEmpty == true || reprTeacher == normalTeacher {
                            reprTeacher = nil
                        }
                        
                        let lesson = RepresentativeLesson(date: date, lesson: lessonNo, room: room, newRoom: newRoom, note: note, subject: subject, normalTeacher: normalTeacher, representativeTeacher: reprTeacher)
                        reprDay.lessons.append(lesson)
                    } else if elem.name.lowercased() == "informationen" {
                        reprDay.notes.append(contentsOf: extractNotes(from: dayIndex))
                    }
                }
                if !reprDay.isEmpty {
                    reprPlan.representativeDays.append(reprDay)
                }
            } else if childElem.name == "Informationen" {
                reprPlan.notes.append(contentsOf: extractNotes(from: childIndex))
            }
        }
        return .success(reprPlan)
    }
    
    static private func extractNotes(from indexer: XMLIndexer) -> [String] {
        var notes = [String]()
        for infoIndex in indexer.children {
            guard let elem = infoIndex.element else { continue }
            guard elem.name == "Info" else { continue }
            let note = elem.attribute(by: "text")?.text.trimmed()
            if let note = note, note != "" {
                notes.append(note)
            }
        }
        return notes
    }
}
