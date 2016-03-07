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
    
    var foodPals = [FoodPal]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Load the sample friend data
        loadSampleAvailableFriends()
    }
    
    func loadSampleAvailableFriends() {
        let pal1 = FoodPal(first_name: "Kaylee", last_name: "Schonsheck", from: "11:30 AM", to: "12:30 PM")!
        foodPals += [pal1]
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
        cell.availabilityLabel.text = foodPal.from + " " + foodPal.to
        
        return cell
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
