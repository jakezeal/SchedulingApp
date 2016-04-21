//
//  ForgotPasswordViewController.swift
//  Artoogo
//
//  Created by Zeal on 2016-04-18.
//  Copyright © 2016 Jake Zeal. All rights reserved.
//

import UIKit

class ForgotPasswordViewController : UIViewController {
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var sendEmailButton: UIButton!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func sendEmailButtonPressed(sender: AnyObject) {
        
    }
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
