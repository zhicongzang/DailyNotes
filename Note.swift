//
//  Note.swift
//  DailyNotes
//
//  Created by Zhicong Zang on 8/23/16.
//  Copyright © 2016 Zhicong Zang. All rights reserved.
//

import UIKit
import CoreData
import MapKit


class Note: NSManagedObject {

    class func getAllNoteBooks() -> [Note] {
        let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let request = NSFetchRequest(entityName: "Note")
        request.sortDescriptors = [NSSortDescriptor(key: "subject", ascending: true)]
        do {
            let results = try moc.executeFetchRequest(request) as! [Note]
            return results
        } catch{
            return []
        }
    }
    
    class func insertNewNote(subject subject: String, notebook: Notebook, createdDate: NSDate, updateDate: NSDate, reminderDate: NSDate?, location: CLLocation, locationName: String?, text: NSAttributedString) -> Bool {
        let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        do {
            let note = NSEntityDescription.insertNewObjectForEntityForName("Note", inManagedObjectContext: moc) as! Note
            note.subject = subject
            note.notebook = notebook
            note.createdDate = createdDate
            note.updateDate = updateDate
            note.reminderDate = reminderDate
            note.latitude = location.coordinate.latitude
            note.longitude = location.coordinate.latitude
            note.locationName = locationName
            note.text = text
            
            try moc.save()
            return true
        } catch {}
        return false
    }

}
