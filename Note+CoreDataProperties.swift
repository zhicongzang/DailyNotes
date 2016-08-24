//
//  Note+CoreDataProperties.swift
//  DailyNotes
//
//  Created by Zhicong Zang on 8/23/16.
//  Copyright © 2016 Zhicong Zang. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Note {

    @NSManaged var subject: String?
    @NSManaged var createdDate: NSDate?
    @NSManaged var updateDate: NSDate?
    @NSManaged var latitude: NSNumber?
    @NSManaged var longitude: NSNumber?
    @NSManaged var text: NSAttributedString?
    @NSManaged var locationName: String?
    @NSManaged var notebook: Notebook?

}
