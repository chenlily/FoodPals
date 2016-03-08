//
//  WelcomeViewController.swift
//  FoodPals
//
//  Created by Wei, Yunhan on 3/7/16.
//  Copyright © 2016 PuppyCuddlers. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class CreateAccountController: UIViewController{
    
    @IBOutlet weak var nameEntry: UITextField!
    @IBOutlet weak var phoneNumberEntry: UITextField!
    @IBOutlet weak var emailEntry: UITextField!
    @IBOutlet weak var passwordEntry: UITextField!
    @IBOutlet weak var confirmPassEntry: UITextField!
    
    override func viewDidLoad() {
        
    }
    
    override func didReceiveMemoryWarning() {
        
    }
    
    @IBAction func createAccount(sender: AnyObject) {
    }

 
    @IBAction func cancelCreateAccount(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {})
    }
}
