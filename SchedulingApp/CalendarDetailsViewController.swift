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
    @IBOutlet weak var eventDetails: UITextView!
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pressedSaveDetails(sender: UIButton) {
        
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

//        
//        self.event.name = self.eventName.text
//        self.event.details = self.eventDetails.text
//
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
