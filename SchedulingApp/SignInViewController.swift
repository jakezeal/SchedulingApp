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
    
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK:- Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTextFields()
        preparePasswordSignIn()
        prepareSubviews()
    }
    
    override func awakeFromNib() {
        
    }
    
    // MARK:- Preparations
    func preparePasswordSignIn() {
        self.passwordTextField.secureTextEntry = true
    }
    
    func prepareSubviews() {
        self.loginButton.addShadow()
        self.usernameTextField.addShadow()
        self.passwordTextField.addShadow()
    }
    
    func prepareTextFields() {
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        setupTextFieldViews()
    }
    
    func setupTextFieldViews() {
        usernameTextField.leftViewMode = .Always
        let imageView = UIImageView(image: UIImage(named: "User"))
        
        imageView.contentMode = UIViewContentMode.Center
        imageView.frame = CGRectMake(0.0, 0.0, imageView.image!.size.width + 20.0, imageView.image!.size.height)
        usernameTextField.leftView = imageView
        
        passwordTextField.leftViewMode = .Always
        let imageView2 = UIImageView(image: UIImage(named: "Lock"))
        
        imageView2.contentMode = UIViewContentMode.Center
        imageView2.frame = CGRectMake(0.0, 0.0, imageView2.image!.size.width + 20.0, imageView2.image!.size.height)
        passwordTextField.leftView = imageView2
    }
    
    // MARK:- Actions
    @IBAction func loginButtonPressed(sender: AnyObject) {
        let username = usernameTextField.text
        let password = passwordTextField.text
        
        if !(username ?? "").isEmpty && !(password ?? "").isEmpty {
            userSignIn(username!, password: password!)
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
    

    
    func userSignIn(username: String, password: String) {
        DataManager.sharedInstance.signInUser(username, password: password) { (user, error) -> Void in
            if user != nil {
                self.segueToCalendarCollectionViewController()
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
