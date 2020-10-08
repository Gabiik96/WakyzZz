//
//  Alarm.swift
//  WakyZzz
//
//  Created by Olga Volkova on 2018-05-30.
//  Copyright © 2018 Olga Volkova OC. All rights reserved.
//

import Foundation 

public class Alarm { 
    
    static let daysOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    var id = UUID().uuidString
    var time = 8 * 3600
    var repeatDays = [false, false, false, false, false, false, false]
    var enabled = true
    var snoozed = 0
    var isEvilOn = false
    
    var alarmDate: Date? {
        let date = Date()
        let calendar = Calendar.current
        let h = time/3600
        let m = time/60 - h * 60
        
        var components = calendar.dateComponents([.hour, .minute, .month, .year, .day, .second, .weekOfMonth], from: date as Date)
        
        components.hour = h
        components.minute = m
        
        return calendar.date(from: components)
    }
    
    var caption: String {        
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: self.alarmDate!)
    }
    
    var repeating: String {
        var captions = [String]()
        for i in 0 ..< repeatDays.count {
            if repeatDays[i] {
                captions.append(Alarm.daysOfWeek[i])
            }
        }
        return captions.count > 0 ? captions.joined(separator: ", ") : "One time alarm"
    }
    
    func setTime(date: Date) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .month, .year, .day, .second, .weekOfMonth], from: date as Date)
        
        time = components.hour! * 3600 + components.minute! * 60        
    }
    
    func snoozeAlarm() {
        let calendar = Calendar.current
        let oldComponents = calendar.dateComponents([.hour, .minute, .month, .year, .day, .second, .weekOfMonth], from: alarmDate! as Date)
        var newComponents = oldComponents
        newComponents.minute! += 5
        
        setTime(date: calendar.date(from: newComponents)!)
    }
    
    func setToOrigin() {
        let calendar = Calendar.current
        let oldComponents = calendar.dateComponents([.hour, .minute, .month, .year, .day, .second, .weekOfMonth], from: alarmDate! as Date)
        var newComponents = oldComponents
        
        if self.snoozed == 0 {
            setTime(date: alarmDate!)
        } else if self.snoozed == 1 {
            newComponents.minute! -= 5
            setTime(date: calendar.date(from: newComponents)!)
        } else if self.snoozed == 2 {
            newComponents.minute! -= 10
            setTime(date: calendar.date(from: newComponents)!)
        }
    }
}
