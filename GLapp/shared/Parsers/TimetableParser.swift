//
//  TimetableParser.swift
//  TimetableParser
//
//  Created by Miguel Themann on 08.10.21.
//

import Foundation
import SWXMLHash

class TimetableParser {
    static func parse(timetable: String, with dataManager: DataManager, completion: @escaping (Result<Timetable, ParserError>) -> Void) {
        DispatchQueue.main.async { // DataManager needs to update subjectColorMap in main thread (as a publisher), so this would result in a data race when subjectColorMap isn't populated from the beginning -> colors not synced
            let hash = XMLHash.parse(timetable)
            guard let timetableIndex = hash.children.first else { return completion(.failure(.noRootElement)) }
                guard let timetableElem = timetableIndex.element else { return completion(.failure(.noRootElement)) }
            if timetableElem.name != "Stundenplan" {
                return completion(.failure(.invalidRootElement))
            }
            guard let timestampText = timetableElem.attribute(by: "Timestamp")?.text.trimmed() else { return completion(.failure(.noTimestamp)) }
            guard let timestampInterval = TimeInterval(timestampText) else { return completion(.failure(.invalidTimestamp)) }
            let date = Date(timeIntervalSince1970: timestampInterval)
            let timetable = Timetable(date: date)
            
            for childIdx in timetableIndex.children {
                guard let childElem = childIdx.element else { continue }
                if childElem.name != "Wochentag" {
                    continue
                }
                guard let weekdayNText = childElem.attribute(by: "Tag")?.text.trimmed().lowercased() else { continue }
                guard let weekdayN = GLDateFormatter.berlinFormatter.standaloneWeekdaySymbols.map({$0.lowercased()}).firstIndex(of: weekdayNText) else { continue }
                let weekday = Weekday(id: weekdayN)
                
                for lessonIdx in childIdx.children {
                    guard let lessonElem = lessonIdx.element else { continue }
                    if lessonElem.name != "Stunde" {
                        continue
                    }
                    guard let lessonNText = lessonElem.attribute(by: "Std")?.text.trimmed() else { continue }
                    guard let lessonN = Int(lessonNText) else { continue }
                    guard var className = lessonElem.attribute(by: "Kurs")?.text.trimmed() else { continue }
                    guard let room = lessonElem.attribute(by: "Raum")?.text.trimmed() else { continue }
                    var teacher = lessonElem.attribute(by: "Lehrer")?.text.trimmed()
                    if teacher?.isEmpty ?? false { teacher = nil }
                    var subjectType = lessonElem.attribute(by: "Kursart")?.text.trimmed()
                    if subjectType?.isEmpty ?? false { subjectType = nil }
                    var subjectName = lessonElem.attribute(by: "Fach")?.text.trimmed()
                    if subjectName?.isEmpty ?? false { subjectName = nil }
                    
                    if className.isEmpty && room.isEmpty && teacher?.isEmpty ?? true && subjectType?.isEmpty ?? true && subjectName?.isEmpty ?? true { // free lesson
                        continue
                    }
                    if className.isEmpty, let subjectName = subjectName, !subjectName.isEmpty { // Unter- and Mittelstufe
                        className = subjectName
                    }
                    let subject = dataManager.getSubject(subjectName: subjectName ?? className, className: className, onMainThread: false) // this function already runs there
                    subject.subjectName = subjectName
                    subject.subjectType = subjectType
                    subject.teacher = teacher
                    
                    let lesson = Lesson(lesson: lessonN, weekday: weekday, room: room, subject: subject)
                    weekday.lessons.append(lesson)
                }
                timetable.weekdays.append(weekday)
            }
            return completion(.success(timetable))
        }
    }
}
