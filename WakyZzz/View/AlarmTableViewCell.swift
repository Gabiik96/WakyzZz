//
//  AlarmTableViewCell.swift
//  WakyZzz
//
//  Created by Olga Volkova on 2018-05-30.
//  Copyright © 2018 Olga Volkova OC. All rights reserved.
//

import Foundation
import UIKit

class AlarmTableViewCell: UITableViewCell {
    
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var subcaptionLabel: UILabel!
    @IBOutlet weak var enabledSwitch: UISwitch!
    
    var delegate: AlarmCellDelegate?
    var alarm: Alarm?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func populate(caption: String, subcaption: String, enabled: Bool, alarm: Alarm) {
        captionLabel.text = caption
        subcaptionLabel.text = subcaption
        enabledSwitch.isOn = enabled
        self.alarm = alarm
    }
    
    @IBAction func enabledStateChanged(_ sender: Any) {
        delegate?.alarmCell(self, enabledChanged: enabledSwitch.isOn)
    }

}
