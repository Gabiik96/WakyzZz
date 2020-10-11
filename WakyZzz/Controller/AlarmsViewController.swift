//
//  AlarmsViewController.swift
//  WakyZzz
//
//  Created by Olga Volkova on 2018-05-30.
//  Copyright © 2018 Olga Volkova OC. All rights reserved.
//

import UIKit
import UserNotifications

class AlarmsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    // Properties
    public var alarms = [Alarm]()
    private let actOfKindness = ["Message a friend asking how they are doing.",
                                 "Connect with a family member by expressing a kind thought.",
                                 "Water your plants."]
    
    private let notificationCenter = UNUserNotificationCenter.current()
    private let options: UNAuthorizationOptions = [.alert, .sound, .badge]
    
    private let coreData = CoreDataManager()
    private let audioPlayer = AudioPlayerManager()
    private var editingIndexPath: IndexPath?
    
    @IBAction func addButtonPress(_ sender: Any) {
        presentAlarmViewController(alarm: nil)
    }
    
    
    // VC lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        config()
    }
    
    private func config() {
        tableView.delegate = self
        tableView.dataSource = self
        
        // config with coreData
        let data = coreData.fetchAllAlarms()
        alarms = data.map { $0.convertToAlarm() }
        sortAlarmsByTime()
        
        // refresh ui
        tableView.reloadData()
        
        // display alert asking for permission
        notificationCenter.requestAuthorization(options: options) {
            (didAllow, error) in
            if !didAllow {
                print("User has declined notifications")
            } else {
                UNUserNotificationCenter.current().delegate = self
            }
        }
    }
    
    // MARK: - Alarm methods
    private func alarm(at indexPath: IndexPath) -> Alarm? {
        return indexPath.row < alarms.count ? alarms[indexPath.row] : nil
    }
    
    private func deleteAlarm(at indexPath: IndexPath) {
        
        let alarm = alarms[indexPath.row]
        
        // remove from coredata
        coreData.removeAlarm(alarm)
        // remove from notifications centre
        AlertManager.notifCancel(alarm)
        
        // remove from UI and update UI
        tableView.beginUpdates()
        alarms.remove(at: alarms.count - 1)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
    
    private func editAlarm(at indexPath: IndexPath) {
        editingIndexPath = indexPath
        presentAlarmViewController(alarm: alarm(at: indexPath))
    }
    
    private func addAlarm(_ alarm: Alarm, at indexPath: IndexPath) {
        tableView.beginUpdates()
        alarms.insert(alarm, at: indexPath.row)
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
        scheduleNotifByAlarm(alarm: alarm)
    }
    
    private func sortAlarmsByTime() {
        alarms.sort(by: { $0.time < $1.time })
    }
    
    // MARK: - Notifications methods
    func scheduleNotifByAlarm(alarm: Alarm) {
        let alertManager = AlertManager(alarm)
        alertManager.notifSetup()
    }
    
    func presentSnoozeAlert(from alarm: Alarm) {
        let alert = UIAlertController(title: "Alarm! \(alarm.caption)", message: "Time to wake up!", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Snooze", style: .default, handler: { (_) in
            AlertManager.notifCancel(alarm)
            
            // Checking how many times user snoozed and changing alarm to Evil if 2
            if alarm.snoozed == 0 {
                alarm.snoozed += 1
            } else if alarm.snoozed == 1 {
                alarm.snoozed += 1
                alarm.isEvilOn = true
            }
            
            alarm.snoozeAlarm()
            let manager = AlertManager(alarm)
            manager.notifSetup()
            self.audioPlayer.stopSound()
            self.tableView.reloadData()
        }))
        
        alert.addAction(UIAlertAction(title: "Stop", style: .cancel, handler: { (_) in
            alarm.setToOrigin()
            alarm.snoozed = 0
            self.audioPlayer.stopSound()
            
            if alarm.repeatDays.allSatisfy({$0 == false }) {
                alarm.enabled = false
                self.tableView.reloadData()
            }
        }))
        
        self.present(alert, animated: true, completion: {
            if alarm.snoozed < 2 {
                self.audioPlayer.playSound(evilOn: false)
            }
        })
    }
    
    func presentEvilAlert(from alarm: Alarm) {
        let randomMessage = actOfKindness.randomElement()
        let alert = UIAlertController(title: "Restore karma level !", message: randomMessage, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Promise", style: .default, handler: { (_) in
            let manager = KarmaManager(date: alarm.alarmDate!, message: randomMessage!)
            manager.notifSetup()
            self.audioPlayer.stopSound()
        }))
        
        alert.addAction(UIAlertAction(title: "Complete", style: .cancel, handler: { (_) in

            self.audioPlayer.stopSound()
        }))
        
        self.present(alert, animated: true, completion: {
            self.audioPlayer.playSound(evilOn: true)
            // reset alarm from snoozing changes
            alarm.setToOrigin()
            alarm.snoozed = 0
            
            // Turn alarm off if one time type
            if alarm.repeatDays.allSatisfy({$0 == false }) {
                alarm.enabled = false
                self.tableView.reloadData()
            } else {
                AlertManager.notifCancel(alarm)
                let manager = AlertManager(alarm)
                manager.notifSetup()
            }
        })
    }
    
    
    /// navigate to editing VC
    func presentAlarmViewController(alarm: Alarm?) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let popupViewController = storyboard.instantiateViewController(withIdentifier: "DetailNavigationController") as! UINavigationController
        let alarmDetailVC = popupViewController.viewControllers[0] as! AlarmDetailViewController
        alarmDetailVC.alarm = alarm
        alarmDetailVC.delegate = self
        present(popupViewController, animated: true, completion: nil)
    }
    
    
    
}

