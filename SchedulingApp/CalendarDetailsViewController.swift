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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.navigationController?.navigationBar.titleTextAttributes = UIColor.init(red: 202.0, green: 15.0, blue: 19.0, alpha: 1.0)
        
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
                self.calendarObject!.saveInBackground()
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
