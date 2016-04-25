//
//  CalendarDetailsViewController.swift
//  SchedulingApp
//
//  Created by Jeffrey Ip on 2016-04-22.
//  Copyright © 2016 Jake Zeal. All rights reserved.
//

import UIKit
import Parse

protocol CalendarDetailsDelegate {
    func getDetailsData(event: Event)
}

class CalendarDetailsViewController: UIViewController {

    @IBOutlet weak var eventName: UITextField!
    @IBOutlet weak var eventDetails: UITextField!
    @IBOutlet weak var timeHeading: UILabel!
    
    var hourDetails = NSDate()
    var delegate: CalendarDetailsDelegate?
    var event = Event()
//    var eventNameString: String?
//    var eventDetailsString: String?
    
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
        e["date"] = self.hourDetails
        
        e.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                print("Event saved.")
                self.event.ID = e.objectId
                print("\(self.event.ID)")
                
                dispatch_async(dispatch_get_main_queue(),{
                    self.delegate?.getDetailsData(self.event)
                })
            } else {
                print("Error ==>>> \(error?.localizedDescription)")
            }
    }
        self.navigationController?.popViewControllerAnimated(true)
    }
}
