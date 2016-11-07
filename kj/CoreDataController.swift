//
//  coreDataController.swift
//  kj
//
//  Created by 劉 on 2015/9/27.
//  Copyright (c) 2015年 劉. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


class CoreDataController {
    
//    var jsonUID = Dictionary<Int, String>()
//    var category = [1, 2, 3, 4, 5, 6, 7, 8, 11, 13, 14, 15, 17, 19]
//    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//    let managedContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
//    
//    func jsonToCoreData() {
//        //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
//            for c in category {
//                self.insertOriginalData(c)
//                print("finish : \(c)")
//            }
//    }
//    
//    func insertOriginalData(_ category : Int) {
//        let url = URL(string: "http://cloud.culture.tw/frontsite/trans/SearchShowAction.do?method=doFindTypeJ&category=\(category)")
//        let jsonData = (try? Data(contentsOf: url!)) as Data!
//        let readableJSON = JSON(data: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers, error: nil)
//        let dataCount = readableJSON.count
//        let UIDString = ""
//        
//        for (var i = 0; i < dataCount; i += 1) {
//            insertData(readableJSON[i], UIDString: UIDString)
//        }
//    }
//    
//    func getModelByCategory(_ category : Int, sort : String) -> [Model] {
//        let fetchRequest = NSFetchRequest(entityName: "Model")
//        let sortDescriptor = NSSortDescriptor(key: sort, ascending: true)
//        let condition = NSPredicate(format: "category == %d", category)
//        fetchRequest.sortDescriptors = [sortDescriptor]
//        fetchRequest.predicate = condition
//        let fetchResults = (try? managedContext!.fetch(fetchRequest)) as? [Model]
//        return fetchResults!
//    }
//    
//    func getTitleByClass(_ Class: Int, condition: String) -> [String] {
//        var stringResults = [String]()
//        var finalPredicate = NSPredicate()
//        let fetchRequest = NSFetchRequest(entityName: "Model")
//        switch Class {
//            case 1 :
//                let predicate1 = NSPredicate(format: "category == %d", 1)
//                let predicate2 = NSPredicate(format: "category == %d", 5)
//                let predicate3 = NSPredicate(format: "category == %d", 17)
//                let predicate4 = NSPredicate(format: "title contains %@", condition)
//                let orPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.or, subpredicates: [predicate1, predicate2, predicate3])
//                finalPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [orPredicate, predicate4])
//            case 2 :
//                let predicate1 = NSPredicate(format: "category == %d", 2)
//                let predicate2 = NSPredicate(format: "category == %d", 3)
//                let predicate3 = NSPredicate(format: "category == %d", 8)
//                let predicate4 = NSPredicate(format: "title contains %@", condition)
//                let orPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.or, subpredicates: [predicate1, predicate2, predicate3])
//                finalPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [orPredicate, predicate4])
//            case 3 :
//                let predicate1 = NSPredicate(format: "category == %d", 6)
//                let predicate2 = NSPredicate(format: "category == %d", 7)
//                let predicate3 = NSPredicate(format: "category == %d", 19)
//                let predicate4 = NSPredicate(format: "title contains %@", condition)
//                let orPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.or, subpredicates: [predicate1, predicate2, predicate3])
//                finalPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [orPredicate, predicate4])
//            case 4 :
//                let predicate1 = NSPredicate(format: "category == %d", 13)
//                let predicate2 = NSPredicate(format: "category == %d", 14)
//                let predicate3 = NSPredicate(format: "title contains %@", condition)
//                let orPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.or, subpredicates: [predicate1, predicate2])
//                finalPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [orPredicate, predicate3])
//            case 5 :
//                let predicate1 = NSPredicate(format: "category == %d", 4)
//                let predicate2 = NSPredicate(format: "category == %d", 11)
//                let predicate3 = NSPredicate(format: "title contains %@", condition)
//                let orPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.or, subpredicates: [predicate1, predicate2])
//                finalPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [orPredicate, predicate3])
//            case 6 :
//                let predicate1 = NSPredicate(format: "category == %d",15)
//                let predicate2 = NSPredicate(format: "title contains %@", condition)
//                finalPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [predicate1, predicate2])
//            default :
//                finalPredicate = NSPredicate(format: "title contains %@", condition)
//        }
//        fetchRequest.predicate = finalPredicate
//        let fetchResults = (try? managedContext!.fetch(fetchRequest)) as? [Model]
//        for item in fetchResults! {
//            stringResults.append(item.title!)
//        }
//        return stringResults
//    }
//    
//    func getModelByType(_ condition: String, type: String) -> [Model] {
//        let fetchRequest = NSFetchRequest(entityName: "Model")
//        let predicate = NSPredicate(format: "\(type) == %@", condition)
//        fetchRequest.predicate = predicate
//        let fetchResults = (try? managedContext?.fetch(fetchRequest)) as? [Model]
//        return fetchResults!
//    }
//    
//    func getModelById(_ id: String) -> [Model] {
//        let fetchRequest = NSFetchRequest(entityName: "Model")        
//        let condition = NSPredicate(format: "id == %@", id)
//        fetchRequest.predicate = condition
//        let fetchResult = (try? managedContext?.fetch(fetchRequest)) as! [Model]
//        return fetchResult
//    }
//    
//    func getModelById_Month(_ id: String) -> [Model] {
//        let date = Date()
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy/MM/dd"
//        let month = (dateFormatter.string(from: date) as NSString).substring(to: 7)
//        let fetchRequest = NSFetchRequest(entityName: "Model")
//        let condition1 = NSPredicate(format: "id == %@", id)
//        let condition2 = NSPredicate(format: "startDate contains %@", month)
//        let finalCondition = NSCompoundPredicate(andPredicateWithSubpredicates: [condition1, condition2])
//        fetchRequest.predicate = finalCondition
//        let fetchResults = (try? managedContext?.fetch(fetchRequest)) as? [Model]
//        return fetchResults!
//    }
//    
//    func getNearByCoordinates(_ clatitude : Double, clongtitude: Double)->[Info]{
//        let fetchRequest = NSFetchRequest(entityName: "Info")
//        let predicate1 = NSPredicate(format: "latitude.doubleValue <= %f", clatitude+0.01)
//        let predicate2 = NSPredicate(format: "longitude.doubleValue <= %f", clongtitude+0.01)
//        let predicate3 = NSPredicate(format: "latitude.doubleValue >= %f", clatitude-0.01)
//        let predicate4 = NSPredicate(format: "longitude.doubleValue >= %f", clongtitude-0.01)
//        let preFinalPredicate1 = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [predicate2, predicate4])
//        let preFinalPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [predicate1, predicate3])
//        let finalPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [preFinalPredicate, preFinalPredicate1])
//        fetchRequest.predicate = finalPredicate
//        let fetchResults = (try? managedContext?.fetch(fetchRequest)) as? [Info]
//        print(fetchResults?.count)
//        return fetchResults!
//    }
//    
//    func getInfoByLocation(_ location1: String, location2: String) -> [Info] {
//        let fetchRequest = NSFetchRequest(entityName: "Info")
//        let condition = NSPredicate(format: "location contains %@", location1)
//        let condition1 = NSPredicate(format: "location contains %@", location2)
//        let finalCondition = NSCompoundPredicate(type: .or, subpredicates: [condition, condition1])
//        fetchRequest.predicate = finalCondition
//        let fetchResults = (try? managedContext?.fetch(fetchRequest)) as? [Info]
//        return fetchResults!
//    }
//    
//    func getInfoById(_ id : String) -> [Info] {
//        let fetchRequest = NSFetchRequest(entityName: "Info")
//        let condition = NSPredicate(format: "modelId == %@", id)
//        let sort = NSSortDescriptor(key: "startTime", ascending: true)
//        fetchRequest.predicate = condition
//        fetchRequest.sortDescriptors = [sort]
//        let fetchResults = (try? managedContext!.fetch(fetchRequest)) as? [Info]
//        return fetchResults!
//    }
//    
//    func getInfoByDate(_ date: String) -> [Info] {
//        let fetchRequest = NSFetchRequest(entityName: "Info")
//        let condition = NSPredicate(format: "startTime contains %@", date)
//        fetchRequest.predicate = condition
//        let fetchResults = (try? managedContext?.fetch(fetchRequest)) as? [Info]
//        
//        return fetchResults!
//    }
//    
//    func getAllBookmark() -> [Bookmark] {
//        let fetchRequest = NSFetchRequest(entityName: "Bookmark")
//        let fetchResults = (try? managedContext?.fetch(fetchRequest)) as? [Bookmark]
//        return fetchResults!
//    }
//    
//    func updateDataByCategory(_ category : Int) {
//        if jsonUID[category] == nil {
//            jsonUID[category] = ""
//            let fetchRequest = NSFetchRequest(entityName: "Model")
//            let condition = NSPredicate(format: "category == %d", category)
//            fetchRequest.predicate = condition
//            let oldData = (try? managedContext!.fetch(fetchRequest)) as? [Model]
//            let dataCount = oldData?.count
//            
//            for(var i = 0; i < dataCount; i += 1) {
//                jsonUID[category]! += oldData![i].id!
//            }
//        }
//        
//        let url = URL(string: "http://cloud.culture.tw/frontsite/trans/SearchShowAction.do?method=doFindTypeJ&category=\(category)")
//        let jsonData = (try? Data(contentsOf: url!)) as Data!
//        let newData = JSON(data: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers, error: nil)
//        let dataCount = newData.count
//
//        for(var i = 0; i < dataCount; i += 1) {
//            if (jsonUID[category]!.range(of: newData[i]["UID"].string!) == nil) {
//                insertData(newData[i], UIDString : jsonUID[category]!)
//            }
//        }
//    }
//    
//    func insertData(_ Data : JSON, UIDString : String) {
//        var UIDString = UIDString
//        let model = NSEntityDescription.insertNewObject(forEntityName: "Model", into: managedContext!) as! Model
//        
//        let startDate = self.ifDataExsist(Data["startDate"])
//        let endDate = self.ifDataExsist(Data["endDate"])
//        let category = self.ifDataExsist(Data["category"])
//        let imageUrl = self.ifDataExsist(Data["imageUrl"])
//        let title = self.ifDataExsist(Data["title"])
//        let detail = self.ifDataExsist(Data["descriptionFilterHtml"])
//        let webUrl = self.ifDataExsist(Data["sourceWebPromote"])
//        let salesUrl = self.ifDataExsist(Data["webSales"])
//        let masterUnit = self.ifDataExsist(Data["masterUnit"][0])
//        print(Data["UID"])
//        model.id = Data["UID"].string!
//        model.startDate = startDate
//        model.endDate = endDate
//        model.category = Int(category)
//        model.imageUrl = imageUrl
//        model.title = title
//        model.detail = detail
//        model.webUrl = webUrl
//        model.salesUrl = salesUrl
//        model.masterUnit = masterUnit
//        model.bookMark = false
//        
//        UIDString += model.id! + ","
//        
//        print("title : \(model.title)")
//        
//        let infoCount = Data["showInfo"].count
//        for (var j = 0; j < infoCount; j += 1) {
//            let info = NSEntityDescription.insertNewObject(forEntityName: "Info", into: managedContext!) as! Info
//            
//            let startTime = self.ifDataExsist(Data["showInfo"][j]["time"])
//            let endTime = self.ifDataExsist(Data["showInfo"][j]["endTime"])
//            let address = self.ifDataExsist(Data["showInfo"][j]["location"])
//            let price = self.ifDataExsist(Data["showInfo"][j]["price"])
//            let latitude = self.ifDataExsist(Data["showInfo"][j]["latitude"])
//            let longitude = self.ifDataExsist(Data["showInfo"][j]["longitude"])
//            
//            if startTime != "" {
//                info.startTime = (startTime! as NSString).substring(to: 16)
//            }
//            else {
//                info.startTime = ""
//            }
//            if endTime != "" {
//                info.endTime = (endTime! as NSString).substring(to: 16)
//            }
//            else {
//                info.endTime = ""
//            }
//            info.location = address
//            info.price = price
//            info.latitude = (latitude! as NSString).doubleValue
//            info.longitude = (longitude! as NSString).doubleValue
//            info.modelId = model.id
//        }
//        jsonUID[Int(category)!] = UIDString
//        appDelegate.saveContext()
//    }
//    
//    func insertDataToBookmark(_ id: String){
//        let bookmarkPage = NSEntityDescription.insertNewObject(forEntityName: "Bookmark", into: managedContext!) as! Bookmark
//        bookmarkPage.modelId = id
//        appDelegate.saveContext()
//    }
//    
//    func deleteDataInBookmark(_ id: String) {
//        let fetchRequest = NSFetchRequest(entityName: "Bookmark")
//        let condition = NSPredicate(format: "modelId == %@", id)
//        fetchRequest.predicate = condition
//        let fetchResults = (try? managedContext?.fetch(fetchRequest)) as? [NSManagedObject]
//        for i in fetchResults! {
//            managedContext?.delete(i)
//        }
//        appDelegate.saveContext()
//    }
//    
//    func changeBookMark(_ id : String) -> Bool {
//        let fetchRequest = NSFetchRequest(entityName: "Model")
//        let condition = NSPredicate(format: "id == %@", id)
//        fetchRequest.predicate = condition
//        let fetchResults = (try? managedContext!.fetch(fetchRequest)) as? [Model]
//        let state = fetchResults![0].bookMark
//        
//        //原本標記為書籤
//        if state == true {
//            fetchResults![0].bookMark = false
//            self.deleteDataInBookmark(fetchResults![0].id!)
//            appDelegate.saveContext()
//            return false
//        }
//        else {
//            fetchResults![0].bookMark = true
//            self.insertDataToBookmark(fetchResults![0].id!)
//            appDelegate.saveContext()
//            return true
//        }
//    }
//    
//    func ifDataExsist(_ data:SwiftyJSON.JSON) -> String! {
//        if data != nil && data.string! != "" {
//            return data.string!
//        }
//        else {
//            return ""
//        }
//    }
}
