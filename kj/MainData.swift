//
//  MainData.swift
//  kj
//
//  Created by 劉 on 2016/1/22.
//  Copyright © 2016年 劉. All rights reserved.
//

import Foundation
import RealmSwift

class MainData: Object {
    
    dynamic var id = ""
    dynamic var category = 0
    dynamic var title = ""
    dynamic var detail = ""
    dynamic var startDate: Date? = nil
    dynamic var endDate: Date? = nil
    dynamic var imageUrl = ""
    dynamic var salesUrl = ""
    dynamic var webUrl = ""
    dynamic var masterUnit = ""
    dynamic var bookMark = false
//    dynamic var informations = LinkingObjects(fromType: Information.self, property: "")
    var informations = List<Information>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
