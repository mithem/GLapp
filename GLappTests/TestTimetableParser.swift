//
//  TestTimetableParser.swift
//  TestTimetableParser
//
//  Created by Miguel Themann on 14.10.21.
//

import XCTest
@testable import GLapp

class TestTimetableParser: XCTestCase {
    var manager: DataManager!
    override func setUpWithError() throws {
        manager = MockDataManager()
    }
    
    func testParseSuccessOberstufe () throws {
        let timetable = """
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
        let sPL = Subject(dataManager: manager, className: "PL-GK1", subjectType: "GKM", teacher: "TRR", subjectName: "PL")
        let sIF = Subject(dataManager: manager, className: "IF-GK1", subjectType: "GKS", teacher: "NFD", subjectName: "IF")
        let sE = Subject(dataManager: manager, className: "E-GK1", subjectType: "AB3", teacher: "ERD", subjectName: "E")
        let sM = Subject(dataManager: manager, className: "M-LK2", subjectType: "LK1", teacher: "PST", subjectName: "M")
        let sEK = Subject(dataManager: manager, className: "EK-GK1", subjectType: "GKM", teacher: "BCH", subjectName: "EK")
        let sGE = Subject(dataManager: manager, className: "GE-GK1", subjectType: "GKM", teacher: "BCH", subjectName: "GE")
        let sSW = Subject(dataManager: manager, className: "SW-GK1", subjectType: "AB4", teacher: "HBS", subjectName: "SW")
        let sD = Subject(dataManager: manager, className: "D-GK3", subjectType: "GKS", teacher: "DRO", subjectName: "D")
        let sPH = Subject(dataManager: manager, className: "PH-LK1", subjectType: "LK2", teacher: "SEN", subjectName: "PH")
        let sPSE = Subject(dataManager: manager, className: "PSE-PJK1", subjectType: "PJK", teacher: "BLN", subjectName: "PSE")
        let sSP = Subject(dataManager: manager, className: "SP-GK2", subjectType: "GKM", teacher: "FDK", subjectName: "SP")
        let date = Date(timeIntervalSince1970: 1631518004)
        let expected = Timetable(date: date, weekdays: [
            .init(id: 0, lessons: [
                .init(lesson: 1, room: "A14", subject: sPL),
                .init(lesson: 2, room: "IR1", subject: sIF),
                .init(lesson: 3, room: "IR1", subject: sIF),
                .init(lesson: 4, room: "A14", subject: sE),
                .init(lesson: 5, room: "A14", subject: sE),
                .init(lesson: 6, room: "A11", subject: sM),
                .init(lesson: 7, room: "A11", subject: sM),
                .init(lesson: 8, room: "A16", subject: sEK),
                .init(lesson: 9, room: "A16", subject: sEK)
            ]),
            .init(id: 1, lessons: [
                .init(lesson: 1, room: "A17", subject: sGE),
                .init(lesson: 2, room: "A16", subject: sSW),
                .init(lesson: 3, room: "A16", subject: sSW),
                .init(lesson: 4, room: "A16", subject: sD),
                .init(lesson: 5, room: "A16", subject: sD),
                .init(lesson: 6, room: "PR2", subject: sPH),
                .init(lesson: 7, room: "PR2", subject: sPH),
                .init(lesson: 8, room: "IR3", subject: sPSE),
                .init(lesson: 9, room: "IR3", subject: sPSE)
            ]),
            .init(id: 2, lessons: [
                .init(lesson: 2, room: "A11", subject: sM),
                .init(lesson: 3, room: "A11", subject: sM),
                .init(lesson: 6, room: "A14", subject: sE),
                .init(lesson: 7, room: "IR1", subject: sIF),
                .init(lesson: 8, room: "TH5", subject: sSP),
                .init(lesson: 9, room: "TH5", subject: sSP)
            ]),
            .init(id: 3, lessons: [
                .init(lesson: 1, room: "PR2", subject: sPH),
                .init(lesson: 2, room: "A14", subject: sPL),
                .init(lesson: 3, room: "A14", subject: sPL),
                .init(lesson: 4, room: "A17", subject: sGE),
                .init(lesson: 5, room: "A17", subject: sGE),
                .init(lesson: 6, room: "A16", subject: sSW),
                .init(lesson: 7, room: "A16", subject: sD)
            ]),
            .init(id: 4, lessons: [
                .init(lesson: 1, room: "A16", subject: sEK),
                .init(lesson: 2, room: "PR2", subject: sPH),
                .init(lesson: 3, room: "PR2", subject: sPH),
                .init(lesson: 6, room: "A11", subject: sM),
            ])
        ])
        
        let result = try TimetableParser.parse(timetable: timetable, with: manager).get()
        
        XCTAssertEqual(result.date, date)
        for n in 0 ..< expected.weekdays.count {
            XCTAssertEqual(result.weekdays[n].id, expected.weekdays[n].id)
            for i in 0 ..< expected.weekdays[n].lessons.count {
                XCTAssertEqual(result.weekdays[n].lessons[i], expected.weekdays[n].lessons[i])
            }
        }
    }
    
    func testParseSuccessMittelUndUnterstufe() throws {
        let timetable = """
        <Stundenplan Datum="2021-10-29 09:52:03" Timestamp="1635493923">
        <Wochentag Tag="Montag">
        <Stunde Std="1" Kurs="" Raum="130" Fach="I" Kursart="" Lehrer=""/>
        <Stunde Std="2" Kurs="" Raum="TH4" Fach="SP" Kursart="" Lehrer=""/>
        <Stunde Std="3" Kurs="" Raum="TH4" Fach="SP" Kursart="" Lehrer=""/>
        <Stunde Std="4" Kurs="" Raum="130" Fach="F" Kursart="" Lehrer=""/>
        <Stunde Std="5" Kurs="" Raum="130" Fach="M" Kursart="" Lehrer=""/>
        <Stunde Std="6" Kurs="" Raum="130" Fach="M" Kursart="" Lehrer=""/>
        <Stunde Std="7" Kurs="" Raum="131" Fach="LS Sportspi" Kursart="" Lehrer=""/>
        <Stunde Std="8" Kurs="" Raum="" Fach="" Kursart="" Lehrer=""/>
        <Stunde Std="9" Kurs="" Raum="" Fach="" Kursart="" Lehrer=""/>
        <Stunde Std="10" Kurs="" Raum="" Fach="" Kursart="" Lehrer=""/>
        <Stunde Std="11" Kurs="" Raum="" Fach="" Kursart="" Lehrer=""/>
        </Wochentag>
        <Wochentag Tag="Dienstag">
        <Stunde Std="1" Kurs="" Raum="130" Fach="D" Kursart="" Lehrer=""/>
        <Stunde Std="2" Kurs="" Raum="130" Fach="F" Kursart="" Lehrer=""/>
        <Stunde Std="3" Kurs="" Raum="130" Fach="F" Kursart="" Lehrer=""/>
        <Stunde Std="4" Kurs="" Raum="127" Fach="PP" Kursart="" Lehrer=""/>
        <Stunde Std="5" Kurs="" Raum="127" Fach="PP" Kursart="" Lehrer=""/>
        <Stunde Std="6" Kurs="" Raum="E22" Fach="CH" Kursart="" Lehrer=""/>
        <Stunde Std="7" Kurs="" Raum="130" Fach="LSM" Kursart="" Lehrer=""/>
        <Stunde Std="8" Kurs="" Raum="" Fach="" Kursart="" Lehrer=""/>
        <Stunde Std="9" Kurs="" Raum="" Fach="" Kursart="" Lehrer=""/>
        <Stunde Std="10" Kurs="" Raum="" Fach="" Kursart="" Lehrer=""/>
        <Stunde Std="11" Kurs="" Raum="" Fach="" Kursart="" Lehrer=""/>
        </Wochentag>
        <Wochentag Tag="Mittwoch">
        <Stunde Std="1" Kurs="" Raum="" Fach="" Kursart="" Lehrer=""/>
        <Stunde Std="2" Kurs="" Raum="130" Fach="E" Kursart="" Lehrer=""/>
        <Stunde Std="3" Kurs="" Raum="130" Fach="E" Kursart="" Lehrer=""/>
        <Stunde Std="4" Kurs="" Raum="130" Fach="M" Kursart="" Lehrer=""/>
        <Stunde Std="5" Kurs="" Raum="BR2" Fach="BI" Kursart="" Lehrer=""/>
        <Stunde Std="6" Kurs="" Raum="130" Fach="E" Kursart="" Lehrer=""/>
        <Stunde Std="7" Kurs="" Raum="" Fach="" Kursart="" Lehrer=""/>
        <Stunde Std="8" Kurs="" Raum="132" Fach="I" Kursart="" Lehrer=""/>
        <Stunde Std="9" Kurs="" Raum="132" Fach="I" Kursart="" Lehrer=""/>
        <Stunde Std="10" Kurs="" Raum="" Fach="" Kursart="" Lehrer=""/>
        <Stunde Std="11" Kurs="" Raum="" Fach="" Kursart="" Lehrer=""/>
        </Wochentag>
        <Wochentag Tag="Donnerstag">
        <Stunde Std="1" Kurs="" Raum="" Fach="" Kursart="" Lehrer=""/>
        <Stunde Std="2" Kurs="" Raum="MR2" Fach="MU" Kursart="" Lehrer=""/>
        <Stunde Std="3" Kurs="" Raum="CR2" Fach="CH" Kursart="" Lehrer=""/>
        <Stunde Std="4" Kurs="" Raum="130" Fach="D" Kursart="" Lehrer=""/>
        <Stunde Std="5" Kurs="" Raum="130" Fach="D" Kursart="" Lehrer=""/>
        <Stunde Std="6" Kurs="" Raum="130" Fach="E" Kursart="" Lehrer=""/>
        <Stunde Std="7" Kurs="" Raum="123" Fach="LRS" Kursart="" Lehrer=""/>
        <Stunde Std="8" Kurs="" Raum="KR1" Fach="KUWP" Kursart="" Lehrer=""/>
        <Stunde Std="9" Kurs="" Raum="KR1" Fach="KUWP" Kursart="" Lehrer=""/>
        <Stunde Std="10" Kurs="" Raum="" Fach="" Kursart="" Lehrer=""/>
        <Stunde Std="11" Kurs="" Raum="" Fach="" Kursart="" Lehrer=""/>
        </Wochentag>
        <Wochentag Tag="Freitag">
        <Stunde Std="1" Kurs="" Raum="130" Fach="D" Kursart="" Lehrer=""/>
        <Stunde Std="2" Kurs="" Raum="130" Fach="EK" Kursart="" Lehrer=""/>
        <Stunde Std="3" Kurs="" Raum="130" Fach="EK" Kursart="" Lehrer=""/>
        <Stunde Std="4" Kurs="" Raum="MR2" Fach="MU" Kursart="" Lehrer=""/>
        <Stunde Std="5" Kurs="" Raum="BR2" Fach="BI" Kursart="" Lehrer=""/>
        <Stunde Std="6" Kurs="" Raum="130" Fach="M" Kursart="" Lehrer=""/>
        <Stunde Std="7" Kurs="" Raum="" Fach="" Kursart="" Lehrer=""/>
        <Stunde Std="8" Kurs="" Raum="" Fach="" Kursart="" Lehrer=""/>
        <Stunde Std="9" Kurs="" Raum="" Fach="" Kursart="" Lehrer=""/>
        <Stunde Std="10" Kurs="" Raum="" Fach="" Kursart="" Lehrer=""/>
        <Stunde Std="11" Kurs="" Raum="" Fach="" Kursart="" Lehrer=""/>
        </Wochentag>
        </Stundenplan>
"""
        let dataManager = MockDataManager()
        
        func s(_ className: String) -> Subject{
            return Subject(dataManager: dataManager, className: className, subjectType: nil, teacher: nil, subjectName: className)
        }
        
        let sI = s("I")
        let sSP = s("SP")
        let sF = s("F")
        let sM = s("M")
        let sLS = s("LS Sportspi")
        let sD = s("D")
        let sPP = s("PP")
        let sCH = s("CH")
        let sLSM = s("LSM")
        let sBI = s("BI")
        let sE = s("E")
        let sLRS = s("LRS")
        let sKUWP = s("KUWP")
        let sEK = s("EK")
        let sMU = s("MU")
        let date = Date(timeIntervalSince1970: 1635493923)
        let expected = Timetable(date: date, weekdays: [
            .init(id: 0, lessons: [
                .init(lesson: 1, room: "130", subject: sI),
                .init(lesson: 2, room: "TH4", subject: sSP),
                .init(lesson: 3, room: "TH4", subject: sSP),
                .init(lesson: 4, room: "130", subject: sF),
                .init(lesson: 5, room: "130", subject: sM),
                .init(lesson: 6, room: "130", subject: sM),
                .init(lesson: 7, room: "131", subject: sLS)
            ]),
            .init(id: 1, lessons: [
                .init(lesson: 1, room: "130", subject: sD),
                .init(lesson: 2, room: "130", subject: sF),
                .init(lesson: 3, room: "130", subject: sF),
                .init(lesson: 4, room: "127", subject: sPP),
                .init(lesson: 5, room: "127", subject: sPP),
                .init(lesson: 6, room: "E22", subject: sCH),
                .init(lesson: 7, room: "130", subject: sLSM)
            ]),
            .init(id: 2, lessons: [
                .init(lesson: 2, room: "130", subject: sE),
                .init(lesson: 3, room: "130", subject: sE),
                .init(lesson: 4, room: "130", subject: sM),
                .init(lesson: 5, room: "BR2", subject: sBI),
                .init(lesson: 6, room: "130", subject: sE),
                .init(lesson: 8, room: "132", subject: sI),
                .init(lesson: 9, room: "132", subject: sI)
            ]),
            .init(id: 3, lessons: [
                .init(lesson: 2, room: "MR2", subject: sMU),
                .init(lesson: 3, room: "CR2", subject: sCH),
                .init(lesson: 4, room: "130", subject: sD),
                .init(lesson: 5, room: "130", subject: sD),
                .init(lesson: 6, room: "130", subject: sE),
                .init(lesson: 7, room: "123", subject: sLRS),
                .init(lesson: 8, room: "KR1", subject: sKUWP),
                .init(lesson: 9, room: "KR1", subject: sKUWP)
            ]),
            .init(id: 4, lessons: [
                .init(lesson: 1, room: "130", subject: sD),
                .init(lesson: 2, room: "130", subject: sEK),
                .init(lesson: 3, room: "130", subject: sEK),
                .init(lesson: 4, room: "MR2", subject: sMU),
                .init(lesson: 5, room: "BR2", subject: sBI),
                .init(lesson: 6, room: "130", subject: sM)
            ])
        ])
        
        let result = try TimetableParser.parse(timetable: timetable, with: manager).get()
        
        XCTAssertEqual(result.date, date)
        for n in 0 ..< expected.weekdays.count {
            XCTAssertEqual(result.weekdays[n].id, expected.weekdays[n].id)
            for i in 0 ..< expected.weekdays[n].lessons.count {
                XCTAssertEqual(result.weekdays[n].lessons[i], expected.weekdays[n].lessons[i])
            }
        }
    }
    
    func testParseNoRootElement() {
        let result = TimetableParser.parse(timetable: "", with: MockDataManager())
        XCTAssertEqual(result, .failure(.noRootElement))
    }
    
    func testParseInvalidRootElement() {
        let result = TimetableParser.parse(timetable: "<Root></Root>", with: MockDataManager())
        XCTAssertEqual(result, .failure(.invalidRootElement))
    }
    
    func testParseNoTimestamp() {
        let result = TimetableParser.parse(timetable: "<Stundenplan></Stundenplan>", with: MockDataManager())
        XCTAssertEqual(result, .failure(.noTimestamp))
    }
    
    func testParseInvalidTimestamp() {
        let timetable = """
<Stundenplan Timestamp="2021-10-15T00:00:00Z"></Stundenplan>
"""
        let result = TimetableParser.parse(timetable: timetable, with: MockDataManager())
        
        XCTAssertEqual(result, .failure(.invalidTimestamp))
    }
}
