//
//  RealmManager.swift
//  kj
//
//  Created by 劉 on 2016/5/1.
//  Copyright © 2016年 劉. All rights reserved.
//

import Foundation
import RealmSwift
import BoltsSwift

class RealmManager {
    
    static let sharedInstance = RealmManager()
    var realm: Realm
    
    init() {
        realm = try! Realm()
    }
    
    //MARK: Add
    
    func addDataTableViewData(_ data: [MainData]) {
        try! realm.write({
            for singleData in data {
                realm.add(singleData, update: true)
            }
        })
    }
    
    //MARK: Update
    
    func updateBookmark(_ filter: NSPredicate) -> Task<AnyObject> {
        let task = TaskCompletionSource<AnyObject>()
        if let thingToBeUpdated = realm.objects(MainData.self).filter(filter).first{
            try! realm.write({ 
                thingToBeUpdated.bookMark = !thingToBeUpdated.bookMark
            })
            task.set(result: thingToBeUpdated.bookMark as AnyObject)
        }
        else {
            task.set(error: NSError(domain: "Id might be wrong", code: 0, userInfo: nil))
            print("Id might be wrong")
        }
        return task.task
    }
    
    //MARK: Get
    
    func tryFetchMainDataByFilter(_ filter: NSPredicate) -> Task<AnyObject> {
        let task = TaskCompletionSource<AnyObject>()
        if realm.objects(MainData.self).filter(filter).first != nil {
            task.set(result: Array(realm.objects(MainData.self).filter(filter)) as AnyObject)
        }
        else {
            task.set(error: NSError(domain: "Not In MainData", code: 0, userInfo: nil))
            print("Not In MainData")
        }
        return task.task
    }
}
