//
//  SignInViewController.swift
//  SchedulingApp
//
//  Created by Zeal on 4/21/16.
//  Copyright © 2016 Jake Zeal. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController, UITextFieldDelegate {
    
    // MARK:- Constants
    struct SignInViewControllerConstants {
        static let successTitle = "Welcome back!"
        static let successMessage = "User Logged In"
        static let successActionTitle = "Dismiss"
        static let errorTitle = "User not found!"
        static let errorMessage = "Please sign up"
        static let errorActionTitle = "OK"
    }
    
    // MARK:- Outlets
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK:- Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextFields()
        preparePasswordSignIn()
    }
    
    // MARK:- Preparations
    func preparePasswordSignIn() {
        self.passwordTextField.secureTextEntry = true
    }
    
    // MARK:- Actions
    @IBAction func loginButtonPressed(sender: AnyObject) {
        let username = usernameTextField.text
        let password = passwordTextField.text
        
        if !(username ?? "").isEmpty && !(password ?? "").isEmpty {
            userSignIn(username!, password: password!)
            segueToCalendarCollectionViewController()
            //** Determine which view we will go to based on account type. **//
        } else {
            showAlert()
        }
    }
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK:- Segues
        func segueToCalendarCollectionViewController() {
            performSegueWithIdentifier("CalendarCollectionViewController", sender: nil)
        }
    
    // MARK:- Helpers
    
    func setupTextFields() {
        usernameTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    func userSignIn(username: String, password: String) {
        DataManager.sharedInstance.signInUser(username, password: password) { (user, error) -> Void in
            if user != nil {
                self.showAlert(SignInViewControllerConstants.successTitle, message: SignInViewControllerConstants.successMessage)
            } else {
                self.showAlert()
            }
        }
    }
}

// MARK:- Private Extensions
private extension SignInViewController {
    
    func showAlert() {
        showAlert(SignInViewControllerConstants.errorTitle, message: SignInViewControllerConstants.errorMessage, actionTitle: SignInViewControllerConstants.errorActionTitle)
    }
    
    func showAlert(title:String, message:String) {
        showAlert(title, message: message, actionTitle: SignInViewControllerConstants.errorActionTitle)
    }
    
    func showAlert(title:String, message:String, actionTitle:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: actionTitle, style: .Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}
