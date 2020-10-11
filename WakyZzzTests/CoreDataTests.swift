//
//  WakyZzzTests.swift
//  WakyZzzTests
//
//  Created by Gabriel Balta on 11/10/2020.
//  Copyright © 2020 Olga Volkova OC. All rights reserved.
//

import XCTest
@testable import WakyZzz

class CoreDataTests: XCTestCase {
    
    var coreData: CoreDataManager!
    private let context = AppDelegate.context
    
    override func setUp() {
        self.coreData = CoreDataManager.shared
        
        coreData.removeAllAlarms()
    }
    
    func testSavingNewAlarm() {
        let alarm = Alarm()
        alarm.id = "11"
        alarm.time = 99600
        alarm.isEvilOn = true
        
        coreData.createAlarm(alarm)
        XCTAssert(coreData.fetchSingleAlarm(id: alarm.id, in: self.context) != nil, "Failed to fetch/create alarm")
    }
    
    func testUpdatingAlarm() {
        let alarm = Alarm()
        alarm.id = "11"
        alarm.time = 99600
        alarm.isEvilOn = true
        coreData.createAlarm(alarm)
        
        let alarm1 = Alarm()
        alarm1.id = "11"
        alarm1.time = 56000
        coreData.updateAlarm(alarm1)
        
        XCTAssert(coreData.fetchSingleAlarm(id: "11", in: self.context)?.time == 56000, "Failed to fetch/update alarm")
        
    }
    
    func testDeletingSingleAlarm() {
        let alarm = Alarm()
        alarm.id = "11"
        coreData.createAlarm(alarm)
    
        XCTAssert(coreData.fetchAllAlarms().count != 0, "Failed, there should be alarms to delete")
        
        coreData.removeAlarm(alarm)
        
        XCTAssert(coreData.fetchAllAlarms().count == 0, "Failed to delete all alarms")
        
    }
    func testDeletingAllAlarms() {
        let alarm = Alarm()
        alarm.id = "11"
        coreData.createAlarm(alarm)
        let alarm2 = Alarm()
        alarm2.id = "22"
        coreData.createAlarm(alarm2)
    
        XCTAssert(coreData.fetchAllAlarms().count != 0, "Failed, there should be alarms to delete")
        
        coreData.removeAllAlarms()
        
        XCTAssert(coreData.fetchAllAlarms().count == 0, "Failed to delete all alarms")
        
    }

    func testToggleAlarm() {
        
        let alarm = Alarm()
        alarm.enabled = true
        
        coreData.createAlarm(alarm)
        XCTAssert(coreData.fetchAllAlarms().first?.isActive == true, "Alarm failed")
        
        alarm.enabled = false
        coreData.updateAlarm(alarm)
        XCTAssert(coreData.fetchAllAlarms().first?.isActive == false, "Alarm toggle failed")
        
    }
    
    
}
