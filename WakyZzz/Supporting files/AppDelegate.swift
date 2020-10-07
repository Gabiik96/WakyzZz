//
//  AppDelegate.swift
//  WakyZzz
//
//  Created by Olga Volkova on 2018-05-30.
//  Copyright © 2018 Olga Volkova OC. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    // CoreData implementation
    static var container: NSPersistentContainer {
        get {
            return (UIApplication.shared.delegate as! AppDelegate).persistentContainer
        }
    }
    
    static var context: NSManagedObjectContext {
        get {
            return AppDelegate.container.viewContext
        }
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "WakyZzz")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        saveContext()
    }
   
    func applicationWillTerminate(_ application: UIApplication) {
        saveContext()
    }
    
    // CoreData saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

