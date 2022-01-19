//
//  MockData.swift
//  MockData
//
//  Created by Miguel Themann on 09.10.21.
//

import Foundation

struct MockData {
    static let dataManager = MockDataManager()
    static let subject = Subject(dataManager: dataManager, className: "M-LK2", subjectType: "LK", teacher: "PST", color: .blue)
    static let subject2 = Subject(dataManager: dataManager, className: "PH-LK1", subjectType: "LK", teacher: "SEN", color: .green)
    static let subject3 = Subject(dataManager: dataManager, className: "EK-GK2", subjectType: "GKM", teacher: "BUS", color: .purple)
    static let subject4 = Subject(dataManager: dataManager, className: "PSE", subjectType: "PSE", teacher: "BLN", subjectName: "PSE", color: .red)
    static let subject5 = Subject(dataManager: dataManager, className: "SPAN", subjectType: "SPAN", teacher: "SPAN", subjectName: "SPAN", color: .yellow)
    static let lesson = Lesson(lesson: 4, room: "A10", subject: subject)
    static let lesson2 = Lesson(lesson: 5, room: "A10", subject: subject)
    static let lesson3 = Lesson(lesson: 6, room: "PR2", subject: subject2)
    static let lesson4 = Lesson(lesson: 7, room: "PR2", subject: subject2)
    static let lesson5 = Lesson(lesson: 1, room: "A17", subject: subject3)
    static let lesson6 = Lesson(lesson: 2, room: "A16", subject: subject3)
    static let lesson7 = Lesson(lesson: 3, room: "FOR", subject: subject2)
    static let lesson8 = Lesson(lesson: 4, room: "FOR", subject: subject3)
    static let lesson9 = Lesson(lesson: 8, room: "IR3", subject: subject4)
    static let lesson10 = Lesson(lesson: 9, room: "IR3", subject: subject4)
    static let lesson11 = Lesson(lesson: 10, room: "SPANI", subject: subject5)
    static let lesson12 = Lesson(lesson: 4, room: "IR3", subject: subject4)
    static let lesson13 = Lesson(lesson: 5, room: "IR3", subject: subject4)
    static let representativeLesson = RepresentativeLesson(date: nDaysFromNow(), lesson: 5, room: "A10", newRoom: "A11", note: "Raumänderung", subject: subject, normalTeacher: "PST")
    static let representativeLesson2 = RepresentativeLesson(date: nDaysFromNow(), lesson: 2, room: "PR1", newRoom: nil, note: "EVA", subject: subject2, normalTeacher: "PR1")
    static let representativePlan = RepresentativePlan(date: .init(timeIntervalSinceNow: -600), representativeDays: [.init(date: nDaysFromNow(), lessons: [representativeLesson2, representativeLesson])], lessons: [], notes: ["Test-Eintrag für das Android-App-Team"])
    static let classTest = ClassTest(date: .init(timeIntervalSinceNow: -10000), classTestDate: nDaysFromNow(), start: 1, end: 1, room: "A11", subject: subject4, teacher: "ABC", individual: true, opened: true, alias: "PSE")
    static let classTest2 = ClassTest(date: .init(timeIntervalSinceNow: -7200), classTestDate: nDaysFromNow(7), start: 2, end: 5, room: "A10", subject: subject, teacher: "PST", individual: true, opened: true, alias: "M")
    static let classTest3 = ClassTest(date: .init(timeIntervalSinceNow: -7200), classTestDate: nDaysFromNow(2), start: 4, end: 5, room: "E38", subject: subject3, teacher: "DEF", individual: true, opened: true, alias: "K")
    static let classTestPlan = ClassTestPlan(date: .init(timeIntervalSinceNow: -100000), classTests: [classTest, classTest2, classTest3])
    static let timetable = Timetable(date: .init(timeIntervalSinceNow: -100000), weekdays: [
        .init(id: 0, lessons: [lesson, lesson2, lesson3, lesson4]),
        .init(id: 1, lessons: [lesson5, lesson6, lesson, lesson2]),
        .init(id: 2, lessons: [lesson12, lesson13, lesson3, lesson4, lesson9, lesson10]),
        .init(id: 3, lessons: [lesson7, lesson8, lesson2, lesson3]),
        .init(id: 4, lessons: [lesson5, lesson6, lesson7, lesson8, lesson11])
    ])
    
    static let emptyClassTestPlanString = """
<Klausurplan></Klausurplan>
"""
    
