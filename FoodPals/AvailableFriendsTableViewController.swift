//
//  AvailableFriendsTableViewController.swift
//  FoodPals
//
//  Created by Schonsheck, Kaylee on 3/3/16.
//  Copyright © 2016 PuppyCuddlers. All rights reserved.
//

import UIKit
import Firebase

class AvailableFriendsTableViewController: UITableViewController {
    
    // MARK: Properties
    var userTo = String()
    var userFrom = String()
    var foodPals = [FoodPal]()
    let messageComposer = MessageComposer()
    var numbersToText = Set<String>()
    
    var aFrom = "11:00 AM"
    var aTo = "12:00 PM"
    
    var bFrom = "2:30 PM"
    var bTo = "4:00 PM"

    var fromArr = ["11:00 AM", "2:30 PM"]
    var toArray = ["12:00 PM","4:00 PM"]
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSampleAvailableFriends()
        print("touch me")
        //findAvailFriends()
        // Load the sample friend data
        
    }
    
    func findAvailFriends(){
        // obtain user's phone number 
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        dateFormatter.dateFormat = "hh:mm a"
        //dateFormatter converts it to the correct time
        
        let userFromNS = dateFormatter.dateFromString(userFrom)
        let userToNS = dateFormatter.dateFromString(userTo)
        
        
        let uid = ( NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String)
        let ref = Firebase(url: "\(BASE_URL)/users/" + uid + "/phoneNumber")
        var phoneNumber = String()
        ref.observeEventType(.Value, withBlock: { snapshot in
            phoneNumber = ("\(snapshot.value)")
            let ref3 = Firebase(url: "\(BASE_URL)/user_information/" + phoneNumber + "/friends")
            ref3.observeEventType(.Value, withBlock: { snapshot in
                let numbersToParse = "\(snapshot.value)"
                var numbersToParseArray = numbersToParse.characters.split{$0 == " "}.map(String.init)
                var parsedNumbers = Set<String>() //current user friends
                if numbersToParseArray.count>3{
                    numbersToParseArray.removeFirst(3)
                    for var i = 0; i<numbersToParseArray.count; i+=3 {
                        var temp = numbersToParseArray[i]
                        temp = temp.stringByTrimmingCharactersInSet(NSCharacterSet.punctuationCharacterSet())
                        temp = temp.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                        temp = temp.stringByTrimmingCharactersInSet(NSCharacterSet.punctuationCharacterSet())
                        parsedNumbers.insert(temp)
                    }
                }
                print(parsedNumbers)
                
                //go through all the numbers in parsedNumbers (the users friends
                //find who has overlapping time
                for var number in parsedNumbers{
                    var refF = Firebase(url: "\(BASE_URL)/user_information/" + number + "/from")
                    var refT = Firebase(url: "\(BASE_URL)/user_information/" + number + "/to")
                    var refN = Firebase(url: "\(BASE_URL)/user_information/" + number + "/name")
                    //var fromNS = NSDate()
                    //var toNS = NSDate()
                    
                    
                    refF.observeEventType(.Value, withBlock: { snapshot in
                        var from = "\(snapshot.value)"
                        var fromNS = dateFormatter.dateFromString(from)!
                        refT.observeEventType(.Value, withBlock: { snapshot in
                            var to = "\(snapshot.value)"
                            var toNS = dateFormatter.dateFromString(to)!
                            if self.isAvail(fromNS, to: toNS) {
                                print("YASSSSSSSSSS")
                                refN.observeEventType(.Value, withBlock: { snapshot in
                                    //print("\(snapshot.value)")
                                    let pal = FoodPal(first_name:"\(snapshot.value)", last_name:"", from:from, to:to, phone_number: number)!
                                    self.foodPals += [pal]
                                    print(number)
                                    print(self.foodPals)
                                    self.tableView.reloadData()
                                    
                                }, withCancelBlock: { error in
                                    print(error.description)
                            })
                            }
                            
                            }, withCancelBlock: { error in
                                print(error.description)
                        })
                        
                        
                    }, withCancelBlock: { error in
                            print(error.description)
                    })
                        
                }
                
                
                }, withCancelBlock: { error in
                    print(error.description)
            })
            
            }, withCancelBlock: { error in
                print(error.description)
        })
        
        //print(userFromNS!.isLessThanDate(userToNS!))
        
//        for var i=0; i<fromArr.count; i++ {
//            // convert times
//            let fr = dateFormatter.dateFromString(fromArr[i])
//            let to = dateFormatter.dateFromString(toArray[i])
//            if (fr!.isLessThanDate(userFromNS!) || to!.isEqualToDate(userFromNS!)) && to!.isGreaterThanDate(userFromNS!)  {
//                // ADD EQUAL TO for all statements
//                // valid
//                print("valid1 " + String(i))
//            } else if fr!.isLessThanDate(userToNS!) && (to!.isGreaterThanDate(userToNS!) || to!.isEqualToDate(userToNS!))   {
//                print("valid2")
//            } else if (fr!.isGreaterThanDate(userFromNS!) || fr!.isEqualToDate(userFromNS!)) && (to!.isLessThanDate(userToNS!) || to!.isEqualToDate(userToNS!)) {
//                print("valid3")
//            } else {
//                print("invalid")
//            }
//        }
        
    }
    
    func isAvail(from: NSDate, to: NSDate)->Bool{
        var returnBool = false
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        dateFormatter.dateFormat = "hh:mm a"
        let userFromNS = dateFormatter.dateFromString(userFrom)
        let userToNS = dateFormatter.dateFromString(userTo)
        
        if (from.isLessThanDate(userFromNS!) || to.isEqualToDate(userFromNS!)) && to.isGreaterThanDate(userFromNS!)  {
            returnBool = true
        } else if from.isLessThanDate(userToNS!) && (to.isGreaterThanDate(userToNS!) || to.isEqualToDate(userToNS!))   {
            returnBool = true
        } else if (from.isGreaterThanDate(userFromNS!) || from.isEqualToDate(userFromNS!)) && (to.isLessThanDate(userToNS!) || to.isEqualToDate(userToNS!)) {
            returnBool = true
        } else {
            returnBool = false
        }
        return returnBool
    }
    
    func loadSampleAvailableFriends() {
        let pal1 = FoodPal(first_name: "Kevin", last_name: "Cai", from: "April 13 5:30 PM", to: "April 13 7:00 PM", phone_number: "55555555")!
        let pal2 = FoodPal(first_name: "Jonathan", last_name: "Edwards", from: "April 13 6:00 PM", to: "April 13 7:00 PM", phone_number: "666666666")!
        let pal3 = FoodPal(first_name: "Josh", last_name: "Campbell" , from: "April 13 6:15 PM", to: "April 13 7:00 PM", phone_number: "7777777777")!
        let pal4 = FoodPal(first_name: "Chuckie", last_name: "Daniels" , from: "April 13 6:00 PM", to: "April 13 7:00 PM", phone_number: "7777777777")!
        foodPals += [pal1, pal2, pal3, pal4]
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
        cell.phoneNumber = foodPal.phoneNumber
        
        if indexPath.row % 2 == 1 {
            cell.backgroundColor = UIColor(red: 249/255, green: 250/255, blue: 250/255, alpha: 1.0)
        } else {
            cell.backgroundColor = UIColor.whiteColor();
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as? AvailableTableViewCell
        if cell != nil {
            let toAdd = cell!.phoneNumber
            if cell!.selected
            {
                cell!.selected = false
                if cell!.accessoryType == UITableViewCellAccessoryType.None
                {
                    cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
                    //print(cell.NumberText.text)
                    //if numbersToAdd.contains()
                    if numbersToText.contains(toAdd) {
                        
                    } else {
                        numbersToText.insert(toAdd)
                    }
                    
                } else {
                    cell!.accessoryType = UITableViewCellAccessoryType.None
                    if numbersToText.contains(toAdd) {
                        numbersToText.remove(toAdd)
                    } else {
                        
                    }
                    
                }
            }
            
        }
        print("numberstotext")
        print(numbersToText)
    }
    
    
    @IBAction func textPalsButton(sender: AnyObject) {
        if (self.messageComposer.canSendText()) {
            // Obtain a configured MFMessageComposeViewController
            let messageComposeVC = self.messageComposer.configuredMessageComposeViewController()
            var recipients = [String]()
            for pal in numbersToText {
                recipients.append(pal)
            }
            messageComposeVC.recipients = recipients
            
            // Present the configured MFMessageComposeViewController instance
            // Note that the dismissal of the VC will be handled by the messageComposer instance,
            // since it implements the appropriate delegate call-back
            presentViewController(messageComposeVC, animated: true, completion: nil)
        } else {
            // Let the user know if his/her device isn't able to send text messages
            let errorAlert = UIAlertView(title: "Cannot Send Text Message", message: "Your device is not able to send text messages.", delegate: self, cancelButtonTitle: "OK")
            errorAlert.show()
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
