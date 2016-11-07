//
//  EventController.swift
//  kj
//
//  Created by 劉 on 2015/10/19.
//  Copyright © 2015年 劉. All rights reserved.
//

import UIKit
import EventKit

class EventController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func event(_ date: Date) {
        //Calendar Database
        let eventStore = EKEventStore()
        
        // 2
        switch EKEventStore.authorizationStatus(for: .event) {
        case .authorized:
            insertEvent(eventStore, date: date)
        case .denied:
            print("Access denied")
        case .notDetermined:
            // 3
            eventStore.requestAccess(to: .event, completion:
                {[weak self] (granted: Bool, error: NSError?) -> Void in
                    if granted {
                        self!.insertEvent(eventStore, date: date)
                    } else {
                        print("Access denied")
                    }
                } as! EKEventStoreRequestAccessCompletionHandler)
        default:
            print("Case Default")
        }
    }

        // Do any additional setup after loading the view.

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertEvent(_ store: EKEventStore, date: Date) {
    // 1
        let calendars = store.calendars(for: .event)
    
        for calendar in calendars {
        // 2
            if calendar.title == "ioscreator" {
            // 3
                let startDate = date
            // 2 hours
                let endDate = startDate.addingTimeInterval(2 * 60 * 60)
            
            // 4
            // Create Event
                let event = EKEvent(eventStore: store)
                event.calendar = calendar
            
                event.title = "New Meeting"
                event.startDate = startDate
                event.endDate = endDate
            
            // 5
            // Save Event in Calendar
            
                do {
                    try store.save(event, span: .thisEvent)
                }catch let error as NSError{
                    print("An error occured \(error)")
                }
            }
        }
    }
}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


