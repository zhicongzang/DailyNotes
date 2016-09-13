//
//  Tag.swift
//  DailyNotes
//
//  Created by Zhicong Zang on 9/13/16.
//  Copyright © 2016 Zhicong Zang. All rights reserved.
//

import UIKit
import CoreData


class Tag: NSManagedObject {

    class func getAllTags() -> [Tag] {
        let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let request = NSFetchRequest(entityName: "Tag")
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        do {
            let results = try moc.executeFetchRequest(request) as! [Tag]
            return results
        } catch{
            return []
        }
    }
    
    class func insertNewTag(name name: String) -> Bool {
        let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let request = NSFetchRequest(entityName: "Tag")
        request.predicate = NSPredicate(format: "name = %@", name)
        do {
            let results = try moc.executeFetchRequest(request) as! [Tag]
            if results.count == 0 {
                let tag = NSEntityDescription.insertNewObjectForEntityForName("Tag", inManagedObjectContext: moc) as! Tag
                tag.name = name
                try moc.save()
                return true
            }
        } catch {}
        return false
    }
    
    class func getTag(name name: String) -> Tag? {
        let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let request = NSFetchRequest(entityName: "Tag")
        request.predicate = NSPredicate(format: "name = %@", name)
        do {
            let results = try moc.executeFetchRequest(request) as! [Tag]
            if let result = results.first {
                return result
            }
        } catch {}
        return nil
    }

}
