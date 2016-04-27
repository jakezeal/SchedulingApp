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

    var calendarNames: [String] = []
    var calendars: [PFObject] = []
    var events: [PFObject] = []
    var refreshControl: UIRefreshControl!

    @IBOutlet weak var allEventsTableView: UITableView!
    
    //MARK:- Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK:- Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(white: 1, alpha: 0.90)
        self.collectionView.backgroundColor = UIColor(white: 1, alpha: 0.90)
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        //always fill the view
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        self.collectionView.sendSubviewToBack(blurEffectView)
        self.view.sendSubviewToBack(blurEffectView)
        
        prepareCollectionView()

       
//        refreshControl = UIRefreshControl()
//        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
//        refreshControl.addTarget(self, action: #selector(CalendarCollectionViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
//        self.collectionView.addSubview(refreshControl) // not required when using UITableViewController
    }
//    func refresh(sender:AnyObject) {
//        collectionView.reloadData()
//        //refreshControl.endRefreshing()
//    }
    
    override func viewWillAppear(animated: Bool) {
        
        
        //query parse for user-specific calendars
        self.calendarNames = []
        self.events = []
        queryParse()
        //self.collectionView.reloadData()


    }
    
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
//                    print(self.calendarNames)
                }
                dispatch_async(dispatch_get_main_queue()){
                    self.collectionView.reloadData()
                    self.calendars = objects!
                    self.queryParseForEvents()
                    self.collectionView.reloadData()


                }
            } else {
                print(error)
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
//                        print(self.events)
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
    
    
    //MARK:- Preperations
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showCalendar" {
            let calendarVC = segue.destinationViewController as! CalendarViewController
            
            //Get the cell that generated this segue.
            if let selectedCell = sender as? CalendarCollectionViewCell {
                let indexPath = collectionView.indexPathForCell(selectedCell)!
                calendarVC.calendarObject = calendars[indexPath.row]
            }
        } else if segue.identifier == "EventDetailsSegue" {
            let eventDetailsVC = segue.destinationViewController as! CalendarDetailsViewController
            eventDetailsVC.eventObject = (sender as! AllCalendarsTableViewCell).event
            
        }
        
    }
    
    //Implement Table View
     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = self.allEventsTableView.cellForRowAtIndexPath(indexPath)
        NSLog("did select and the text is \(cell?.textLabel?.text)")
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    func tableView( tableView : UITableView,  titleForHeaderInSection section: Int)->String? {
        return "Next Events"
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section
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
        //let timeFromNow = stringFromTimeInterval(interval)
        
        print(interval)
        
        cell.event = self.events[indexPath.row]
        
        cell.titleLabel.text = nameString
        cell.dateLabel.text = dateString
        //cell.calendarNameLabel.text = calendarString
        
        if(interval < 86400 && interval > 0){
            cell.intervalLabel.text = (String(format: "In %.0f hours", interval/3600))
            // cell.intervalLabel.text = "In %.0f 3600 hours"
        }else if (interval > 86400){
            cell.intervalLabel.text = (String(format:"In %.0f days",interval/86400))
            
        }

        return cell
    }
    
    func stringFromTimeInterval(interval: NSTimeInterval) -> String {
        let interval = Int(interval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
}
