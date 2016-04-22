//
//  AddMembersToCalendarViewController.swift
//  SchedulingApp
//
//  Created by Zeal on 4/22/16.
//  Copyright © 2016 Jake Zeal. All rights reserved.
//

import UIKit

class AddMembersToCalendarViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
    
    // MARK:- Properties
    var userExists:Bool!
    var users:[User] = []
    
    // MARK:- Outlets
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
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
            self.tableView.reloadData()
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
}