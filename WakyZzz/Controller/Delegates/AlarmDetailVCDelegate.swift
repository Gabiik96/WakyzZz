//
//  AlarmDetailVCDelegate.swift
//  WakyZzz
//
//  Created by Gabriel Balta on 07/10/2020.
//  Copyright © 2020 Olga Volkova OC. All rights reserved.
//

import Foundation

protocol AlarmDetailVCDelegate {
    func alarmDetailVCDone(alarm: Alarm)
    func alarmDetailVCCancel()
}
