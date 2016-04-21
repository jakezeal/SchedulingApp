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
    
    //MARK:- Initializers
    init() {
        prepareParse()
    }
    
    //MARK:- Public Helpers
    func signUpUser(username:String, password:String, block:(Bool, NSError?) -> Void) {
        let user = PFUser()
        user.username = username
        user.password = password
        user.signUpInBackgroundWithBlock(block);
    }
    
    func signInTrainer(username:String, password:String, block:(PFUser?, NSError?) -> Void) {
        PFUser.logInWithUsernameInBackground(username, password: password, block: block)
    }
}

//MARK:- Extensions
private extension DataManager {
    
    func prepareParse() {
        Parse.initializeWithConfiguration(ParseClientConfiguration(block: { (configuration: ParseMutableClientConfiguration) -> Void in
            configuration.server = "https://training-app-final.herokuapp.com/parse/"
            configuration.applicationId = "myAppId"
            configuration.clientKey = ""
        }))
    }
}







