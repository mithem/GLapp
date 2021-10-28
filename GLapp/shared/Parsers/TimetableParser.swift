//
//  TimetableParser.swift
//  TimetableParser
//
//  Created by Miguel Themann on 08.10.21.
//

import Foundation
import SWXMLHash

class TimetableParser {
    static func parse(timetable: String, with dataManager: DataManager) -> Result<Timetable, ParserError> {
        let hash = XMLHash.parse(timetable)
        guard let timetableIndex = hash.children.first else { return .failure(.noRootElement) }
        guard let timetableElem = timetableIndex.element else { return .failure(.noRootElement) }
        if timetableElem.name != "Stundenplan" {
            return .failure(.invalidRootElement)
        }
        guard let timestampText = timetableElem.attribute(by: "Timestamp")?.text else { return .failure(.noTimestamp) }
        guard let timestampInterval = TimeInterval(timestampText) else { return .failure(.invalidTimestamp) }
        let date = Date(timeIntervalSince1970: timestampInterval)
        let timetable = Timetable(date: date)
        
        for childIdx in timetableIndex.children {
            guard let childElem = childIdx.element else { continue }
            if childElem.name != "Wochentag" {
                continue
            }
            guard let weekdayNText = childElem.attribute(by: "Tag")?.text else { continue }
            guard let weekdayN = Int(weekday: weekdayNText) else { continue }
            let weekday = Weekday(id: weekdayN)
            
            for lessonIdx in childIdx.children {
                guard let lessonElem = lessonIdx.element else { continue }
                if lessonElem.name != "Stunde" {
                    continue
                }
                guard let lessonNText = lessonElem.attribute(by: "Std")?.text else { continue }
                guard let lessonN = Int(lessonNText) else { continue }
                guard let className = lessonElem.attribute(by: "Kurs")?.text else { continue }
                guard let room = lessonElem.attribute(by: "Raum")?.text else { continue }
                let teacher = lessonElem.attribute(by: "Lehrer")?.text
                let subjectType = lessonElem.attribute(by: "Kursart")?.text
                let subjectName = lessonElem.attribute(by: "Fach")?.text
                
                if className == "" && room == "" && teacher == ""  && subjectType == ""  && subjectName == "" {
                    continue // free lesson
                }
                
                let subject = Subject(dataManager: dataManager, className: className)
                subject.subjectName = subjectName
                subject.subjectType = subjectType
                subject.teacher = teacher
                
                let lesson = Lesson(lesson: lessonN, room: room, subject: subject)
                weekday.lessons.append(lesson)
            }
            timetable.weekdays.append(weekday)
        }
        
        DispatchQueue.main.async {
            timetable.reloadSubjects(with: dataManager)
        }
        return .success(timetable)
    }
}
