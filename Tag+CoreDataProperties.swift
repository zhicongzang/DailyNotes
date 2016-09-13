//
//  Tag+CoreDataProperties.swift
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

extension Tag {

    @NSManaged var name: String?
    @NSManaged var notes: NSOrderedSet?

}
