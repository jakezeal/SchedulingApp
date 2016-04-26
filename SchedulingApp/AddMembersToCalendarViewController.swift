//
//  AddMembersToCalendarViewController.swift
//  SchedulingApp
//
//  Created by Zeal on 4/22/16.
//  Copyright © 2016 Jake Zeal. All rights reserved.
//

import UIKit
import Parse

class AddMembersToCalendarViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
    
    // MARK:- Properties
    var userExists:Bool!
    var users:[User] = []
    var usernames:[String] = []
    
    // MARK:- Outlets
    @IBOutlet weak var calendarTextField: UITextField!
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTableView()
    }
    
    // MARK:- Preperations
    func prepareTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK:- Actions
    @IBAction func addMemberAction(sender: AnyObject) {
        doesUserExist()
    }
    
    @IBAction func saveCalendar(sender: UIBarButtonItem) {
        saveCalendar()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK:- UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! AddMembersTableViewCell
        
        let user: User = self.users[indexPath.row]
        cell.userLabel.text = user.name
        
        return cell
    }
    
    // MARK:- Helpers
    func doesUserExist() {
        queryUsers()
    }
    
    func handleUser() {
        if self.userExists == true {
            let user = User()
            user.name = self.userTextField.text!
            self.users.insert(user,atIndex:0)
            //make an array of usernames at same time
            self.usernames.append(user.name!)
            self.tableView.reloadData()
            self.userTextField.text = ""
        } else {
            let alertController = UIAlertController(title: "User does not exist!", message: "Please check spelling and try again", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func queryUsers() {
        DataManager.sharedInstance.queryUsersWithTextField(self.userTextField.text!) { (objects, error) in
            
            if error == nil {
                if objects!.count > 0 {
                    self.userExists = true
                } else {
                    self.userExists = false
                }
                if let objects = objects {
                    for object in objects {
                        if let result = object["username"] as? String {
                            print(result)
                        }
                    }
                    self.handleUser()
                }
            } else {
                print("Error: \(error!.localizedDescription) \(error!.userInfo)")
            }
        }
    }
    
    func saveCalendar() {
        // Save calendar name, users associated with it and 0 events.
        let cal = PFObject(className:"Calendar")
        cal["title"] = self.calendarTextField.text
        cal["usernames"] = self.usernames
        
        cal.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                //print("Users saved.")
                print(cal["usernames"])
                
                //dispatch_async(dispatch_get_main_queue(),{
                //
                //                })
            } else {
                print("Error ==>>> \(error?.localizedDescription)")
            }
        }
    }
}
