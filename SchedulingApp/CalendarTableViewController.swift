//
//  CalendarTableViewController.swift
//  SchedulingApp
//
//  Created by Jeffrey Ip on 2016-04-21.
//  Copyright © 2016 Jake Zeal. All rights reserved.
//

import UIKit
import Parse

class CalendarTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //MARK:- Properties
    var newDate = NSDate()
    var hours: [NSDate] = []
    var events = [String: String]()
    var selectedDate: String!
    var calendarObject: PFObject?
    
    //MARK:- Outlets
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    //MARK:- Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hours.append(newDate)
        makeCurrentDateString()
        makeHoursArray()
        //formatDateLabel()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.events.removeAll()
        queryParse()

    }
    
    //format the date, save year, month, date --> string
    func makeCurrentDateString() {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        self.selectedDate = formatter.stringFromDate(newDate)
        print(self.selectedDate)
    }
    
    func makeHourString(date: NSDate) -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "hh:mm a"
        let hour = formatter.stringFromDate(date)
        return hour
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
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 40
        
        let formatter = NSDateFormatter()
        formatter.timeZone = NSTimeZone(abbreviation: "EST")
        formatter.dateFormat = "hh:mm a z"
        cell.hourLabel.text = formatter.stringFromDate(hours[indexPath.row])
        
        let hourString = makeHourString(hours[indexPath.row])
        
        for (key, value) in self.events {
            if key == hourString {
                cell.eventDetails.text = value
                //print("key: \(key) hourString: \(hourString)")
                
            }
        }
        
        return cell
    }
    
    //MARK:- UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let formatter = NSDateFormatter()
        formatter.timeZone = NSTimeZone(abbreviation: "EST")
        formatter.dateFormat = "hh:mm a z"
        //print("Date: \(formatter.stringFromDate(hours[indexPath.row]))")
        //print("Read date: \(hours[indexPath.row])")
    }
    
    //MARK:- Helpers
    func makeHoursArray() {
        let interval: Double = 3600
        for hour in 1..<24 {
            let nextHour = newDate.dateByAddingTimeInterval(interval*Double(hour))
            self.hours.append(nextHour)
        }
    }
    
//    func formatDateLabel() {
//        let formatter = NSDateFormatter()
//        formatter.dateStyle = .MediumStyle
//        self.dateLabel.text = formatter.stringFromDate(newDate)
//    }
    func tableView( tableView : UITableView,  titleForHeaderInSection section: Int)->String? {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        let dateHeader = formatter.stringFromDate(newDate)

        return dateHeader
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showDetailsVC" {
            let calendarDetailsVC = segue.destinationViewController as! CalendarDetailsViewController
            
            //Get the cell that generated this segue.
            if let selectedHour = sender as? CalendarTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedHour)!
                let hour = hours[indexPath.row]
                calendarDetailsVC.hourDetails = hour
            }
            calendarDetailsVC.passSelectedDate = self.selectedDate
            calendarDetailsVC.calendarObject = self.calendarObject
        }
    }
    
    func queryParse() {
        let relation = calendarObject!.relationForKey("events")
        let query = relation.query()
        
        if let selectedDate = self.selectedDate {
            query.whereKey("dateString", equalTo: selectedDate)

        }
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil && objects != nil {
                for object in objects! {
                    if let someHour = object["hourString"]{
                        let hourString = someHour as! String
                        let eventName = object["name"] as! String
                        self.events[hourString] = eventName
                        //print(self.events)
                    }
                }
            } else {
                print(error)
            }
        }
    }
    
}
