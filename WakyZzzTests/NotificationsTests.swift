//
//  NotificationsTests.swift
//  WakyZzz
//
//  Created by Gabriel Balta on 11/10/2020.
//  Copyright © 2020 Olga Volkova OC. All rights reserved.
//

import XCTest
@testable import WakyZzz

class NotificationsTests: XCTestCase {
    
    let notifBase = UNUserNotificationCenter.current()
    let alarm = Alarm()
    var notificationID = ""
    var repeatedDayID = ""
    
    func testNotifSetup() {
        
        let date = Date()
        let calendar = Calendar.current
        var components = calendar.dateComponents([.hour, .minute, .month, .year, .day, .second, .weekOfMonth], from: date as Date)
        components.hour = components.hour! + 1
        alarm.setTime(date: calendar.date(from: components)!)
        
        let manager = AlertManager(alarm)
        manager.notifSetup()
        
        notifBase.getPendingNotificationRequests { (notificationRequests) in
            for notificationRequest:UNNotificationRequest in notificationRequests {
                if notificationRequest.identifier == self.alarm.id {
                    self.notificationID = notificationRequest.identifier
                }
            }
            XCTAssert(self.notificationID == self.alarm.id, "Failed to get notification for alarm")
            self.notifBase.removeAllPendingNotificationRequests()
        }
    }
    
    
    func testNotificationRemoval() {
        
        let manager = AlertManager(alarm)
        manager.notifSetup()
        
        notifBase.getPendingNotificationRequests { (notificationRequests) in
            for notificationRequest:UNNotificationRequest in notificationRequests {
                if notificationRequest.identifier == self.alarm.id{
                    self.notificationID = notificationRequest.identifier
                }
            }
            XCTAssert(self.notificationID == self.alarm.id, "Failed, should have a notification in order to delete one")
        }
        
        AlertManager.notifCancel(alarm)
        
        notifBase.getPendingNotificationRequests { (notificationRequests) in
            for notificationRequest:UNNotificationRequest in notificationRequests {
                if notificationRequest.identifier == self.alarm.id {
                    self.notificationID = notificationRequest.identifier
                }
            }
            XCTAssert(self.notificationID != self.alarm.id)
            self.notifBase.removeAllPendingNotificationRequests()
        }
    }
    
    func testKarmaNotificationSetup() {
        
        let date = Date()
        let calendar = Calendar.current
        var components = calendar.dateComponents([.hour, .minute, .month, .year, .day, .second, .weekOfMonth], from: date as Date)
        components.hour = components.hour! + 1
        alarm.setTime(date: calendar.date(from: components)!)
        
        let manager = KarmaManager(date: calendar.date(from: components)!, message: "Test message")
        manager.notifSetup()
        
        notifBase.getPendingNotificationRequests { (notificationRequests) in
            for notificationRequest:UNNotificationRequest in notificationRequests {
                if notificationRequest.identifier == manager.id {
                    self.notificationID = notificationRequest.identifier
                }
            }
            XCTAssert(self.notificationID == self.alarm.id, "Failed to get notification for alarm")
            self.notifBase.removeAllPendingNotificationRequests()
        }
        
    }
    
}
