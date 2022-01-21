//
//  MockDataManager.swift
//  MockDataManager
//
//  Created by Miguel Themann on 09.10.21.
//

import Foundation

#if DEBUG
class MockDataManager: DataManager {
    /// For testing behavior in secondary stage I and transitions from stage I to II
    let sendEmptyClassTestPlan: Bool
    
    init(appManager: AppManager, sendEmptyClassTestPlan: Bool) {
        self.sendEmptyClassTestPlan = sendEmptyClassTestPlan
        super.init(appManager: appManager)
    }
    
    init() {
        self.sendEmptyClassTestPlan = false
        super.init(appManager: .init())
    }
    
    override func getRepresentativePlan(completion: @escaping (NetworkResult<String, NetworkError>) -> Void) {
        let plan = """
<Vertretungsplan Stand="2000-01-01 00:00:00" Timestamp="946681200">
<Vertretungstag Datum="Montag, 17.01.2022">
<Stunde Std="2" Kurs="IF-GK1" Raum="121" Fach="IF" RaumNeu="" Zeitstempel="" Bemerkung="(frei)" FLehrer="NFD" VLehrer=""/>
</Vertretungstag>
<Informationen> </Informationen>
</Vertretungsplan>
"""
        completion(.successWithData(plan))
    }
    
    override func getTimetable(completion: @escaping (NetworkResult<String, NetworkError>) -> Void) {
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
        completion(.successWithData(timetable))
    }
    
    override func getClassTestPlan(completion: @escaping (NetworkResult<String, NetworkError>) -> Void) {
        if sendEmptyClassTestPlan {
            return completion(.successWithData(MockData.emptyClassTestPlanString))
        }
        let plan = """
<Klausurplan Stand="29.09.2021 08:55:04" Timestamp="1632898504">
<Klausur individuell="1" Datum="26.10.2021" freigegeben="0" vonStd="-" bisStd="-" raum="-" bezeichnung="D-GK3" fach="D" stand="2021-09-29 08:55:04" lehrer="DRO"/>
<Klausur individuell="1" Datum="29.10.2021" freigegeben="0" vonStd="-" bisStd="-" raum="-" bezeichnung="PH-LK1" fach="PH" stand="2021-09-29 08:55:05" lehrer="SEN"/>
<Klausur individuell="1" Datum="02.11.2021" freigegeben="0" vonStd="-" bisStd="-" raum="-" bezeichnung="SW-GK1" fach="SW" stand="2021-09-29 08:55:05" lehrer="HBS"/>
<Klausur individuell="1" Datum="08.11.2021" freigegeben="0" vonStd="-" bisStd="-" raum="-" bezeichnung="E-GK1" fach="E" stand="2021-09-29 08:55:06" lehrer="ERD"/>
<Klausur individuell="1" Datum="29.11.2021" freigegeben="0" vonStd="-" bisStd="-" raum="-" bezeichnung="IF-GK1" fach="IF" stand="2021-09-29 08:55:07" lehrer="NFD"/>
<Klausur individuell="1" Datum="01.12.2021" freigegeben="0" vonStd="-" bisStd="-" raum="-" bezeichnung="M-LK2" fach="M" stand="2021-09-29 08:55:07" lehrer="PST"/>
<Klausur individuell="1" Datum="07.12.2021" freigegeben="0" vonStd="-" bisStd="-" raum="-" bezeichnung="D-GK3" fach="D" stand="2021-09-29 08:55:08" lehrer="DRO"/>
<Klausur individuell="1" Datum="10.12.2021" freigegeben="0" vonStd="-" bisStd="-" raum="-" bezeichnung="PH-LK1" fach="PH" stand="2021-09-29 08:55:09" lehrer="SEN"/>
<Klausur individuell="1" Datum="14.12.2021" freigegeben="0" vonStd="-" bisStd="-" raum="-" bezeichnung="SW-GK1" fach="SW" stand="2021-09-29 08:55:09" lehrer="HBS"/>
<Klausur individuell="1" Datum="20.12.2021" freigegeben="0" vonStd="-" bisStd="-" raum="-" bezeichnung="E-GK1" fach="E" stand="2021-09-29 08:55:10" lehrer="ERD"/>
<Klausur individuell="0" Datum="19.11.2021" freigegeben="0" vonStd="-" bisStd="-" raum="-" bezeichnung="Nachschrift 1.1" fach="-" stand="2021-10-06 12:57:35" lehrer="-"/>
</Klausurplan>
"""
        completion(.successWithData(plan))
    }
}

#endif
