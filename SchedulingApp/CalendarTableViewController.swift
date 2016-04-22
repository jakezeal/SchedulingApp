//
//  CalendarTableViewController.swift
//  SchedulingApp
//
//  Created by Jeffrey Ip on 2016-04-21.
//  Copyright © 2016 Jake Zeal. All rights reserved.
//

import UIKit
import Parse

class CalendarTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CalendarDetailsDelegate {

    //MARK:- Properties
    var newDate = NSDate()
    var hours: [NSDate] = []
    var event = Event()
//    var eventIDs: [String] = []
    
    //MARK:- Outlets
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    //MARK:- Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hours.append(newDate)
        
        makeHoursArray()
        formatDateLabel()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        self.tableView.reloadData()
        
    }
    
    //MARK:- UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.hours.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CalendarTableViewCell
        
        let formatter = NSDateFormatter()
        formatter.timeZone = NSTimeZone(abbreviation: "EST")
        formatter.dateFormat = "hh:mm a z"
        cell.hourLabel.text = formatter.stringFromDate(hours[indexPath.row])
       
        print("cell date: \(hours[indexPath.row]) == event.date: \(self.event.date)")
//        if (self.newDate == self.event.date){
        
        if self.event.date != nil {
            if (hours[indexPath.row].compare(self.event.date!) == NSComparisonResult.OrderedSame){
                cell.detailsLabel.text = self.event.details
            }
        }
        return cell
    }

    // MARK:- UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let formatter = NSDateFormatter()
        formatter.timeZone = NSTimeZone(abbreviation: "EST")
        formatter.dateFormat = "hh:mm a z"
        print("Date: \(formatter.stringFromDate(hours[indexPath.row]))")
        print("Read date: \(hours[indexPath.row])")
    }
    
    //MARK:- Helpers
    func makeHoursArray() {
        let interval: Double = 3600
        for hour in 1..<24 {
            let nextHour = newDate.dateByAddingTimeInterval(interval*Double(hour))
            self.hours.append(nextHour)
        }
    }
    
    func formatDateLabel() {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        self.dateLabel.text = formatter.stringFromDate(newDate)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showDetailsVC" {
            let calendarDetailsVC = segue.destinationViewController as! CalendarDetailsViewController
            
            calendarDetailsVC.delegate = self
            
            //Get the cell that generated this segue.
            if let selectedHour = sender as? CalendarTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedHour)!
                let hour = hours[indexPath.row]
                calendarDetailsVC.hourDetails = hour
            }
        }
    }

    //MARK: CalendarDetailsDelegate
    func getDetailsData(event: Event) {
        self.event = event
        print("\(self.event.ID)")
        queryParse(event)
    }
    
    func queryParse(event: Event) {
        let query = PFQuery(className:"Event")
        query.whereKey("_id", equalTo: event.ID!)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil && objects != nil {
                for object in objects! {
                    self.event.details = object["details"] as? String
                    print(self.event.details)
                    self.event.name = object["name"] as? String
                    print(self.event.name)
                    self.event.date = object["date"] as? NSDate
                    self.tableView.reloadData()
                }
            } else {
                print(error)
            }
        }
    }
    
}
