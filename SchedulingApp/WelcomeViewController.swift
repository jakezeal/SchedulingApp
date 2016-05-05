//
//  WelcomeViewController.swift
//  SchedulingApp
//
//  Created by Zeal on 2016-04-18.
//  Copyright © 2015 Jake Zeal. All rights reserved.
//

import UIKit

class WelcomeViewController : UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    //MARK:- Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        prepareImageView()
        prepareSubviews()
    }
    
    //MARK:- Preparations
    func prepareView() {
       self.navigationController?.navigationBarHidden = true
    }
    
    func prepareImageView() {
        self.imageView.image = UIImage(named: "Calendar-1")
    }
    
    func prepareSubviews() {
        self.signUpButton.addShadow()
        self.loginButton.addShadow()
    }
    
    //MARK:- Actions
    @IBAction func signUpButtonPressed(sender: AnyObject) {
        
    }
 
    @IBAction func loginButtonPressed(sender: AnyObject) {
        
    }
    
}
