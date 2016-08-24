//
//  Notebook+CoreDataProperties.swift
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

extension Notebook {

    @NSManaged var name: String?
    @NSManaged var note: NSOrderedSet?

}
