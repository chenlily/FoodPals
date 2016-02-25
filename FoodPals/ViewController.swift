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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("view loaded")
        
        availSwitch.addTarget(self, action: Selector("availStateChanged:"), forControlEvents: UIControlEvents.ValueChanged)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    @IBAction func findPals(sender: UIButton) {
        print("hello")
    }
    @IBAction func availSwitchPressedAction(sender: UISwitch) {
    }
    
    func availStateChanged(switchState: UISwitch) {
        if switchState.on {
            print("its on")
        } else {
            print("its off")
        }
    }

    @IBAction func fromDatePickerAction(sender: AnyObject) {
        
    }
    
    @IBAction func toDatePickerAction(sender: AnyObject) {
        
    }
}

