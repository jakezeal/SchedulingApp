//
//  DataManager.swift
//  TrainingApp
//
//  Created by Zeal on 4/18/16.
//  Copyright © 2016 Jake Zeal. All rights reserved.
//

import Foundation
import Parse

private let dataManagerSharedInstance = DataManager()

class DataManager {
    
    //MARK:- Properties
    class var sharedInstance: DataManager {
        return dataManagerSharedInstance
    }
    
    var calendarObject: PFObject?
    
    var calendar = PFObject(className:"Calendar")
    var user = PFUser.currentUser()
    
    //MARK:- Initializers
    init() {
        prepareParse()
        calendar = PFObject(className:"Calendar")
    }
    
    //MARK:- Public Helpers
    func signUpUser(username:String, password:String, block:(Bool, NSError?) -> Void) {
        let user = PFUser()
        user.username = username
        user.password = password
        user.signUpInBackgroundWithBlock(block)
    }
    
    func signInUser(username:String, password:String, block:(PFUser?, NSError?) -> Void) {
        PFUser.logInWithUsernameInBackground(username, password: password, block: block)
    }
    
    func queryUsersWithTextField(username: String, block:(PFQueryArrayResultBlock?)) {
        let query = PFUser.query()
        query!.whereKey("username", equalTo:username)
        query!.findObjectsInBackgroundWithBlock(block)
    }
    
    func queryCalendars(block:PFQueryArrayResultBlock?) {
        let relation = calendarObject!.relationForKey("events")
        let query = relation.query()
        query.findObjectsInBackgroundWithBlock(block)
    }
    
    func updateUser() {
        PFUser.currentUser()
        self.user = PFUser.currentUser()
    }
}

//MARK:- Private Extensions
private extension DataManager {    
    func prepareParse() {
        Parse.initializeWithConfiguration(ParseClientConfiguration(block: { (configuration: ParseMutableClientConfiguration) -> Void in
            configuration.server = "https://timesync-ios.herokuapp.com/parse/"
            configuration.applicationId = "timesyncAppId"
            configuration.clientKey = "keytimesynckey"
        }))
    }
}







