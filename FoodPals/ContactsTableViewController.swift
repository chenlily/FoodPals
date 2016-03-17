//
//  AddContacts.swift
//  FoodPals
//
//  Created by Wei, Yunhan on 3/7/16.
//  Copyright © 2016 PuppyCuddlers. All rights reserved.
//


import Foundation
import UIKit
import Firebase
import Contacts

class ContactsTableViewController: UITableViewController {
    
    var contacts = [Contact]()
    var cncontacts = [CNContact]()
    var numbersToAdd = Set<String>()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        loadSampleContact()
        getContacts()
        //addFriend("98765") //for debug
    }
    
    ////////////////grab valid contacts/////////////////////////////////////////////////////////////

    
    func getContacts() {
        print("Getting contacts")
        let store = CNContactStore()
        
        if CNContactStore.authorizationStatusForEntityType(.Contacts) == .NotDetermined {
            store.requestAccessForEntityType(.Contacts, completionHandler: { (authorized: Bool, error: NSError?) -> Void in
                if authorized {
                    self.retrieveContactsWithStore(store)
                }
            })
        } else if CNContactStore.authorizationStatusForEntityType(.Contacts) == .Authorized {
            self.retrieveContactsWithStore(store)
        } else {
            print("Bad")
        }
    }
    
    func retrieveContactsWithStore(store: CNContactStore) {
        do {
            let keysToFetch = [CNContactFormatter.descriptorForRequiredKeysForStyle(.FullName), CNContactPhoneNumbersKey]
            let containerId =  store.defaultContainerIdentifier()
            let predicate: NSPredicate = CNContact.predicateForContactsInContainerWithIdentifier(containerId)
            cncontacts = try store.unifiedContactsMatchingPredicate(predicate, keysToFetch: keysToFetch)

            print("initial list ", cncontacts.count)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            })
        } catch {
            print(error)
        }
    }
    
    ////////////////actual code for the view controller//////////////////////////////////////////////
    
    
    func loadSampleContact(){
        let contact1 = Contact(name: "Kayschonka", email:"kayshayshay@dinosaurs.com")!
        contacts += [contact1]
    }
    
    func loadContactsAddress(){
        
    }

    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Show 1 section
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // One row per Contact (GO KAYLEE)
        return cncontacts.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "ContactTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ContactTableViewCell
        
        let contact = cncontacts[indexPath.row]
        let formatter = CNContactFormatter()
        
        cell.NameText?.text = formatter.stringFromContact(contact)
        //cell.NumberText?.text = cont act.phoneNumbers.first?.value as? String
        //cell.NumberText?.text = contact.phoneNumbers[0].value as? String
        //print(contact.phoneNumbers[0].value as? String)
        let contactNumber = contact.phoneNumbers[0].value as! CNPhoneNumber
        //print(contactNumber.stringValue)
        //print("sanitized: " + sanitize(contactNumber.stringValue))
        cell.NumberText = sanitize(contactNumber.stringValue)
        //print(cell.NumberText)
        
        //print((contact.phoneNumbers[0].value as! CNPhoneNumber))
        //cell.EmailText?.text = contact.emailAddresses.first?.value as? String
        
        if indexPath.row % 2 == 1 {
            cell.backgroundColor = UIColor(red: 249/255, green: 250/255, blue: 250/255, alpha: 1.0)
        } else {
            cell.backgroundColor = UIColor.whiteColor();
        }
        
        //cell.imageView!.image = UIImage(named: "plus")
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! ContactTableViewCell
        //cell.addImage.image = UIImage(named: "plus")
        print(cell.NumberText)
        let toAdd = cell.NumberText
        if cell.selected
        {
            cell.selected = false
            if cell.accessoryType == UITableViewCellAccessoryType.None
            {
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                //print(cell.NumberText.text)
                //if numbersToAdd.contains()
                if numbersToAdd.contains(toAdd) {
                    
                } else {
                    numbersToAdd.insert(toAdd)
                }
                
            } else {
                cell.accessoryType = UITableViewCellAccessoryType.None
                if numbersToAdd.contains(toAdd) {
                    numbersToAdd.remove(toAdd)
                } else {
                    
                }
                
            }
            
            
        }
        print(numbersToAdd)
    }
    
    func addFriend(friendNumber : String){
        let userID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
        let userInfoRef = Firebase(url: "https://incandescent-torch-9100.firebaseIO.com/user_information")
        let ref = Firebase(url: "https://incandescent-torch-9100.firebaseio.com/users/" + userID + "/phoneNumber")
        var phoneNumber = ""
        ref.observeEventType(.Value, withBlock: { snapshot in
            phoneNumber = snapshot.value as! String
            
            let userToUpdate = userInfoRef.childByAppendingPath(phoneNumber)
            //let friendUpdate = ["friend": friendNumber]
            let friendsRef = userToUpdate.childByAppendingPath("friends")
            let friends1Ref = friendsRef.childByAutoId()
            friends1Ref.setValue(friendNumber)
            //friendsRef.childByAppendingPath(friendNumber)
            
            }, withCancelBlock: { error in
                print(error.description)
        })
        
    }
    
    
    @IBAction func doneAddFriends(sender: AnyObject) {
        for friendNumber in numbersToAdd{
            addFriend(friendNumber)
        }
        
        let alertController = UIAlertController(title:"Friends Added!", message:
            "Please click done", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title:"Dismiss", style: UIAlertActionStyle.Default,handler:nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func sanitize(dirty: String) -> String {
        let stringArray = dirty.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)
        let newString = stringArray.joinWithSeparator("")
        return newString
    }
}
