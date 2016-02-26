//
//  ViewController.swift
//  FoodPals
//
//  Created by Lily Chen on 2/25/16.
//  Copyright © 2016 PuppyCuddlers. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // MARK: Properties
    @IBOutlet weak var fromText: UILabel!
    @IBOutlet weak var availSwitch: UISwitch!
    @IBOutlet var fromDatePicker: UIDatePicker!
    @IBOutlet var toDatePicker: UIDatePicker!
    @IBOutlet weak var findPalsButton: UIButton!
    @IBOutlet weak var toText: UILabel!
    @IBOutlet weak var secondStackView: UIStackView!
    
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
        print("hello")
        fromDatePickerChanged(fromDatePicker)
        toDatePickerChanged(toDatePicker)
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
        print("wazzah");
        let timeFormatter = NSDateFormatter()
    
        timeFormatter.dateStyle = NSDateFormatterStyle.NoStyle
        timeFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
    
        let strTime = timeFormatter.stringFromDate(fromDatePicker.date)
        print(strTime)
    }
    
    func toDatePickerChanged(toDatePicker:UIDatePicker){
        print("wazzah2");
        let timeFormatter = NSDateFormatter()
        
        timeFormatter.dateStyle = NSDateFormatterStyle.NoStyle
        timeFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        let strTime = timeFormatter.stringFromDate(toDatePicker.date)
        print(strTime)
    }

    @IBAction func fromDatePickerAction(sender: AnyObject) {
        
    }
    
    @IBAction func toDatePickerAction(sender: AnyObject) {
        
    }
}

