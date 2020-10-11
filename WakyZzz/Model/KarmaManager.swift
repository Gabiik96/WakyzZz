//
//  KarmaManager.swift
//  WakyZzz
//
//  Created by Gabriel Balta on 08/10/2020.
//  Copyright © 2020 Olga Volkova OC. All rights reserved.
//

import UIKit

class KarmaManager {
    
    // Properties
    let id = UUID().uuidString
    let date: Date
    let calendar = Calendar.current
    
    // Notifications related
    let notifBase = UNUserNotificationCenter.current()
    let notifContent = UNMutableNotificationContent()
    var notifTrigger: UNCalendarNotificationTrigger?

    
    init(date: Date, message: String) {
        var components = calendar.dateComponents([.hour, .minute, .month, .year, .day], from: date)
        
        // Deployment value
//        components.hour = components.hour! + 3
        // Test value
        components.minute = components.minute! + 5
    
        self.date = calendar.date(from: components)!
        self.notifContent.title = "Karma is coming !"
        self.notifContent.body = message
        self.notifTrigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
    }
    
    func notifSetup() {
        let request = UNNotificationRequest(identifier: id, content: notifContent, trigger: notifTrigger)
        notifBase.add(request) { (error) in
            if error != nil { print("Failed to create 'karma' notification !") }
        }
    }
    
}
