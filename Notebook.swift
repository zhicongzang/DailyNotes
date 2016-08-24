//
//  Notebook.swift
//  DailyNotes
//
//  Created by Zhicong Zang on 8/22/16.
//  Copyright © 2016 Zhicong Zang. All rights reserved.
//

import UIKit
import CoreData


class Notebook: NSManagedObject {
    
    class func getAllNoteBooks() -> [Notebook] {
        let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let request = NSFetchRequest(entityName: "Notebook")
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        do {
            let results = try moc.executeFetchRequest(request) as! [Notebook]
            return results
        } catch{
            return []
        }
    }
    
    class func insertNewNotebook(name name: String) -> Bool {
        let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let request = NSFetchRequest(entityName: "Notebook")
        request.predicate = NSPredicate(format: "name = %@", name)
        do {
            let results = try moc.executeFetchRequest(request) as! [Notebook]
            if results.count == 0 {
                let notebook = NSEntityDescription.insertNewObjectForEntityForName("Notebook", inManagedObjectContext: moc) as! Notebook
                notebook.name = name
                try moc.save()
                return true
            }
        } catch {}
        return false
    }
    
    class func getNoteBook(name name: String) -> Notebook? {
        let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let request = NSFetchRequest(entityName: "Notebook")
        request.predicate = NSPredicate(format: "name = %@", name)
        do {
            let results = try moc.executeFetchRequest(request) as! [Notebook]
            if let result = results.first {
                return result
            }
        } catch {}
        return nil
    }
    
    class func checkDefaultNotebook() {
        if getAllNoteBooks().count == 0 {
            insertNewNotebook(name: "Default Notebook")
        }
    }

}
