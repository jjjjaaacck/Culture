//
//  Model+CoreDataProperties.swift
//  kj
//
//  Created by 劉 on 2015/10/9.
//  Copyright © 2015年 劉. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

@objc(Model)
class Model: NSManagedObject {

    @NSManaged var bookMark: NSNumber?
    @NSManaged var category: NSNumber?
    @NSManaged var detail: String?
    @NSManaged var endDate: String?
    @NSManaged var id: String?
    @NSManaged var imageUrl: String?
    @NSManaged var masterUnit: String?
    @NSManaged var salesUrl: String?
    @NSManaged var startDate: String?
    @NSManaged var title: String?
    @NSManaged var webUrl: String?

}
