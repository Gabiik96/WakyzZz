//
//  AlarmsViewController.swift
//  WakyZzz
//
//  Created by Olga Volkova on 2018-05-30.
//  Copyright © 2018 Olga Volkova OC. All rights reserved.
//

import UIKit

class AlarmsViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    // Properties
    public var alarms = [Alarm]()
    
    private let coreData = CoreDataManager()
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
    }
    
    private func alarm(at indexPath: IndexPath) -> Alarm? {
        return indexPath.row < alarms.count ? alarms[indexPath.row] : nil
    }
    
    private func deleteAlarm(at indexPath: IndexPath) {
        
        let alarm = alarms[indexPath.row]
        coreData.removeAlarm(alarm)
        
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
    }
    
    private func sortAlarmsByTime() {
        alarms.sort(by: { $0.time < $1.time })
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
                cell.populate(caption: alarm.caption, subcaption: alarm.repeating, enabled: alarm.enabled)
            }
            return cell
        }
    }






