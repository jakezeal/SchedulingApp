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
    
    //MARK:- Properties
    var hourDetails = NSDate()
    var passSelectedDate = String()
    var calendarObject: PFObject?
    var eventObject: PFObject?
    
    //MARK:- Outlets
    @IBOutlet weak var eventName: UITextField!
    @IBOutlet weak var eventDetailsTextView: UITextView!
    @IBOutlet weak var timeHeading: UILabel!
    
    //MARK:- View Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareEvent()
        prepareHeading()
        prepareSubviews()
    }
    
    //MARK:- Preparations
    func prepareSubviews() {
        eventName.addShadow()
        eventDetailsTextView.addShadow()
    }
    
    func prepareEvent() {
        if let event = eventObject {
            let eventName = event["name"] as! String
            let eventDetails = event["details"] as! String
            
            self.eventName.text = eventName
            self.eventDetailsTextView.text = eventDetails
        }
    }
    
    func prepareHeading() {
        let formatter = NSDateFormatter()
        formatter.timeZone = NSTimeZone(abbreviation: "EST")
        formatter.dateFormat = "MMM d, yyyy hh:mm a"
        self.timeHeading.text = formatter.stringFromDate(hourDetails)
    }
    
    func prepareHourString(date: NSDate) -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "hh:mm a"
        let hour = formatter.stringFromDate(date)
        return hour
    }
    
    //MARK:- Actions
    @IBAction func saveDetails(sender: UIBarButtonItem) {
        let e = PFObject(className:"Event")
        e["name"] = self.eventName.text
        e["details"] = self.eventDetailsTextView.text
        e["hour"] = self.hourDetails
        
        let hourString = prepareHourString(self.hourDetails)
        e["hourString"] = hourString
        e["dateString"] = self.passSelectedDate
        
        e.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                let relation = self.calendarObject?.relationForKey("events")
                relation?.addObject(e)
                if let someObject = self.calendarObject{
                    someObject.saveInBackgroundWithBlock({ (finished, error) in
                        self.navigationController?.popViewControllerAnimated(true)
                    })
                } else {
                    print("Error ==>>> \(error?.localizedDescription)")
                }
            }
        }
    }
}
