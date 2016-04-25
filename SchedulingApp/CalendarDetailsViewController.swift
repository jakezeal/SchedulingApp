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
    @IBOutlet weak var eventDetails: UITextField!
    @IBOutlet weak var timeHeading: UILabel!
    
    var hourDetails = NSDate()
    var passSelectedDate = String() //To associate month, day, and year with this event
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let formatter = NSDateFormatter()
        formatter.timeZone = NSTimeZone(abbreviation: "EST")
        formatter.dateFormat = "MMM d, yyyy hh:mm a z"
        self.timeHeading.text = formatter.stringFromDate(hourDetails)
    }
    
    @IBAction func saveDetails(sender: UIBarButtonItem) {
        let e = PFObject(className:"Event")
        e["name"] = self.eventName.text
        e["details"] = self.eventDetails.text
        e["hour"] = self.hourDetails
        let hourString = makeHourString(self.hourDetails)
        e["hourString"] = hourString
        e["date"] = self.passSelectedDate
        
        e.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                print("Event saved.")
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
