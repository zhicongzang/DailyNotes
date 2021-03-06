//
//  AppDelegate.swift
//  DailyNotes
//
//  Created by Zhicong Zang on 7/20/16.
//  Copyright © 2016 Zhicong Zang. All rights reserved.
//

import UIKit
import CoreData
import EventKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    var window: UIWindow?
    let eventStore:EKEventStore = EKEventStore()
    var reminders = [EKReminder]() {
        didSet {
            completedReminders = reminders.filter({ $0.completed == true })
            uncompletedReminders = reminders.filter({ $0.completed == false })
        }
    }
    var completedReminders = [EKReminder]()
    dynamic var uncompletedReminders = [EKReminder]()
    
    func getAllReminders() {
        let predicate = self.eventStore.predicateForRemindersInCalendars(nil)
        self.eventStore.fetchRemindersMatchingPredicate(predicate, completion: { (reminders) in
            self.reminders = reminders?.sort({ (first, second) -> Bool in
                first.dueDateComponents?.date?.timeIntervalSince1970 ?? 0 < second.dueDateComponents?.date?.timeIntervalSince1970 ?? 0
            }) ?? []
        })
    }
    
    func removeAllReminders() {
        let predicate = self.eventStore.predicateForRemindersInCalendars(nil)
        self.eventStore.fetchRemindersMatchingPredicate(predicate, completion: { (reminders) in
            reminders?.forEach({ (reminder) in
                do {
                    try self.eventStore.removeReminder(reminder, commit: true)
                } catch {}
            })
            
        })
    }
    
    func changedCompletionOfReminderByIndex(index: Int, completed: Bool) {
        if index < uncompletedReminders.count {
            uncompletedReminders[index].completed = completed
            do {
                try eventStore.saveReminder(uncompletedReminders[index], commit: true)
            } catch {}
            getAllReminders()
        }
    }
    
    func removeReminder(title title: String, dueDate: NSDate) {
        reminders.forEach { (reminder) in
            if let date = reminder.dueDateComponents?.date {
                if reminder.title == title && date.toReminderDateString() == dueDate.toReminderDateString() {
                    do {
                        try eventStore.removeReminder(reminder, commit: true)
                    } catch {}
                }
            }
            
        }
        getAllReminders()
    }
    
    func modifyReminder(title title: String, dueDate: NSDate, newTitle: String?, newDueDate: NSDate?) {
        reminders.forEach { (reminder) in
            if let date = reminder.dueDateComponents?.date {
                if reminder.title == title && date.toReminderDateString() == dueDate.toReminderDateString() {
                    if let title = newTitle {
                        reminder.title = title
                    }
                    if let dueDate = newDueDate {
                        reminder.dueDateComponents = dueDate.dateComponent()
                    }
                    do {
                        try eventStore.saveReminder(reminder, commit: true)
                    } catch {}
                }
            }
        }
        getAllReminders()
    }
    
    func removeUncompletedReminderByIndex(index: Int) {
        if index < uncompletedReminders.count {
            do {
                try eventStore.removeReminder(uncompletedReminders[index], commit: true)
            } catch {}
            getAllReminders()
        }
    }
    
    func modifyUncompletedReminderByIndex(index: Int, newTitle: String?, newDueDate: NSDate?) {
        if index < uncompletedReminders.count {
            if let title = newTitle {
                uncompletedReminders[index].title = title
            }
            if let dueDate = newDueDate {
                uncompletedReminders[index].dueDateComponents = dueDate.dateComponent()
            }
            do {
                try eventStore.saveReminder(uncompletedReminders[index], commit: true)
            } catch {}
            getAllReminders()
        }
    }
    

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        Utils.getPhotoLibraryAuthorization(handler: Utils.createAssetCollection(title: AssetCollectionTitle))
        eventStore.requestAccessToEntityType(.Reminder) { (isAuthorized, error) in
            if isAuthorized && error == nil  {
                self.getAllReminders()
            } else {
                if let e = error {
                    print(e)
                } else {
                    print("Wrong")
                }
            }
            
        }
        Notebook.checkDefaultNotebook()
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "Jesse.DailyNotes" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("DailyNotes", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason

            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }

}

