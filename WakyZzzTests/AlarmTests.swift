//
//  AlarmTests.swift
//  WakyZzzTests
//
//  Created by Gabriel Balta on 11/10/2020.
//  Copyright © 2020 Olga Volkova OC. All rights reserved.
//

import XCTest
@testable import WakyZzz

class AlarmTests: XCTestCase {
    
    func testAlarmSnooze() {
        let alarm = Alarm()
        let date = Date()
        let calendar = Calendar.current
        
        var components = calendar.dateComponents([.hour, .minute, .month, .year, .day, .second, .weekOfMonth], from: date as Date)
        components.hour = 5
        components.minute = 20
        alarm.setTime(date: calendar.date(from: components)!)
        
        let timeBeforeSnooze = calendar.dateComponents([.hour, .minute], from: alarm.alarmDate!)
        
        alarm.snoozeAlarm()
        
        let timeAfterSnooze = calendar.dateComponents([.hour, .minute], from: alarm.alarmDate!)
        
        XCTAssert(timeBeforeSnooze.hour == timeAfterSnooze.hour,
                  "Failed, hour should match")
        XCTAssert(timeBeforeSnooze.minute == (timeAfterSnooze.minute! - 10),
                  "Failed, minute - 5 should be original time of alarm")
        
        alarm.snoozeAlarm()
        
        let timeAfterSecondSnooze = calendar.dateComponents([.hour, .minute], from: alarm.alarmDate!)
        
        XCTAssert(timeBeforeSnooze.hour == timeAfterSecondSnooze.hour,
                  "Failed, hour should match")
        XCTAssert(timeBeforeSnooze.minute == (timeAfterSecondSnooze.minute! - 20),
                  "Failed, minute - 10 should be original time of alarm")
        
        // Test for snoozed with hour change
        components.hour = 11
        components.minute = 55
        alarm.setTime(date: calendar.date(from: components)!)
        
        let timeBefoSnooHourChange = calendar.dateComponents([.hour, .minute], from: alarm.alarmDate!)
        
        alarm.snoozeAlarm()
        
        let timeAftSnooHourChange = calendar.dateComponents([.hour, .minute], from: alarm.alarmDate!)
        
        XCTAssert(timeBefoSnooHourChange.hour != timeAftSnooHourChange.hour,
                  "Failed, hour should not match")
        XCTAssert(timeBefoSnooHourChange.minute != timeAftSnooHourChange.minute,
                  "Failed, minutes should not match")
    }
    
    func testAlarmToOrigin() {
        let alarm = Alarm()
        let date = Date()
        let calendar = Calendar.current
        
        var components = calendar.dateComponents([.hour, .minute, .month, .year, .day, .second, .weekOfMonth], from: date as Date)
        components.hour = 5
        components.minute = 20
        alarm.setTime(date: calendar.date(from: components)!)
        alarm.snoozed = 0
        
        let originalTime = calendar.dateComponents([.hour, .minute], from: alarm.alarmDate!)
        
        alarm.snoozeAlarm()
        alarm.snoozed = 1
        
        var changedTime = calendar.dateComponents([.hour, .minute], from: alarm.alarmDate!)
        
        XCTAssert(originalTime != changedTime, "Times should not match")
        
        alarm.setToOrigin()
        changedTime = calendar.dateComponents([.hour, .minute], from: alarm.alarmDate!)
        
        XCTAssert(originalTime == changedTime, "After setToOrigin(),  times should match")
    }
    
    func testDefaultAlarm() {
        let alarm = Alarm()
        let calendar = Calendar.current
        let defaultTime = alarm.setDefaultTime()
        
        alarm.setTime(date: defaultTime)
        
        let hour = calendar.component(.hour, from: defaultTime)
        let minutes = calendar.component(.minute, from: defaultTime)
        
        XCTAssert(hour == 8, "Failed hour, client requirement was 8:00 default time")
        XCTAssert(minutes == 00, "Failed minutes, client requirement was 8:00 default time")
        XCTAssert(alarm.caption == "8:00 AM", "Failed, caption should transform Date into string 'HH:MM AM/PM' ")
    }
}
