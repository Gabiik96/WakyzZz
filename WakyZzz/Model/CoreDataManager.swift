//
//  CoreDataManager.swift
//  WakyZzz
//
//  Created by Gabriel Balta on 07/10/2020.
//  Copyright © 2020 Olga Volkova OC. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    //MARK: - Fetching data methods
    
    /// Will get all alarms from coredata
    public func fetchAllAlarms() -> [AlarmEntity] {
        
        let fetchRequest: NSFetchRequest<AlarmEntity> = AlarmEntity.fetchRequest()
        
        var currentFetch: [AlarmEntity] = []
        
        do {
            currentFetch = try AppDelegate.context.fetch(fetchRequest)
        } catch {
            let fetchError = error as NSError
            print("Coredata fetching error: \(fetchError)")
        }
        return currentFetch
    }
    
    /// Will get all alarms from coredata with  correspoding ID
    public func fetchAlarms(id: UUID, in context: NSManagedObjectContext) -> [AlarmEntity] {
        
        let fetchRequest: NSFetchRequest<AlarmEntity> = AlarmEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", id as CVarArg)
        
        var currentFetch: [AlarmEntity] = []
        
        do {
            currentFetch = try context.fetch(fetchRequest)
        } catch {
            let fetchError = error as NSError
            print("Coredata fetching error: \(fetchError)")
        }
        return currentFetch
    }
    
    /// Will get single alarm from coredata with corresponding ID
    public func fetchSingleAlarm(id: UUID, in context: NSManagedObjectContext) -> AlarmEntity? {
        
        let fetchRequest: NSFetchRequest<AlarmEntity> = AlarmEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", id as CVarArg)
        
        do {
            let currentFetch = try context.fetch(fetchRequest)
            return currentFetch.first
        } catch {
            let fetchError = error as NSError
            print("Coredata fetching error: \(fetchError)")
        }
        return nil
    }
    
    //MARK: - Data manipulation methods
    public func createAlarm(_ alarm: Alarm) {
        
        let context = AppDelegate.context
        
        
    }
}
