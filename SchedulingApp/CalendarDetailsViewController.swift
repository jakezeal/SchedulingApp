//
//  CalendarDetailsViewController.swift
//  SchedulingApp
//
//  Created by Jeffrey Ip on 2016-04-22.
//  Copyright © 2016 Jake Zeal. All rights reserved.
//

import UIKit
import Parse

class CalendarDetailsViewController: UIViewController {

    @IBOutlet weak var eventName: UITextField!
    @IBOutlet weak var eventDetailsTextView: UITextView!
    @IBOutlet weak var timeHeading: UILabel!
    
    var hourDetails = NSDate()
    var passSelectedDate = String() //To associate month, day, and year with this event
    var calendarObject: PFObject?
    var eventObject: PFObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let event = eventObject{
        let eventName = event["name"] as! String
        let eventDetails = event["details"] as! String
        //  self.events[hourString] = eventName
        
        self.eventName.text = eventName
        self.eventDetailsTextView.text = eventDetails
        }

        
        let formatter = NSDateFormatter()
        formatter.timeZone = NSTimeZone(abbreviation: "EST")
        formatter.dateFormat = "MMM d, yyyy hh:mm a z"
        self.timeHeading.text = formatter.stringFromDate(hourDetails)
        getCalendarName()
    }
    
    func lookForEventDetails(){
        let relation = calendarObject!.relationForKey("events")
        let query = relation.query()
        
            query.whereKey("date", equalTo: self.passSelectedDate)
            //query.whereKey("hour", equalTo: self.hourDetails)
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil && objects != nil {
                for object in objects! {
                        //let hourString = object["hourString"] as! String
                        let eventName = object["name"] as! String
                        let eventDetails = object["details"] as! String
                      //  self.events[hourString] = eventName

                        self.eventName.text = eventName
                        self.eventDetailsTextView.text = eventDetails

                      //  self.events[hourString] = eventName
                        //print(self.events)
                }
            } else {
                print(error)
            }
        }
    }
    
 
        


    func getCalendarName() {
        
    }
    
    @IBAction func saveDetails(sender: UIBarButtonItem) {
        let e = PFObject(className:"Event")
        e["name"] = self.eventName.text
        e["details"] = self.eventDetailsTextView.text
        e["hour"] = self.hourDetails
        let hourString = makeHourString(self.hourDetails)
        e["hourString"] = hourString
        e["date"] = self.passSelectedDate
        
        //establish relation with calendar
        
        e.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
               // print("Event saved.")
                
                let relation = self.calendarObject?.relationForKey("events")
                relation?.addObject(e)
                self.calendarObject!.saveInBackground()
            } else {
                print("Error ==>>> \(error?.localizedDescription)")
            }
    }
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func makeHourString(date: NSDate) -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "hh:mm a"
        let hour = formatter.stringFromDate(date)
        return hour
    }
    
}
