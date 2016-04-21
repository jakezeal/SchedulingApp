//
//  CalendarTableViewController.swift
//  SchedulingApp
//
//  Created by Jeffrey Ip on 2016-04-21.
//  Copyright © 2016 Jake Zeal. All rights reserved.
//

import UIKit

class CalendarTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var dateLabel: UILabel!
    
    var newDate = NSDate()
    var hours: [NSDate] = []
    
    @IBOutlet weak var tableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hours.append(newDate)
        
        makeHoursArray()
        formatDateLabel()
    }
    
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
    
    
    // MARK: Table View Data Source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.hours.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        let formatter = NSDateFormatter()
        formatter.timeZone = NSTimeZone(abbreviation: "EST")
        formatter.dateFormat = "hh:mm a z"
        cell.textLabel!.text = formatter.stringFromDate(hours[indexPath.row])
        return cell
    }
    
    // MARK: Table View Delegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let formatter = NSDateFormatter()
        formatter.timeZone = NSTimeZone(abbreviation: "EST")
        formatter.dateFormat = "hh:mm a z"
        print("Date: \(formatter.stringFromDate(hours[indexPath.row]))")
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