    static let validReprPlanString = """
<Vertretungsplan Stand="2021-10-25 12:07:00" Timestamp="1635156420">
<Vertretungstag Datum="Montag, 25.10.2021"></Vertretungstag>
<Vertretungstag Datum="Dienstag, 26.10.2021">
    <Stunde Std="6" \n\t\t\t\t\t\t\t\tKlasse="Q2" \n\t\t\t\t\t\t\t\tRaum="PR2" \n\t\t\t\t\t\t\t\tFach="PH" RaumNeu="" Zeitstempel="" Bemerkung="(frei)" FLehrer="SEN" VLehrer=""></Stunde>
    <Stunde Std="7" \n\t\t\t\t\t\t\t\tKlasse="Q2" \n\t\t\t\t\t\t\t\tRaum="PR2" \n\t\t\t\t\t\t\t\tFach="PH" RaumNeu="" Zeitstempel="" Bemerkung="(frei)" FLehrer="SEN" VLehrer="SEN"></Stunde>
    <Stunde Std="8" Klasse="05a" Raum="130" Fach="D" RaumNeu="A16" Zeitstempel="" Bemerkung="Raumänderung" FLehrer="ABC" VLehrer="DEF" />
    <Stunde Std="9" Klasse="5b" Raum="124" Fach="E" RaumNeu="E14" Zeitstempel="" Bemerkung="raum?nderung" FLehrer="DEF" VLehrer="GHI"></Stunde>
    <Stunde Std="10" Klasse="5b" Raum="124" Fach="E" RaumNeu="E14" Zeitstempel="" Bemerkung="" FLehrer="DEF" VLehrer="GHI" />
    <Informationen>
<Info urgent="0" text="Test information"/>
</Informationen>
</Vertretungstag>\t\t\t
<Vertretungstag Datum="Mittwoch, 27.10.2021">
    <Stunde Std="2" Klasse="08b" Raum="130" Fach="PL" RaumNeu="" Zeitstempel="" Bemerkung="" FLehrer="JKL" VLehrer="MNO"></Stunde>
</Vertretungstag>
<Informationen>
    <Info urgent="0" text="Another test information"/>\t\t\t</Informationen>\n\t\t\t\n
\t\t\t</Vertretungsplan>\n\t\t\t\n\t\t\t
"""
    
    static let validClassTestPlanString = """
<Klausurplan Stand="29.09.2021 08:55:04" Timestamp="1632898504">
<Klausur individuell="1" Datum="29.10.2021" freigegeben="1" vonStd="2" bisStd="5" raum="PR2" bezeichnung="PH-LK1" fach="PH" stand="2021-09-29 08:55:05" lehrer="SEN"/>
<Klausur individuell="0" Datum="02.11.2021" freigegeben="1" vonStd="-" bisStd="-" raum="-" bezeichnung="SW-GK1" fach="SW" stand="2021-09-29 08:55:05" lehrer="HBS"/>
<Klausur individuell="1" Datum="01.12.2021" freigegeben="0" vonStd="-" bisStd="-" raum="-" bezeichnung="M-LK2" fach="M" stand="2021-09-29 08:55:07" lehrer="PST"/>
</Klausurplan>
"""
    
