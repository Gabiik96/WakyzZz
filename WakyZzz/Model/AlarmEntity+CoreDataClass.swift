//
//  AlarmEntity+CoreDataClass.swift
//  WakyZzz
//
//  Created by Gabriel Balta on 07/10/2020.
//  Copyright © 2020 Olga Volkova OC. All rights reserved.
//
//

import Foundation
import CoreData


public class AlarmEntity: NSManagedObject {
    
    //MARK: - Data merging methods
    
    ///Will update coredata AlarmEntity model properties by Alarm model
    public func updateBy(alarm: Alarm) {
        self.id = alarm.id
        self.isActive = alarm.enabled
        self.time = Int32(alarm.time)
        self.monOn = alarm.repeatDays[1]
        self.tueOn = alarm.repeatDays[2]
        self.wedOn = alarm.repeatDays[3]
        self.thuOn = alarm.repeatDays[4]
        self.friOn = alarm.repeatDays[5]
        self.satOn = alarm.repeatDays[6]
        self.sunOn = alarm.repeatDays[0]
    }
    
    public func convertToAlarm() -> Alarm {
        
        let alarm = Alarm()
        alarm.id = self.id
        alarm.enabled = self.isActive
        alarm.time = Int(self.time)
        alarm.repeatDays = [ self.sunOn, self.monOn, self.tueOn, self.wedOn,
                             self.thuOn, self.friOn, self.satOn ]
        
        return alarm
    }
    
    
}
