//
//  ViewController.swift
//  FoodPals
//
//  Created by Lily Chen on 2/25/16.
//  Copyright © 2016 PuppyCuddlers. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    // MARK: Properties
    @IBOutlet weak var fromText: UILabel!
    @IBOutlet weak var availSwitch: UISwitch!
    @IBOutlet var fromDatePicker: UIDatePicker!
    @IBOutlet var toDatePicker: UIDatePicker!
    @IBOutlet weak var findPalsButton: UIButton!
    @IBOutlet weak var toText: UILabel!
    @IBOutlet weak var secondStackView: UIStackView!
    @IBOutlet weak var welcomeMessage: UILabel!
    // This is the link that data will be sent to
    let ref = Firebase(url: "https://incandescent-torch-9100.firebaseIO.com/")
    let userInfoRef = Firebase(url: "https://incandescent-torch-9100.firebaseIO.com/user_information")
    
    // Dummy data
    let yunhan = ["from": "12:00 PM", "to": "1:00 PM"]
    let kaylee = ["from": "11:00 AM", "to": "12:00 PM"]
    
    // The current FoodPals user
    var user = ["from": "", "to": ""]
    
    var from = ""
    var to = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("view loaded")
        
        availSwitch.addTarget(self, action: Selector("availStateChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        
        DataService.dataService.CURRENT_USER_REF.observeEventType(FEventType.Value, withBlock: { snapshot in
            
            let currentUser = snapshot.value.objectForKey("name") as! String
            
            self.welcomeMessage.text = "Welcome, " + currentUser + "!"
            
        })
        
        //DEBUGGING
        //calls fromDatePickerChanged function every time the fromTIme is changed
        //fromDatePicker.addTarget(self, action: Selector("fromDatePickerChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        
        //DEBUGGING
        //calls toDatePickerChanged function every time the toTime is changed
        //toDatePicker.addTarget(self, action: Selector("toDatePickerChanged:"), forControlEvents: UIControlEvents.ValueChanged)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    @IBAction func findPals(sender: UIButton) {
        print("Pressed Find FoodPals")
        fromDatePickerChanged(fromDatePicker)
        toDatePickerChanged(toDatePicker)
        // K: When you click "Find FoodPals," data will be sent to Firebase
        let userAvailabilityRef = ref.childByAppendingPath("user_availability")
        let availableUsers = ["yunhan": yunhan, "kaylee": kaylee, "lily": user]
        userAvailabilityRef.setValue(availableUsers)
        
        let userID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
        print("User ID: ", userID)
        
        var phoneNumber = ""
        let ref2 = Firebase(url: "https://incandescent-torch-9100.firebaseio.com/users/" + userID + "/phoneNumber")
        ref2.observeEventType(.Value, withBlock: { snapshot in
            //phoneNumber = (snapshot.value as? String)!
            print("Snapshot: ", snapshot.value)
            phoneNumber = snapshot.value as! String
            print("Phone number: ", phoneNumber)
            
            let userToUpdate = self.userInfoRef.childByAppendingPath(phoneNumber)
            print(userToUpdate)
            let fromUpdate = ["from": self.from]
            let toUpdate = ["to": self.to]
            userToUpdate.updateChildValues(fromUpdate)
            userToUpdate.updateChildValues(toUpdate)
            
            }, withCancelBlock: { error in
                print(error.description)
        })
        
    }
    @IBAction func availSwitchPressedAction(sender: UISwitch) {
    }
    
    func availStateChanged(switchState: UISwitch) {
        if switchState.on {
            print("its on")
            secondStackView.hidden = false
            toDatePicker.userInteractionEnabled = true
            fromDatePicker.userInteractionEnabled = true
            findPalsButton.enabled = true
            
        } else {
            print("its off")
            secondStackView.hidden = true
            toDatePicker.userInteractionEnabled = false
            fromDatePicker.userInteractionEnabled = false
            findPalsButton.enabled = false

        }
    }
    
    func fromDatePickerChanged(fromDatePicker:UIDatePicker) {
        print("Changed from time");
        let timeFormatter = NSDateFormatter()
    
        timeFormatter.dateStyle = NSDateFormatterStyle.NoStyle
        timeFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
    
        let strTime = timeFormatter.stringFromDate(fromDatePicker.date)
        print(strTime)
        
        from = strTime
    }
    
    func toDatePickerChanged(toDatePicker:UIDatePicker){
        print("Changed to time");
        let timeFormatter = NSDateFormatter()
        
        timeFormatter.dateStyle = NSDateFormatterStyle.NoStyle
        timeFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        let strTime = timeFormatter.stringFromDate(toDatePicker.date)
        print(strTime)
        
        to = strTime
    }
    @IBAction func logout(sender: AnyObject) {
        
        // unauth() is the logout method for the current user.
        DataService.dataService.CURRENT_USER_REF.unauth()
        
        // Remove the user's uid from storage.
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: "uid")
        
        // Head back to login
        let loginViewController = self.storyboard!.instantiateViewControllerWithIdentifier("Login")
        
        UIApplication.sharedApplication().keyWindow?.rootViewController = loginViewController
    }

    @IBAction func fromDatePickerAction(sender: AnyObject) {
        
    }
    
    @IBAction func toDatePickerAction(sender: AnyObject) {
        
    }
    
    @IBAction func doneButton(unwindSegue: UIStoryboardSegue) {
        print("Pressed Done")
    }
    @IBAction func doneAddContacts(unwindSegue: UIStoryboardSegue) {
    }
    
}

