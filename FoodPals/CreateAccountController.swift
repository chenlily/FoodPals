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
    @IBOutlet weak var createAcct: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        createAcct.backgroundColor = UIColor.flatSkyBlueColor()
        //self.view.sendSubviewToBack(bgColor)
        
        var myTextField = nameEntry
        var paddingView = UIView(frame: CGRectMake(0, 0, 15, self.nameEntry.frame.height))
        myTextField.leftView = paddingView
        myTextField.leftViewMode = UITextFieldViewMode.Always
        
        myTextField = phoneNumberEntry
        paddingView = UIView(frame: CGRectMake(0, 0, 15, self.phoneNumberEntry.frame.height))
        myTextField.leftView = paddingView
        myTextField.leftViewMode = UITextFieldViewMode.Always
        
        myTextField = emailEntry
        paddingView = UIView(frame: CGRectMake(0, 0, 15, self.emailEntry.frame.height))
        myTextField.leftView = paddingView
        myTextField.leftViewMode = UITextFieldViewMode.Always
        
        myTextField = passwordEntry
        paddingView = UIView(frame: CGRectMake(0, 0, 15, self.passwordEntry.frame.height))
        myTextField.leftView = paddingView
        myTextField.leftViewMode = UITextFieldViewMode.Always
        
        myTextField = confirmPassEntry
        paddingView = UIView(frame: CGRectMake(0, 0, 15, self.confirmPassEntry.frame.height))
        myTextField.leftView = paddingView
        myTextField.leftViewMode = UITextFieldViewMode.Always
    }

    
    override func didReceiveMemoryWarning() {
        
    }

    
    @IBAction func createAccount(sender: AnyObject) {
        let name = nameEntry.text
        let phoneNumber = phoneNumberEntry.text
        let email = emailEntry.text
        
        if passwordEntry.text != confirmPassEntry.text {
            print("lol this guy messed up")
        }
        
        let password = passwordEntry.text
        
        if name != "" && email != "" && password != "" && phoneNumber != "" {
            
            // Set Email and Password for the New User.
            
            DataService.dataService.BASE_REF.createUser(email, password: password, withValueCompletionBlock: { error, result in
                
                if error != nil {
                    
                    // There was a problem.
                    self.signupErrorAlert("Oops!", message: "Having some trouble creating your account. Try again.")
                    
                } else {
                    
                    // Create and Login the New User with authUser
                    DataService.dataService.BASE_REF.authUser(email, password: password, withCompletionBlock: {
                        err, authData in
                        
                        let user = ["provider": authData.provider!, "email": email!, "name": name!, "phoneNumber": phoneNumber!]
//
//                        let user = ["provider": authData.provider!, "email": email!, "name": name!, "phoneNumber": phoneNumber!]
                        // Seal the deal in DataService.swift.
                        DataService.dataService.createNewAccount(authData.uid, user: user)
                    })
                    
                    // Store the uid for future access - handy!
                    NSUserDefaults.standardUserDefaults().setValue(result ["uid"], forKey: "uid")
                    
                    // Enter the app.
                    self.performSegueWithIdentifier("NewUserAddFriends", sender: nil)
                }
            })
            
        } else {
            signupErrorAlert("Oops!", message: "Don't forget to enter your email, password, phone number, and name.")
        }
        
        
        //THIS IS SHIT CODE
//        DataService.dataService.BASE_REF.authUser(email, password: password, withCompletionBlock: { error, authData in
//            
//            // Be sure the correct uid is stored
//            NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: "uid")
//                NSUserDefaults.standardUserDefaults().synchronize()
//            // Enter the app!
//            self.performSegueWithIdentifier("NewUserAddFriends", sender: nil)
//        })
        ////////////
        
    }
    
    func signupErrorAlert(title: String, message: String) {
        // Called upon signup error to let the user know signup didn't work.
    
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "Okay", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }

 
    @IBAction func cancelCreateAccount(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
