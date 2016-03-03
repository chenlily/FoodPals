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
    // K: This is the link that data will be sent to
    let ref = Firebase(url: "https://incandescent-torch-9100.firebaseIO.com/")
    
    // K: Dummy data
    let yunhan = ["from": "12:00 PM", "to": "1:00 PM"]
    let kaylee = ["from": "11:00 AM", "to": "12:00 PM"]
    
    // K: the current FoodPals user
    var user = ["from": "", "to": ""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("view loaded")
        
        availSwitch.addTarget(self, action: Selector("availStateChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        
        
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
    }
    @IBAction func availSwitchPressedAction(sender: UISwitch) {
    }
    
    func availStateChanged(switchState: UISwitch) {
        if switchState.on {
            print("its on")
//            secondStackView.hidden = false
            toDatePicker.userInteractionEnabled = true
            fromDatePicker.userInteractionEnabled = true
            findPalsButton.enabled = true
            
        } else {
            print("its off")
//            secondStackView.hidden = true
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
        
        // K: Update from time for current user
        user.updateValue(strTime, forKey: "from")
    }
    
    func toDatePickerChanged(toDatePicker:UIDatePicker){
        print("Changed to time");
        let timeFormatter = NSDateFormatter()
        
        timeFormatter.dateStyle = NSDateFormatterStyle.NoStyle
        timeFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        let strTime = timeFormatter.stringFromDate(toDatePicker.date)
        print(strTime)
        
        // K: Update to time for current user
        user.updateValue(strTime, forKey: "to")
    }

    @IBAction func fromDatePickerAction(sender: AnyObject) {
        
    }
    
    @IBAction func toDatePickerAction(sender: AnyObject) {
        
    }
}

