//
//  Info.swift
//  kj
//
//  Created by 劉 on 2015/10/3.
//  Copyright © 2015年 劉. All rights reserved.
//

import Foundation
import CoreData

@objc(Info)
class Info: NSManagedObject {

    @NSManaged var endTime: String?
    @NSManaged var latitude: NSNumber?
    @NSManaged var location: String?
    @NSManaged var longitude: NSNumber?
    @NSManaged var price: String?
    @NSManaged var startTime: String?
    @NSManaged var modelId: String?
    
}
