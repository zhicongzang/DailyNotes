//
//  Note+CoreDataProperties.swift
//  DailyNotes
//
//  Created by Zhicong Zang on 9/13/16.
//  Copyright © 2016 Zhicong Zang. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Note {

    @NSManaged var createdDate: NSDate?
    @NSManaged var latitude: NSNumber?
    @NSManaged var locationName: String?
    @NSManaged var longitude: NSNumber?
    @NSManaged var reminderDate: NSDate?
    @NSManaged var subject: String?
    @NSManaged var text: NSAttributedString?
    @NSManaged var updateDate: NSDate?
    @NSManaged var notebook: Notebook?
    @NSManaged var tags: NSOrderedSet?

}
