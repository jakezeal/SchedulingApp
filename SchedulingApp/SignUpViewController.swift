//
//  SignUpViewController.swift
//  TrainingApp
//
//  Created by Zeal on 2016-04-18.
//  Copyright © 2016 Jake Zeal. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    // MARK:- Outlets
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField:    UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK:- Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTextFields()
        prepareSubviews()
    }
    
    // MARK:- Preparations
    func prepareTextFields() {
        usernameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        self.passwordTextField.secureTextEntry = true
        setupTextFieldViews()
    }
    
    func prepareSubviews() {
        self.signUpButton.addShadow()
        self.usernameTextField.addShadow()
        self.emailTextField.addShadow()
        self.passwordTextField.addShadow()
    }
    
    func setupTextFieldViews() {
        //Username
        usernameTextField.leftViewMode = .Always
        let imageView = UIImageView(image: UIImage(named: "User"))
        
        imageView.contentMode = UIViewContentMode.Center
        imageView.frame = CGRectMake(0.0, 0.0, imageView.image!.size.width + 20.0, imageView.image!.size.height)
        usernameTextField.leftView = imageView
        
        //Email
        emailTextField.leftViewMode = .Always
        let imageView2 = UIImageView(image: UIImage(named: "Envelope"))
        
        imageView2.contentMode = UIViewContentMode.Center
        imageView2.frame = CGRectMake(0.0, 0.0, imageView2.image!.size.width + 20.0, imageView2.image!.size.height)
        emailTextField.leftView = imageView2
        
        //Password
        passwordTextField.leftViewMode = .Always
        let imageView3 = UIImageView(image: UIImage(named: "Lock"))
        
        imageView3.contentMode = UIViewContentMode.Center
        imageView3.frame = CGRectMake(0.0, 0.0, imageView3.image!.size.width + 20.0, imageView3.image!.size.height)
        passwordTextField.leftView = imageView3
    }
    
    // MARK:- Actions
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func signUpButtonPressed(sender: AnyObject) {
        let username = usernameTextField.text
        let password = passwordTextField.text
        
        if !(username ?? "").isEmpty && !(password ?? "").isEmpty {
            userSignup(username!, password: password!)
        } else {
            showAlert()
        }
    }
    
    // MARK:- Helpers
    func userSignup(username:String, password:String) {
        DataManager.sharedInstance.signUpUser(username, password: password) { (succeeded, error) -> Void in
            self.navigationController?.popViewControllerAnimated(true)
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
