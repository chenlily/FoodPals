//
//  AvailableFriendsTableViewController.swift
//  FoodPals
//
//  Created by Schonsheck, Kaylee on 3/3/16.
//  Copyright © 2016 PuppyCuddlers. All rights reserved.
//

import UIKit

class AvailableFriendsTableViewController: UITableViewController {
    
    // MARK: Properties
    var userTo = String()
    var userFrom = String()
    var foodPals = [FoodPal]()
    let messageComposer = MessageComposer()
    
    var aFrom = "11:00 AM"
    var aTo = "12:00 PM"
    
    var bFrom = "2:30 PM"
    var bTo = "4:00 PM"

    var fromArr = ["11:00 AM", "2:30 PM"]
    var toArray = ["12:00 PM","4:00 PM"]
    override func viewDidLoad() {
        super.viewDidLoad()
        print("touch me")
        findAvailFriends()
        // Load the sample friend data
        loadSampleAvailableFriends()
    }
    
    func findAvailFriends(){
        // obtain user's phone number 
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        dateFormatter.dateFormat = "hh:mm a"
        //dateFormatter converts it to the correct time
        
        var userFromNS = dateFormatter.dateFromString(userFrom)
        var userToNS = dateFormatter.dateFromString(userTo)
        
        //print(userFromNS!.isLessThanDate(userToNS!))
        
        for var i=0; i<fromArr.count; i++ {
            // convert times
            var fr = dateFormatter.dateFromString(fromArr[i])
            var to = dateFormatter.dateFromString(toArray[i])
            if (fr!.isLessThanDate(userFromNS!) || to!.isEqualToDate(userFromNS!)) && to!.isGreaterThanDate(userFromNS!)  {
                // ADD EQUAL TO for all statements
                // valid
                print("valid1 " + String(i))
            } else if fr!.isLessThanDate(userToNS!) && (to!.isGreaterThanDate(userToNS!) || to!.isEqualToDate(userToNS!))   {
                print("valid2")
            } else if (fr!.isGreaterThanDate(userFromNS!) || fr!.isEqualToDate(userFromNS!)) && (to!.isLessThanDate(userToNS!) || to!.isEqualToDate(userToNS!)) {
                print("valid3")
            } else {
                print("invalid")
            }
        }
        
    }
    
    func loadSampleAvailableFriends() {
        let pal1 = FoodPal(first_name: "Kaylee", last_name: "Schonsheck", from: "11:30 AM", to: "12:30 PM")!
        let pal2 = FoodPal(first_name: "Yunhan", last_name: "Wei", from: "12:00 PM", to: "2:00 PM")!
        let pal3 = FoodPal(first_name: "Derek", last_name: "Siew" , from: "12:00 PM", to: "1:00 PM")!
        foodPals += [pal1, pal2, pal3]
        print("Loaded sample friends")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Show 1 section
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // One row per FoodPal
        return foodPals.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier
        let cellIdentifier = "AvailableTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! AvailableTableViewCell
        
        // Fetches the appropriate FoodPal for the data source layout
        let foodPal = foodPals[indexPath.row]

        print(foodPal.first_name, foodPal.last_name, foodPal.from, foodPal.to)
        
        cell.nameLabel.text = foodPal.first_name + " " + foodPal.last_name
        cell.availabilityLabel.text = foodPal.from + " to " + foodPal.to
        
        if indexPath.row % 2 == 1 {
            cell.backgroundColor = UIColor(red: 249/255, green: 250/255, blue: 250/255, alpha: 1.0)
        } else {
            cell.backgroundColor = UIColor.whiteColor();
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if cell != nil {
            
            if (messageComposer.canSendText()) {
                // Obtain a configured MFMessageComposeViewController
                let messageComposeVC = messageComposer.configuredMessageComposeViewController()
                
                // Present the configured MFMessageComposeViewController instance
                // Note that the dismissal of the VC will be handled by the messageComposer instance,
                // since it implements the appropriate delegate call-back
                presentViewController(messageComposeVC, animated: true, completion: nil)
            } else {
                // Let the user know if his/her device isn't able to send text messages
                let errorAlert = UIAlertView(title: "Cannot Send Text Message", message: "Your device is not able to send text messages.", delegate: self, cancelButtonTitle: "OK")
                errorAlert.show()
            }
            //            // Set the CellID
            //            var label:UILabel = UILabel()
            //            for subview in self.view.subviews {
            //                if subview is UILabel {
            //                    label = subview as UILabel
            //                    break
            //                }
            //            }
            //
            //            var cellID: AnyObject! = (label.text == nil) ? "" : label.text
            
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
