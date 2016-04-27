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
        if let event = eventObject {
            let eventName = event["name"] as! String
            let eventDetails = event["details"] as! String
            //  self.events[hourString] = eventName
            
            self.eventName.text = eventName
            self.eventDetailsTextView.text = eventDetails
        }
        prepareSubviews()
    }
    
    func prepareSubviews() {
        eventDetailsTextView.addShadow()
        eventName.addShadow()
        
        let formatter = NSDateFormatter()
        formatter.timeZone = NSTimeZone(abbreviation: "EST")
        formatter.dateFormat = "MMM d, yyyy hh:mm a"
        self.timeHeading.text = formatter.stringFromDate(hourDetails)
    }

    @IBAction func saveDetails(sender: UIBarButtonItem) {
        let e = PFObject(className:"Event")
        e["name"] = self.eventName.text
        e["details"] = self.eventDetailsTextView.text
        e["hour"] = self.hourDetails
        let hourString = makeHourString(self.hourDetails)
        e["hourString"] = hourString
        e["dateString"] = self.passSelectedDate
        
        //establish relation with calendar
        
        e.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                let relation = self.calendarObject?.relationForKey("events")
                relation?.addObject(e)
                if let someObject = self.calendarObject{
                someObject.saveInBackground()
                }
            } else {
                print("Error ==>>> \(error?.localizedDescription)")
            }
            //EITHER DELEGATE OR TURN OFF CACHE AND RELOAD
            self.navigationController?.popViewControllerAnimated(true)
        }
        
    }
    
    func makeHourString(date: NSDate) -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "hh:mm a"
        let hour = formatter.stringFromDate(date)
        return hour
    }
    
}
