//
//  TestRepresentativePlanParser.swift
//  TestRepresentativePlanParser
//
//  Created by Miguel Themann on 09.10.21.
//

import XCTest
@testable import GLapp

class TestRepresentativePlanParser: XCTestCase {
    func testParseEmptyPlaceholderTimestamp() throws {
        let input = """
<Vertretungsplan Stand="2000-01-01 00:00:00" Timestamp="946681200">
<Vertretungstag/>
<Informationen> </Informationen>
</Vertretungsplan>
"""
        let expected = RepresentativePlan(date: nil, representativeDays: [], lessons: [], notes: [])
        
        let result = RepresentativePlanParser.parse(plan: input, with: MockDataManager())
        
        XCTAssertEqual(try result.get(), expected)
    }
    func testParseEmptyCustomTimestamp() throws {
        let input = """
<Vertretungsplan Stand="2000-01-01 00:00:01" Timestamp="946681201">
<Vertretungstag/>
<Informationen> </Informationen>
</Vertretungsplan>
"""
        let expected = RepresentativePlan(date: .init(timeIntervalSince1970: 946681201), representativeDays: [], lessons: [], notes: [])
        
        let result = RepresentativePlanParser.parse(plan: input, with: MockDataManager())
        
        XCTAssertEqual(try result.get(), expected)
    }
    
    func testParseSuccess() throws {
        let input = """
<Vertretungsplan Stand="2021-10-25 12:07:00" Timestamp="1635156420">
<Vertretungstag Datum="Montag, 25.10.2021"></Vertretungstag>
<Vertretungstag Datum="Dienstag, 26.10.2021">
    <Stunde Std="6" \n\t\t\t\t\t\t\t\tKlasse="Q2" \n\t\t\t\t\t\t\t\tRaum="PR2" \n\t\t\t\t\t\t\t\tFach="PH" RaumNeu="" Zeitstempel="" Bemerkung="(frei)" FLehrer="SEN" VLehrer=""></Stunde>
    <Stunde Std="7" \n\t\t\t\t\t\t\t\tKlasse="Q2" \n\t\t\t\t\t\t\t\tRaum="PR2" \n\t\t\t\t\t\t\t\tFach="PH" RaumNeu="" Zeitstempel="" Bemerkung="(frei)" FLehrer="SEN" VLehrer="SEN"></Stunde>
    <Stunde Std="8" Klasse="05a" Raum="130" Fach="D" RaumNeu="A16" Zeitstempel="" Bemerkung="Raumänderung" FLehrer="ABC" VLehrer="DEF" />
    <Stunde Std="9" Klasse="5b" Raum="124" Fach="E" RaumNeu="E14" Zeitstempel="" Bemerkung="raum?nderung" FLehrer="DEF" VLehrer="GHI"></Stunde>
    <Stunde Std="10" Klasse="5b" Raum="124" Fach="E" RaumNeu="E14" Zeitstempel="" Bemerkung="" FLehrer="DEF" VLehrer="GHI" />
    <Informationen>\n\t\t\t\t\t\tTest information</Informationen>
</Vertretungstag>\t\t\t
<Vertretungstag Datum="Mittwoch, 27.10.2021">
    <Stunde Std="2" Klasse="08b" Raum="130" Fach="PL" RaumNeu="" Zeitstempel="" Bemerkung="" FLehrer="JKL" VLehrer="MNO"></Stunde>
</Vertretungstag>
<Informationen>\n\t\t\tAnother test information\t\t\t</Informationen>\n\t\t\t\n
\t\t\t</Vertretungsplan>\n\t\t\t\n\t\t\t
"""
        let dataManager = MockDataManager()
        let date = Calendar(identifier: .gregorian).date(from: .init(timeZone: .init(identifier: "Europe/Berlin"), year: 2021, month: 10, day: 26))!
        let date2 = Calendar(identifier: .gregorian).date(from: .init(timeZone: .init(identifier: "Europe/Berlin"), year: 2021, month: 10, day: 27))!
        let sPH = Subject(dataManager: dataManager, className: "PH", subjectType: nil, teacher: "SEN", subjectName: "PH")
        let sD = Subject(dataManager: dataManager, className: "D", subjectType: nil, teacher: "ABC", subjectName: "D")
        let sE = Subject(dataManager: dataManager, className: "E", subjectType: nil, teacher: "DEF", subjectName: "E")
        let sPL = Subject(dataManager: dataManager, className: "PL", subjectType: nil, teacher: "JKL", subjectName: "PL")
        let expected = RepresentativePlan(date: .init(timeIntervalSince1970: 1635156420), representativeDays: [
            .init(date: date, lessons: [
                .init(date: date, lesson: 6, room: "PR2", newRoom: nil, note: "(frei)", subject: sPH, normalTeacher: "SEN", representativeTeacher: nil),
                .init(date: date, lesson: 7, room: "PR2", newRoom: nil, note: "(frei)", subject: sPH, normalTeacher: "SEN", representativeTeacher: nil),
                .init(date: date, lesson: 8, room: "130", newRoom: "A16", note: "Raumänderung", subject: sD, normalTeacher: "ABC", representativeTeacher: "DEF"),
                .init(date: date, lesson: 9, room: "124", newRoom: "E14", note: "Raumänderung", subject: sE, normalTeacher: "DEF", representativeTeacher: "GHI"),
                .init(date: date, lesson: 10, room: "124", newRoom: "E14", note: "Raumänderung", subject: sE, normalTeacher: "DEF", representativeTeacher: "GHI")
            ], notes: ["Test information"]),
            .init(date: date2, lessons: [
                .init(date: date2, lesson: 2, room: "130", newRoom: nil, note: nil, subject: sPL, normalTeacher: "JKL", representativeTeacher: "MNO")
            ], notes: [])
        ], lessons: [], notes: ["Another test information"])
        
        let result = RepresentativePlanParser.parse(plan: input, with: dataManager)
        
        XCTAssertEqual(try result.get(), expected)
    }
    
