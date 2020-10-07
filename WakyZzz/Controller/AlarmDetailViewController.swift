//
//  AlarmViewController.swift
//  WakyZzz
//
//  Created by Olga Volkova on 2018-05-30.
//  Copyright © 2018 Olga Volkova OC. All rights reserved.
//

import Foundation
import UIKit

class AlarmDetailViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var tableView: UITableView!
    
    // Properties
    var alarm: Alarm?
    var delegate: AlarmDetailVCDelegate?
    
    let coreData = CoreDataManager()
    
    // VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    
    // Will configuration current VC with alarm
    func config() {        
        if alarm == nil {
            navigationItem.title = "New Alarm"
            alarm = Alarm()
            // Save new alarm into CoreData
            coreData.createAlarm(alarm!)
        }
        else {
            navigationItem.title = "Edit Alarm"
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        datePicker.date = (alarm?.alarmDate)!
    }
    
    // MARK: - IBActions
    @IBAction func cancelButtonPress(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonPress(_ sender: Any) {
        delegate?.alarmDetailVCDone(alarm: alarm!)
        presentingViewController?.dismiss(animated: true, completion: nil)
        // update model in coreData
        if self.alarm != nil {
            coreData.updateAlarm(self.alarm!)
        }
    }
    @IBAction func datePickerValueChanged(_ sender: Any) {
        alarm?.setTime(date: datePicker.date)
    }
    
}

//MARK: - Extensions

extension AlarmDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Repeat on following weekdays"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        alarm?.repeatDays[indexPath.row] = true
        tableView.cellForRow(at: indexPath)?.accessoryType = (alarm?.repeatDays[indexPath.row])! ? .checkmark : .none
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        alarm?.repeatDays[indexPath.row] = false
        tableView.cellForRow(at: indexPath)?.accessoryType = (alarm?.repeatDays[indexPath.row])! ? .checkmark : .none
    }
}

extension AlarmDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Alarm.daysOfWeek.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DayOfWeekCell", for: indexPath)
        cell.textLabel?.text = Alarm.daysOfWeek[indexPath.row]
        cell.accessoryType = (alarm?.repeatDays[indexPath.row])! ? .checkmark : .none
        if (alarm?.repeatDays[indexPath.row])! {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
        return cell
    }
}
