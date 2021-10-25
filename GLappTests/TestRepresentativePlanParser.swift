//
//  TestRepresentativePlanParser.swift
//  TestRepresentativePlanParser
//
//  Created by Miguel Themann on 09.10.21.
//

import XCTest
@testable import GLapp

class TestRepresentativePlanParser: XCTestCase {
    func testParseEmpty() throws {
        let input = """
<Vertretungsplan Stand="2000-01-01 00:00:00" Timestamp="946681200">
<Vertretungstag/>
<Informationen> </Informationen>
</Vertretungsplan>
"""
        let expected = RepresentativePlan(date: .init(timeIntervalSince1970: 946681200), representativeDays: [], lessons: [], notes: [])
        
        let result = RepresentativePlanParser.parse(plan: input, with: MockDataManager())
        
        XCTAssertEqual(try result.get(), expected)
    }
    
    func testParseSuccess() throws {
        let input = """
<Vertretungsplan Stand="2021-10-25 12:07:00" Timestamp="1635156420"><Vertretungstag Datum="Montag, 25.10.2021"></Vertretungstag><Vertretungstag Datum="Dienstag, 26.10.2021"><Stunde Std="6" \n\t\t\t\t\t\t\t\tKlasse="Q2" \n\t\t\t\t\t\t\t\tRaum="PR2" \n\t\t\t\t\t\t\t\tFach="PH" RaumNeu="" Zeitstempel="" Bemerkung="(frei)" FLehrer="SEN" VLehrer=""></Stunde><Stunde Std="7" \n\t\t\t\t\t\t\t\tKlasse="Q2" \n\t\t\t\t\t\t\t\tRaum="PR2" \n\t\t\t\t\t\t\t\tFach="PH" RaumNeu="" Zeitstempel="" Bemerkung="(frei)" FLehrer="SEN" VLehrer=""></Stunde>\t\t\t<Informationen>\n\t\t\t\t\t\tTest information</Informationen>\n</Vertretungstag>\t\t\t<Informationen>\n\t\t\tAnother test information\t\t\t</Informationen>\n\t\t\t\n\t\t\t</Vertretungsplan>\n\t\t\t\n\t\t\t
"""
        let dataManager = MockDataManager()
        let date = Calendar(identifier: .gregorian).date(from: .init(timeZone: .init(identifier: "Europe/Berlin"), year: 2021, month: 10, day: 26))!
        let sPH = Subject(dataManager: dataManager, className: "PH", subjectType: nil, teacher: "SEN", subjectName: "PH")
        let expected = RepresentativePlan(date: .init(timeIntervalSince1970: 1635156420), representativeDays: [.init(date: date, lessons: [.init(date: date, lesson: 6, room: "PR2", newRoom: nil, note: "(frei)", subject: sPH, normalTeacher: "SEN", representativeTeacher: nil), .init(date: date, lesson: 7, room: "PR2", newRoom: nil, note: "(frei)", subject: sPH, normalTeacher: "SEN", representativeTeacher: nil)], notes: ["Test information"])], lessons: [], notes: ["Another test information"])
        
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
