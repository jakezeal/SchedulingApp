//
//  CalendarCollectionViewController.swift
//  SchedulingApp
//
//  Created by Zeal on 4/21/16.
//  Copyright © 2016 Jake Zeal. All rights reserved.
//

import UIKit
import Parse

class CalendarCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDataSource, UITableViewDelegate {
    
    //MARK:- Properties
    var calendarNames: [String] = []
    var calendars: [PFObject] = []
    var events: [PFObject] = []
    var refreshControl: UIRefreshControl!
    
    //MARK:- Outlets
    @IBOutlet weak var allEventsTableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK:- View Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.calendarNames = []
        self.events = []
        queryParse()
    }
    
    //MARK:- Preparations
    func prepareView() {
        self.view.backgroundColor = UIColor(white: 1, alpha: 0.90)
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.collectionView.sendSubviewToBack(blurEffectView)
        self.view.sendSubviewToBack(blurEffectView)
        prepareCollectionView()
    }
    
    func prepareCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    //MARK:- UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.calendarNames.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cellIdentifier = "Cell"
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! CalendarCollectionViewCell
        
        cell.calendarImage.image = UIImage(named: "calendar")
        cell.calendarImage.contentMode = .ScaleAspectFill
        cell.calendarImage.clipsToBounds = true
        cell.groupLabel.text = calendarNames[indexPath.row]
        
        return cell
    }
    
    //MARK:- UITableViewDataSource
    func tableView( tableView : UITableView,  titleForHeaderInSection section: Int)->String? {
        return "Next Events"
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.events.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! AllCalendarsTableViewCell
        
        let nameString:String = self.events[indexPath.row]["name"] as! String
        
        let eventTime = self.events[indexPath.row]["hour"] as! NSDate
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMM d, yyyy hh:mm"
        
        let dateString: String = formatter.stringFromDate(eventTime)
        
        let todaysDate = NSDate()
        let interval = eventTime.timeIntervalSinceDate(todaysDate)
        
        print(interval)
        
        cell.event = self.events[indexPath.row]
        
        cell.titleLabel.text = nameString
        cell.dateLabel.text = dateString
        
        if interval < 86400 && interval > 0 {
            cell.intervalLabel.text = (String(format: "In %.0f hours", interval/3600))
        } else if (interval > 86400){
            cell.intervalLabel.text = (String(format:"In %.0f days",interval/86400))
            
        }
        
        return cell
    }
    
    //MARK:- UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = self.allEventsTableView.cellForRowAtIndexPath(indexPath)
        NSLog("did select and the text is \(cell?.textLabel?.text)")
    }
    
    //MARK:- Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showCalendar" {
            let calendarVC = segue.destinationViewController as! CalendarViewController
            
            if let selectedCell = sender as? CalendarCollectionViewCell {
                let indexPath = collectionView.indexPathForCell(selectedCell)!
                calendarVC.calendarObject = calendars[indexPath.row]
            }
        } else if segue.identifier == "EventDetailsSegue" {
            let eventDetailsVC = segue.destinationViewController as! CalendarDetailsViewController
            eventDetailsVC.eventObject = (sender as! AllCalendarsTableViewCell).event
        }
    }
    
    //MARK:- Helpers
    func stringFromTimeInterval(interval: NSTimeInterval) -> String {
        let interval = Int(interval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
}

private extension CalendarCollectionViewController {
    
    func queryParse() {
        let currentUser = PFUser.currentUser()
        let query = PFQuery(className:"Calendar")
        query.whereKey("usernames", equalTo: currentUser!["username"])
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil && objects != nil {
                for object in objects! {
                    let calendarTitle = object["title"] as! String
                    self.calendarNames.append(calendarTitle)
                }
                dispatch_async(dispatch_get_main_queue()){
                    self.collectionView.reloadData()
                    self.calendars = objects!
                    self.queryParseForEvents()
                    self.collectionView.reloadData()
                }
            } else {
                print(error?.localizedDescription)
            }
        }
    }
    
    func queryParseForEvents() {
        for calendar in self.calendars {
            let relation = calendar.relationForKey("events")
            let query = relation.query()
            
            query.findObjectsInBackgroundWithBlock {
                (objects: [PFObject]?, error: NSError?) -> Void in
                if error == nil && objects != nil {
                    print("Events \(self.events)")
                    let now = NSDate()
                    for object in objects! {
                        if (object["hour"] as! NSDate).compare(now) == .OrderedDescending {
                            self.events.append(object)
                        }
                    }
                    self.events.sortInPlace({ (a, b) -> Bool in
                        (a["hour"] as! NSDate).compare((b["hour"] as! NSDate)) == .OrderedAscending
                    })
                    dispatch_async(dispatch_get_main_queue(), {
                        self.allEventsTableView.reloadData()
                    })
                    
                } else {
                    print(error)
                }
            }
        }
    }
}