    static let validTimetableString = """
<Stundenplan Datum="2021-09-13 09:26:44" Timestamp="1631518004">
<Wochentag Tag="Montag">
<Stunde Std="1" Kurs="PL-GK1" Raum="A14" Fach="PL" Kursart="GKM" Lehrer="TRR"/>
<Stunde Std="2" Kurs="IF-GK1" Raum="IR1" Fach="IF" Kursart="GKS" Lehrer="NFD"/>
<Stunde Std="3" Kurs="IF-GK1" Raum="IR1" Fach="IF" Kursart="GKS" Lehrer="NFD"/>
<Stunde Std="4" Kurs="E-GK1" Raum="A14" Fach="E" Kursart="AB3" Lehrer="ERD"/>
<Stunde Std="5" Kurs="E-GK1" Raum="A14" Fach="E" Kursart="AB3" Lehrer="ERD"/>
<Stunde Std="6" Kurs="M-LK2" Raum="A11" Fach="M" Kursart="LK1" Lehrer="PST"/>
<Stunde Std="7" Kurs="M-LK2" Raum="A11" Fach="M" Kursart="LK1" Lehrer="PST"/>
<Stunde Std="8" Kurs="EK-GK1" Raum="A16" Fach="EK" Kursart="GKM" Lehrer="BCH"/>
<Stunde Std="9" Kurs="EK-GK1" Raum="A16" Fach="EK" Kursart="GKM" Lehrer="BCH"/>
<Stunde Std="10" Kurs="" Raum="" Fach="" Kursart="" Lehrer=""/>
</Wochentag>
<Wochentag Tag="Dienstag">
<Stunde Std="1" Kurs="GE-GK1" Raum="A17" Fach="GE" Kursart="GKM" Lehrer="BCH"/>
<Stunde Std="2" Kurs="SW-GK1" Raum="A16" Fach="SW" Kursart="AB4" Lehrer="HBS"/>
<Stunde Std="3" Kurs="SW-GK1" Raum="A16" Fach="SW" Kursart="AB4" Lehrer="HBS"/>
<Stunde Std="4" Kurs="D-GK3" Raum="A16" Fach="D" Kursart="GKS" Lehrer="DRO"/>
<Stunde Std="5" Kurs="D-GK3" Raum="A16" Fach="D" Kursart="GKS" Lehrer="DRO"/>
<Stunde Std="6" Kurs="PH-LK1" Raum="PR2" Fach="PH" Kursart="LK2" Lehrer="SEN"/>
<Stunde Std="7" Kurs="PH-LK1" Raum="PR2" Fach="PH" Kursart="LK2" Lehrer="SEN"/>
<Stunde Std="8" Kurs="PSE-PJK1" Raum="IR3" Fach="PSE" Kursart="PJK" Lehrer="BLN"/>
<Stunde Std="9" Kurs="PSE-PJK1" Raum="IR3" Fach="PSE" Kursart="PJK" Lehrer="BLN"/>
<Stunde Std="10" Kurs="" Raum="" Fach="" Kursart="" Lehrer=""/>
</Wochentag>
<Wochentag Tag="Mittwoch">
<Stunde Std="1" Kurs="" Raum="" Fach="" Kursart="" Lehrer=""/>
<Stunde Std="2" Kurs="M-LK2" Raum="A11" Fach="M" Kursart="LK1" Lehrer="PST"/>
<Stunde Std="3" Kurs="M-LK2" Raum="A11" Fach="M" Kursart="LK1" Lehrer="PST"/>
<Stunde Std="4" Kurs="" Raum="" Fach="" Kursart="" Lehrer=""/>
<Stunde Std="5" Kurs="" Raum="" Fach="" Kursart="" Lehrer=""/>
<Stunde Std="6" Kurs="E-GK1" Raum="A14" Fach="E" Kursart="AB3" Lehrer="ERD"/>
<Stunde Std="7" Kurs="IF-GK1" Raum="IR1" Fach="IF" Kursart="GKS" Lehrer="NFD"/>
<Stunde Std="8" Kurs="SP-GK2" Raum="TH5" Fach="SP" Kursart="GKM" Lehrer="FDK"/>
<Stunde Std="9" Kurs="SP-GK2" Raum="TH5" Fach="SP" Kursart="GKM" Lehrer="FDK"/>
<Stunde Std="10" Kurs="" Raum="" Fach="" Kursart="" Lehrer=""/>
</Wochentag>
<Wochentag Tag="Donnerstag">
<Stunde Std="1" Kurs="PH-LK1" Raum="PR2" Fach="PH" Kursart="LK2" Lehrer="SEN"/>
<Stunde Std="2" Kurs="PL-GK1" Raum="A14" Fach="PL" Kursart="GKM" Lehrer="TRR"/>
<Stunde Std="3" Kurs="PL-GK1" Raum="A14" Fach="PL" Kursart="GKM" Lehrer="TRR"/>
<Stunde Std="4" Kurs="GE-GK1" Raum="A17" Fach="GE" Kursart="GKM" Lehrer="BCH"/>
<Stunde Std="5" Kurs="GE-GK1" Raum="A17" Fach="GE" Kursart="GKM" Lehrer="BCH"/>
<Stunde Std="6" Kurs="SW-GK1" Raum="A16" Fach="SW" Kursart="AB4" Lehrer="HBS"/>
<Stunde Std="7" Kurs="D-GK3" Raum="A16" Fach="D" Kursart="GKS" Lehrer="DRO"/>
<Stunde Std="8" Kurs="" Raum="" Fach="" Kursart="" Lehrer=""/>
<Stunde Std="9" Kurs="" Raum="" Fach="" Kursart="" Lehrer=""/>
<Stunde Std="10" Kurs="" Raum="" Fach="" Kursart="" Lehrer=""/>
</Wochentag>
<Wochentag Tag="Freitag">
<Stunde Std="1" Kurs="EK-GK1" Raum="A16" Fach="EK" Kursart="GKM" Lehrer="BCH"/>
<Stunde Std="2" Kurs="PH-LK1" Raum="PR2" Fach="PH" Kursart="LK2" Lehrer="SEN"/>
<Stunde Std="3" Kurs="PH-LK1" Raum="PR2" Fach="PH" Kursart="LK2" Lehrer="SEN"/>
<Stunde Std="4" Kurs="" Raum="" Fach="" Kursart="" Lehrer=""/>
<Stunde Std="5" Kurs="" Raum="" Fach="" Kursart="" Lehrer=""/>
<Stunde Std="6" Kurs="M-LK2" Raum="A11" Fach="M" Kursart="LK1" Lehrer="PST"/>
<Stunde Std="7" Kurs="" Raum="" Fach="" Kursart="" Lehrer=""/>
<Stunde Std="8" Kurs="" Raum="" Fach="" Kursart="" Lehrer=""/>
<Stunde Std="9" Kurs="" Raum="" Fach="" Kursart="" Lehrer=""/>
<Stunde Std="10" Kurs="" Raum="" Fach="" Kursart="" Lehrer=""/>
</Wochentag>
</Stundenplan>
"""
    
    static func nDaysFromNow(_ n: Int = 0) -> Date {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = .init(identifier: "Europe/Berlin")!
        var components = calendar.dateComponents([.year, .month, .day], from: .rightNow)
        components.day = components.day! + n
        return calendar.date(from: components)!
    }
}
