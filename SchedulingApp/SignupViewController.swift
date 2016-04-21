//
//  SignUpViewController.swift
//  TrainingApp
//
//  Created by Zeal on 2016-04-18.
//  Copyright © 2016 Jake Zeal. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    // MARK:- Constants
    struct SignUpViewControllerConstants {
        static let successMessage = "You Signed Up!"
        static let successTitle = "Success"
        static let errorTitle = "Warning"
        static let errorMessage = "All Fields Required"
        static let errorActionTitle = "Dismiss"
    }
    
    // MARK:- Outlets
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField:    UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var usernameSignUp: UITextField!
    @IBOutlet weak var passwordSignUp: UITextField!
    
    // MARK:- Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTextFields()
    }
    
    // MARK:- Preperations
    func prepareTextFields() {
        usernameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        self.passwordSignUp.secureTextEntry = true
    }
    
    // MARK:- Actions
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func signUpButtonPressed(sender: AnyObject) {
        let username = usernameTextField.text
        let password = passwordTextField.text
        let isTrainer = true
        
        if !(username ?? "").isEmpty && !(password ?? "").isEmpty {
            userSignup(username!, password: password!, isTrainer: isTrainer)
        } else {
            showAlert()
        }
    }
    
    // MARK:- Helpers
    func userSignup(username:String, password:String, isTrainer: Bool) {
        DataManager.sharedInstance.signUpUser(username, password: password) { (succeeded, error) -> Void in
            if error == nil {
                self.showAlert(SignUpViewControllerConstants.successTitle, message: SignUpViewControllerConstants.successMessage)
            } else {
                self.showAlert()
            }
        }
    }
}

//MARK:- Private Extensions
private extension SignUpViewController {
    
    func showAlert() {
        showAlert(SignUpViewControllerConstants.errorTitle, message: SignUpViewControllerConstants.errorMessage, actionTitle: SignUpViewControllerConstants.errorActionTitle)
    }
    
    func showAlert(title:String, message:String) {
        showAlert(title, message: message, actionTitle: SignUpViewControllerConstants.errorActionTitle)
    }
    
    func showAlert(title:String, message:String, actionTitle:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: actionTitle, style: .Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}
