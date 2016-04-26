//
//  CalendarViewController.swift
//  SchedulingApp
//
//  Created by Jake, JP, Jeff on 4/21/16.
//  Copyright © 2016 Jake Zeal. All rights reserved.
//

import UIKit
import FSCalendar
import Parse

class CalendarViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate,UITableViewDataSource, UITableViewDelegate {
    
    //MARK:- Properties
    var didOpenCalendar: Bool!
    var date = NSDate()
    var dateString: String?
    var calendarObject: PFObject?
    var membersArray:[String] = []
    var calendarDaysArray:[String] = []
    
    //MARK:- Outlets
    @IBOutlet weak var calendar: FSCalendar!
    
    @IBOutlet weak var membersTableView: UITableView!
    
    //MARK:- Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        membersTableView.delegate = self
        membersTableView.dataSource = self

//        for calendar with title = calendar title
//        print(cal["usernames"])

        
        self.didOpenCalendar = true
        
        calendar.scrollDirection = .Horizontal
        calendar.appearance.caseOptions = [.HeaderUsesUpperCase,.WeekdayUsesUpperCase]
        calendar.selectDate(date)
        makeDaysArray()
        
        //        calendar.allowsMultipleSelection = true
        
        // Uncomment this to test month->week and week->month transition
        /*
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(2.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
         self.calendar.setScope(.Week, animated: true)
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(1.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
         self.calendar.setScope(.Month, animated: true)
         }
         }
         */
        
    }
    
    func makeDaysArray() {
        let firstOfMonth = calendar.beginingOfMonthOfDate(date)
        
        let daysInMonth = calendar.numberOfDatesInMonthOfDate(date)
        let interval: Double = 86400 //seconds per 24 hours
        for day in 1..<daysInMonth {
            let nextDay = firstOfMonth.dateByAddingTimeInterval(interval*Double(day))
            let nextDayString = formatDateString(nextDay)
            self.calendarDaysArray.append(nextDayString)
        }
        print(self.calendarDaysArray)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.membersArray = calendarObject!["usernames"] as! [String]
    }
    
    
    func minimumDateForCalendar(calendar: FSCalendar) -> NSDate {
        return calendar.dateWithYear(2016, month: 1, day: 1)
    }
    
    func maximumDateForCalendar(calendar: FSCalendar) -> NSDate {
        return calendar.dateWithYear(2017, month: 12, day: 31)
    }
    
    func calendar(calendar: FSCalendar, numberOfEventsForDate date: NSDate) -> Int {
        //format the date

        //need a count of number of days in month
        

        
        //need the number of events per day per calendar (display maximum 3 dots)
        //if event exists on that day, show 1 dot, to max 3 dots, else show none
        //query parse, find that "Month Day, Year" string; match all events for that string -- count +1
        
        
        return 0
    }

    
    func formatDateString(date: NSDate) -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        let dateString: String = formatter.stringFromDate(date)
        return dateString
    }

    //Query Parse for events
//    func queryParse() {
//        let relation = calendarObject!.relationForKey("events")
//        let query = relation.query()
//        
//        query.findObjectsInBackgroundWithBlock {
//            (objects: [PFObject]?, error: NSError?) -> Void in
//            if error == nil && objects != nil {
//                for object in objects! {
//                    if let someHour = object["hourString"]{
//                        let hourString = someHour as! String
//                        let eventName = object["name"] as! String
//                        self.events[hourString] = eventName
//                        //print(self.events)
//                    }
//                }
//            } else {
//                print(error)
//            }
//        }
//    }
    
    func calendarCurrentPageDidChange(calendar: FSCalendar) {
        NSLog("change page to \(calendar.stringFromDate(calendar.currentPage))")
        //if change page --> generate new array, requery parse?
    }
    
    func calendar(calendar: FSCalendar, didSelectDate date: NSDate) {
        if (didOpenCalendar == false){
            //NSLog("calendar did select date \(calendar.stringFromDate(date))")
            self.date = date
            performSegueWithIdentifier("showCalendarTableView", sender: nil)
        } else if (didOpenCalendar == true) {
            didOpenCalendar = false
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showCalendarTableView" {
            let nextVC = segue.destinationViewController as! CalendarTableViewController
            nextVC.newDate = date
            nextVC.calendarObject = self.calendarObject
        }
    }
    
    //TableView data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    func tableView( tableView : UITableView,  titleForHeaderInSection section: Int)->String? {
        return "Group members"
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section
        return self.membersArray.count

    
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        let members = self.membersArray[indexPath.row]
        cell.textLabel?.text = members

        return cell
    }
  
    
    
}
