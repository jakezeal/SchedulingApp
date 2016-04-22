//
//  CalendarDetailsViewController.swift
//  SchedulingApp
//
//  Created by Jeffrey Ip on 2016-04-22.
//  Copyright © 2016 Jake Zeal. All rights reserved.
//

import UIKit

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

        self.timeHeading.text = "\(hourDetails)"
    }
    
    @IBAction func pressedSaveDetails(sender: UIButton) {
        self.event.name = self.eventName.text
        self.event.details = self.eventDetails.text
        
        delegate?.getDetailsData(self.event)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
