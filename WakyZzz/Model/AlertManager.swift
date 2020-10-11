//
//  AlarmManager.swift
//  WakyZzz
//
//  Created by Gabriel Balta on 08/10/2020.
//  Copyright © 2020 Olga Volkova OC. All rights reserved.
//

import UIKit

class AlertManager {
    
    // Properties
    var id: String
    var alarm: Alarm
    
    let calendar = Calendar.current
    
    // Notifications related
    let notifBase = UNUserNotificationCenter.current()
    let notifContent = UNMutableNotificationContent()
    
    var notifTrigger: UNCalendarNotificationTrigger?
    
    init(_ alarm: Alarm) {
        self.id = alarm.id
        self.alarm = alarm
        
        self.notifContent.title = "Time to wake up !"
        self.notifContent.userInfo = [ "alarmID": "\(alarm.id)" ]
        
        // Adding sound effect
        if alarm.isEvilOn == true {
            self.notifContent.sound = UNNotificationSound(named: UNNotificationSoundName("evilsound.mp3"))
        } else {
        self.notifContent.sound = UNNotificationSound(named: UNNotificationSoundName("sound.mp3"))
        }
    }
    
    // Method to set up alarm notifications on all days supposed
    func notifSetup() {
        if alarm.repeatDays.allSatisfy({$0 == false }) {
            let components = calendar.dateComponents([.hour, .minute, .month, .year, .day], from: alarm.alarmDate!)
            self.notifTrigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            scheduleNotification(id: id, trigger: notifTrigger!)
        } else {
            for day in 0..<alarm.repeatDays.count {
                if alarm.repeatDays[day] == true {
                    let repeatingID = "\(id)_weekday\(day + 1)"
                    
                    var components = calendar.dateComponents([.hour, .minute, .weekday], from: alarm.alarmDate! as Date)
                    components.weekday = day + 1
                    
                    self.notifTrigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
                    scheduleNotification(id: repeatingID, trigger: notifTrigger!)
                }
            }
        }
    }
    
    fileprivate func scheduleNotification(id: String, trigger: UNCalendarNotificationTrigger) {
        let request = UNNotificationRequest(identifier: id, content: notifContent, trigger: trigger)
        notifBase.add(request) { (error) in
            if error != nil { print("Failed to create notification !") }
        }
    }
    
    
    static func notifCancel(_ alarm: Alarm) {
        let notificationCenter = UNUserNotificationCenter.current()
        
        // ID for removal.
        var ids = [String]()
        ids.append(alarm.id)
        
        // Remove all weekdays of alarm
        for day in 1...7 { ids.append("\(alarm.id)_weekday\(day)") }
        
        notificationCenter.removePendingNotificationRequests(withIdentifiers: ids)
    }
    
    
}
