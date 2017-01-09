//
//  FetchData.swift
//  kj
//
//  Created by 劉 on 2016/1/22.
//  Copyright © 2016年 劉. All rights reserved.
//

import BoltsSwift
import Alamofire
import SwiftyJSON
import RealmSwift

//protocol FetchDataDelegate {
//    func requestProgress(progress: Double)
//}

class FetchData {
    static var sharedInstance = FetchData()
//    var delegate: FetchDataDelegate?
    
    init() {
    }
    
    func RequestForData(_ category: Int, sendCurrentProgress: @escaping (Double) -> ()) -> Task<AnyObject> {
        let utilityQueue = DispatchQueue(label: "com.culture.utilityQueue", qos: .utility, attributes: .concurrent)
        let task = TaskCompletionSource<AnyObject>()
        let bookMarkId = RealmManager.sharedInstance.tryFetchAllBookmarkId()
        
        Alamofire.request(
            "http://cloud.culture.tw/frontsite/trans/SearchShowAction.do", method: .get,
            parameters: ["method":"doFindTypeJ", "category":category])
            .downloadProgress(queue: utilityQueue, closure: { progress in
                print("Category: \(category), Download progress: \(progress.fractionCompleted)")
//                self.delegate?.requestProgress(progress: progress.fractionCompleted)
                sendCurrentProgress(progress.fractionCompleted)
            })
            .responseJSON(queue: utilityQueue) { response in
                switch response.result {
                case .success(let data):
                    let json = JSON(data)
                    let results = json.arrayValue
                    var dataDB = [MainData]()
                    
                    for result in results {
                        let tempMainData = MainData()
                        var tempInformation = [Information]()
                        
                        tempMainData.id = result["UID"].string!
                        tempMainData.startDate = self.stringToDate(date: self.ifDataExsist(result["startDate"]), dateFormat: "yyyy/MM/dd")
                        tempMainData.endDate = self.stringToDate(date: self.ifDataExsist(result["endDate"]), dateFormat: "yyyy/MM/dd")
                        tempMainData.category = Int(self.ifDataExsist(result["category"]))!
                        tempMainData.imageUrl = self.ifDataExsist(result["imageUrl"])
                        tempMainData.title = self.ifDataExsist(result["title"])
                        tempMainData.detail = self.ifDataExsist(result["descriptionFilterHtml"])
                        tempMainData.webUrl = self.ifDataExsist(result["sourceWebPromote"])
                        tempMainData.salesUrl = self.ifDataExsist(result["webSales"])
                        tempMainData.masterUnit = self.ifDataExsist(result["masterUnit"][0])
                        
                        if bookMarkId.contains(tempMainData.id) {
                            tempMainData.bookMark = true
                        }
                        
                        for index in 0..<result["showInfo"].count {
                            let information = Information()
                            
                            let informationIndex = result["showInfo"][index]
                            var startTime = self.ifDataExsist(informationIndex["time"])
                            startTime = (startTime != "") ? (startTime! as NSString).substring(to: 16) : ""
                            var endTime = self.ifDataExsist(informationIndex["endTime"])
                            endTime = (endTime != "") ? (endTime! as NSString).substring(to: 16) : ""
                            let latitude = self.ifDataExsist(informationIndex["latitude"])
                            let longitude = self.ifDataExsist(informationIndex["longitude"])
                            
                            information.id = tempMainData.id + "\(index)"
                            information.startTime = self.stringToDate(date: startTime!, dateFormat: "yyyy/MM/dd HH:mm")
                            information.endTime = self.stringToDate(date: endTime!, dateFormat: "yyyy/MM/dd HH:mm")
                            information.price = self.ifDataExsist(informationIndex["price"])
                            information.location = self.ifDataExsist(informationIndex["location"])
                            information.latitude = (latitude! as NSString).doubleValue
                            information.longitude = (longitude! as NSString).doubleValue
                            
                            tempInformation.append(information)
                        }
                        
                        tempMainData.informations.append(contentsOf: tempInformation)
                        dataDB.append(tempMainData)
                    }
                    task.set(result: dataDB as AnyObject)
                    
                case .failure(let error):
                    task.set(error: error)
                }
        }
        return task.task
    }
    
    func ifDataExsist(_ data:SwiftyJSON.JSON) -> String! {
        if data != nil && data.string! != "" {
            return data.string!
        }
        else {
            return ""
        }
    }
    
    func stringToDate(date: String, dateFormat: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "zh_Hant_TW")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Taipei")
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.date(from: date)
    }
}

