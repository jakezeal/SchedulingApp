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
    var cal = PFObject(className:"Calendar")
    var user = PFUser.currentUser()
    
    // MARK:- Outlets
    @IBOutlet weak var calendarTextField: UITextField!
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- View Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTableView()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        showAlert()
    }
    
    // MARK:- Preparations
    func prepareTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK:- Actions
    @IBAction func addMemberAction(sender: AnyObject) {
        doesUserExist()
    }
    
    @IBAction func saveCalendar(sender: UIBarButtonItem) {
        saveCalendarToParse { (result) in
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    // MARK:- UITableViewDataSource
    func tableView( tableView : UITableView,  titleForHeaderInSection section: Int)->String? {
        return "Group members"
    }
    
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
}

//MARK:- Private Extensions
private extension AddMembersToCalendarViewController {
    
    func showAlert() {
        let alertController = UIAlertController(title: "Create Calendar", message: "Enter a name for your calendar", preferredStyle: UIAlertControllerStyle.Alert)
        
        let saveAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {
            alert -> Void in
            let calendarName = alertController.textFields![0] as UITextField
            self.cal["title"] = calendarName.text
            self.title = calendarName.text
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: {
            (action : UIAlertAction!) -> Void in
            self.navigationController?.popViewControllerAnimated(true)
        })
        alertController.addTextFieldWithConfigurationHandler { (textField : UITextField!) -> Void in
            textField.placeholder = "Calendar name"
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
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
    
    func saveCalendarToParse(completion: (result: String) -> Void) {
        // Save initial calendar.
        
        let username = self.user!["username"] as! String
        self.usernames.append(username)
        self.cal["usernames"] = self.usernames
        
        cal.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                completion(result: "Yay")
            } else {
                print("Error ==>>> \(error?.localizedDescription)")
            }
        }
    }
    
}
