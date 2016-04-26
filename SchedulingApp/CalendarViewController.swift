//
//  CalendarViewController.swift
//  SchedulingApp
//
//  Created by Zeal on 4/21/16.
//  Copyright © 2016 Jake Zeal. All rights reserved.
//

import UIKit
import FSCalendar
import Parse

class CalendarViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate,UITableViewDataSource, UITableViewDelegate {
    
    //MARK:- Properties
    var didOpenCalendar: Bool!
    var date = NSDate()
    var calendarObject: PFObject?
    var membersArray:[String] = []
    
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
//        let day = calendar.dayOfDate(date)
//        return day % 5 == 0 ? day/5 : 0;
        return 0
    }
    
    func calendarCurrentPageDidChange(calendar: FSCalendar) {
        NSLog("change page to \(calendar.stringFromDate(calendar.currentPage))")
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
