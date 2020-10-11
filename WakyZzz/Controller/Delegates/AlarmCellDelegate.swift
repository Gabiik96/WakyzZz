//
//  AlarmTableViewCell.swift
//  WakyZzz
//
//  Created by Gabriel Balta on 07/10/2020.
//  Copyright © 2020 Olga Volkova OC. All rights reserved.
//

import Foundation

protocol AlarmCellDelegate {
    func alarmCell(_ cell: AlarmTableViewCell, enabledChanged enabled: Bool)
}