//MARK: - Extensions
extension AlarmsViewController: AlarmDetailVCDelegate {
    
    func alarmDetailVCDone(alarm: Alarm) {
        
        coreData.updateAlarm(alarm)
        
        if let editingIndexPath = editingIndexPath {
            AlertManager.notifCancel(alarm)
            
            let manager = AlertManager(alarm)
            manager.notifSetup()
            
            tableView.reloadRows(at: [editingIndexPath], with: .automatic)
        }
        else {
            addAlarm(alarm, at: IndexPath(row: alarms.count, section: 0))
        }
        editingIndexPath = nil
        
        sortAlarmsByTime()
        tableView.reloadData()
    }
    
    func alarmDetailVCCancel() {
        editingIndexPath = nil
    }
}

extension AlarmsViewController: AlarmCellDelegate {
    
    func alarmCell(_ cell: AlarmTableViewCell, enabledChanged enabled: Bool) {
        if let indexPath = tableView.indexPath(for: cell) {
            if let alarm = self.alarm(at: indexPath) {
                alarm.enabled = enabled
                coreData.updateAlarm(alarm)
                
                
                if cell.alarm != nil {
                    if enabled == false {
                        AlertManager.notifCancel(cell.alarm!)
                    } else {
                        let manager = AlertManager(alarm)
                        manager.notifSetup()
                    }
                }
            }
        }
    }
}

extension AlarmsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.deleteAlarm(at: indexPath)
        }
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            self.editAlarm(at: indexPath)
        }
        return [delete, edit]
    }
}

extension AlarmsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmCell", for: indexPath) as! AlarmTableViewCell
        cell.delegate = self
        if let alarm = alarm(at: indexPath) {
            cell.populate(caption: alarm.caption, subcaption: alarm.repeating, enabled: alarm.enabled, alarm: alarm)
        }
        return cell
    }
}

extension AlarmsViewController: UNUserNotificationCenterDelegate {
    
    func handleNotif(id: String) {
        let alarm = alarms.first(where: {$0.id == id})
       
            if alarm?.isEvilOn == true {
                presentEvilAlert(from: alarm!)
            } else {
                presentSnoozeAlert(from: alarm!)
            }
    }
    
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        if let id = userInfo["alarmID"] as? String {
            handleNotif(id: id)
        }
        return
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if let id = userInfo["alarmID"] as? String {
            handleNotif(id: id)
        }
        completionHandler()
    }
}