    func testParseBrokenServerResponse() throws {
        // This did happen (is happening)
        // Esp. note that these are repr lessons where I don't have any
        let input = """
<Vertretungsplan Stand="2021-12-13 12:36:00" Timestamp="1639395360">
<Vertretungstag Datum="Mittwoch, 15.12.2021">
<Stunde Std="1" Klasse="" Raum="" Fach="" RaumNeu="" Zeitstempel="" Bemerkung="" FLehrer="" VLehrer="ERD"/>
<Stunde Std="4" Klasse="" Raum="" Fach="" RaumNeu="" Zeitstempel="" Bemerkung="" FLehrer="" VLehrer="ERD"/>
<Stunde Std="5" Klasse="" Raum="" Fach="" RaumNeu="" Zeitstempel="" Bemerkung="" FLehrer="" VLehrer="ELV"/>
<Stunde Std="6" Klasse="" Raum="A11" Fach="ABC" RaumNeu="" Zeitstempel="" Bemerkung="(frei)" FLehrer="DEF" VLehrer=""/>
<Informationen> </Informationen>
</Vertretungstag>
<Informationen> </Informationen>
</Vertretungsplan>
"""
        let dataManager = MockDataManager()
        let date = Calendar(identifier: .gregorian).date(from: .init(timeZone: .init(identifier: "Europe/Berlin"), year: 2021, month: 12, day: 13, hour: 12, minute: 36))!
        let date2 = Calendar(identifier: .gregorian).date(from: .init(timeZone:  .init(identifier: "Europe/Berlin"), year: 2021, month: 12, day: 15))!
        let sABC = Subject(dataManager: dataManager, className: "ABC", subjectType: nil, teacher: "DEF", subjectName: "ABC")
        let expected = RepresentativePlan(date: date, representativeDays: [
            .init(date: date2, lessons: [
                .invalid,
                .invalid,
                .invalid,
                .init(date: date2, lesson: 6, room: "A11", newRoom: nil, note: "(frei)", subject: sABC, normalTeacher: "DEF", representativeTeacher: nil)
            ], notes: [])
        ], lessons: [], notes: [])
        
        let result = RepresentativePlanParser.parse(plan: input, with: dataManager)
        
        XCTAssertEqual(try result.get(), expected)
    }
    
    func testParseNoRootElement() {
        let result = RepresentativePlanParser.parse(plan: "", with: MockDataManager())
        XCTAssertEqual(result, .failure(.noRootElement))
    }
    
    func testParseInvalidRootElement() {
        let result = RepresentativePlanParser.parse(plan: "<Root></Root>", with: MockDataManager())
        XCTAssertEqual(result, .failure(.invalidRootElement))
    }
    
    func testParseNoTimestamp() {
        let result = RepresentativePlanParser.parse(plan: "<Vertretungsplan></Vertretungsplan>", with: MockDataManager())
        XCTAssertEqual(result, .failure(.noTimestamp))
    }
    
    func testParseInvalidTimestamp() {
        let plan = """
<Vertretungsplan Timestamp="2021-10-15T00:00:00Z"></Vertretungsplan>
"""
        
        let result = RepresentativePlanParser.parse(plan: plan, with: MockDataManager())
        
        XCTAssertEqual(result, .failure(.invalidTimestamp))
    }
}
