//
//  AddMembersToCalendarViewController.swift
//  SchedulingApp
//
//  Created by Zeal on 4/22/16.
//  Copyright © 2016 Jake Zeal. All rights reserved.
//

import UIKit

class AddMembersToCalendarViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK:- Properties
    var userExists:Bool!
    var users:[User] = []
    var usernames:[String] = []
    
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
        saveCalendar { 
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier(IdentifierConstants.cellIdentifier, forIndexPath: indexPath) as! AddMembersTableViewCell
        
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
        let alertController = UIAlertController(title: "Create Calendar", message: "Enter a name for your calendar", preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (action) in
            self.navigationController?.popViewControllerAnimated(true)
        }
        
        let saveAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            //Set calendar name and navigation bar title to user input text.
            if let calendarName = alertController.textFields?[0] {
                DataManager.sharedInstance.calendar["title"] = calendarName.text
                self.title = calendarName.text
            }
        }
        
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "Calendar name"
        }
        
        //Add Actions
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        //Present View Controller
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func queryUsers() {
        DataManager.sharedInstance.queryUsersWithTextField(self.userTextField.text!) { (objects, error) in
            
            guard error == nil else {
                print("Error: \(error!.localizedDescription) \(error!.userInfo)")
                return
            }
            
            guard let objects = objects where objects.count > 0 else {
                self.userExists = false
                self.handleUser()
                return
            }
            
            self.userExists = true
            self.handleUser()
        }
    }
    
    func saveCalendar(completion: () -> Void) {
        
        if let username = DataManager.sharedInstance.user?["username"] as? String {
            self.usernames.append(username)
            print(username)
        }
        
        DataManager.sharedInstance.calendar["usernames"] = self.usernames
        
        DataManager.sharedInstance.calendar.saveInBackgroundWithBlock { (success, error) in
            guard success else {
                print(error?.localizedDescription)
                return
            }
            completion()
        }
    }
}
