//
//  Information.swift
//  kj
//
//  Created by 劉 on 2016/1/22.
//  Copyright © 2016年 劉. All rights reserved.
//

import Foundation
import RealmSwift

class Information: Object {
    
    dynamic var startTime: Date? = nil
    dynamic var endTime: Date? = nil
    dynamic var price = ""
    dynamic var location = ""
    dynamic var latitude = 0.0
    dynamic var longitude = 0.0
    private let mainDatas = LinkingObjects(fromType: MainData.self, property: "informations")
    dynamic var mainData: MainData? {
        return self.mainDatas.first
    }
}
