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
import ChameleonFramework

class WelcomeViewController: UIViewController{
    
    @IBOutlet weak var emailEntry: UITextField!
    @IBOutlet weak var passwordEntry: UITextField!
    @IBOutlet weak var createNewAcct: UIButton!
    @IBOutlet weak var logIn: UIButton!
    
    override func viewDidLoad() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        logIn.backgroundColor = UIColor.flatSkyBlueColor()
        
        var paddingView = UIView(frame: CGRectMake(0, 0, 15, self.emailEntry.frame.height))
        emailEntry.leftView = paddingView
        emailEntry.leftViewMode = UITextFieldViewMode.Always
        
        paddingView = UIView(frame: CGRectMake(0, 0, 15, self.passwordEntry.frame.height))
        passwordEntry.leftView = paddingView
        passwordEntry.leftViewMode = UITextFieldViewMode.Always
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // If we have the uid stored, the user is already logged in
        
        if NSUserDefaults.standardUserDefaults().valueForKey("uid") != nil && DataService.dataService.CURRENT_USER_REF.authData != nil {
            self.performSegueWithIdentifier("LoggedIn", sender: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        
    }
    
    @IBAction func loginButton(sender: AnyObject) {
        let email = emailEntry.text
        let password = passwordEntry.text
        
        if email != "" && password != "" {
            // Login with the Firebase authUser method
            
            DataService.dataService.BASE_REF.authUser(email, password: password, withCompletionBlock: { error, authData in
                
                if error != nil {
                    print(error)
                    self.loginErrorAlert("Oops!", message: "Check your username and password")
                } else {
                    // Be sure the correct uid is stored
                    NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: "uid")
                    
                    // Enter the app!
                    self.performSegueWithIdentifier("LoggedIn", sender: nil)
                }
            })
        } else {
            // There was a problem
            loginErrorAlert("Oops!", message: "Don't forget to enter your email and password")
        }
    }
    
    func loginErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "Okay", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func doneCreateAccount(unwindSegue: UIStoryboardSegue) {
    }
    
}
