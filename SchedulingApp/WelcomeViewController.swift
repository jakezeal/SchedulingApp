//
//  WelcomeViewController.swift
//  Artoogo
//
//  Created by Zeal on 2016-04-18.
//  Copyright © 2015 Jake Zeal. All rights reserved.
//

import UIKit

class WelcomeViewController : UIViewController {
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true
    }
    
    
    @IBAction func signUpButtonPressed(sender: AnyObject) {
        
    }
 
    @IBAction func loginButtonPressed(sender: AnyObject) {
        
    }
    
}
