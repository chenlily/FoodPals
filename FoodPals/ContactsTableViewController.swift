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
    
    var cncontacts = [CNContact]()
    var numbersToAdd = Set<String>()
    var friendList = Set<String>()
    let dataService = DataService()
    var appUsers = Set<String>()
    var noContacts = false
    
    override func viewDidLoad(){
        super.viewDidLoad()

        getContacts()
        print("LOOK HERE LILY. GOT CONTACTS")
        
        // Just a quick fix...
        while (CNContactStore.authorizationStatusForEntityType(.Contacts) == .NotDetermined) {}
        
        let uid = ( NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String)
        print(uid)
        let ref = Firebase(url: "\(BASE_URL)/users/" + uid + "/phoneNumber")
        let ref2 = Firebase(url: "\(BASE_URL)/users")
        var phoneNumber = String()
        ref.observeEventType(.Value, withBlock: { snapshot in
            print("why")
            phoneNumber = "\(snapshot.value)"
            print(phoneNumber)
            //var friendList = Set<String>()
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
                
                //warning!
                //this only works if the name does not have whitespace RIP
                //warning!
                
                ref2.observeEventType(.Value, withBlock: { snapshot in
                    let appUserToParse = "\(snapshot.value)"
                    var appUserToParseArray = appUserToParse.characters.split{$0 == " "}.map(String.init)
                    var parsedAppUser = Set<String>() //everyone who uses the app
                    //print (appUserToParseArray)
                    if appUserToParseArray.count>12{
                        appUserToParseArray.removeFirst(12)
                        for var i = 0; i<appUserToParseArray.count; i+=16 {
                            var temp = appUserToParseArray[i]
                            temp = temp.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                            temp = temp.stringByTrimmingCharactersInSet(NSCharacterSet.punctuationCharacterSet())
                            parsedAppUser.insert(temp)
                        }
                    }
                    
                    // in contacts, in app users, but not in friends
                    var cncontacts2 = [CNContact]()
                    for contact in self.cncontacts {
                        if !contact.phoneNumbers.isEmpty{
                            let contactNumber = contact.phoneNumbers[0].value as! CNPhoneNumber
                            let cellNumber = self.sanitize(contactNumber.stringValue)
                            if !parsedNumbers.contains(cellNumber) &&  parsedAppUser.contains(cellNumber){
                                cncontacts2.insert(contact, atIndex: 0)
                                }
                            }

                    }
                    self.cncontacts = cncontacts2
                    self.tableView.reloadData()
                    
                    
                    }, withCancelBlock: { error in
                        print(error.description)
                })
                
                
                }, withCancelBlock: { error in
                    print(error.description)
            })
            }, withCancelBlock: { error in
                print(error.description)
        })
        
        

    }
    
    
    ////////////////grab valid contacts/////////////////////////////////////////////////////////////

    
    func getContacts() {
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
            //var cncontacts2 = [CNContact]()
            /*
            print("initial list ", cncontacts.count)
            for contact in cncontacts {
                let contactNumber = contact.phoneNumbers[0].value as! CNPhoneNumber
                let cellNumber = sanitize(contactNumber.stringValue)
                if friendList.contains(cellNumber) {
                    cncontacts2.insert(contact, atIndex: 0)
                }
            }
            cncontacts = cncontacts2 */
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            })
        } catch {
            print(error)
        }
    }
    
    ////////////////actual code for the view controller//////////////////////////////////////////////
    
    func loadContactsAddress(){
        
    }

    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Show 1 section
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // One row per Contact (GO KAYLEE)
//        print("Number of rows: ", cncontacts.count)
//        if (cncontacts.count == 0) {
//            print("No contacts to add ._.")
//            self.noContacts = true
//            let alertController = UIAlertController(title:"No contacts to add :(", message:
//                "Please click done", preferredStyle: UIAlertControllerStyle.Alert)
//            alertController.addAction(UIAlertAction(title:"Dismiss", style: UIAlertActionStyle.Default,handler:nil))
//            self.presentViewController(alertController, animated: true, completion: nil)
//        }
//        noContacts = false
        
        return cncontacts.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "ContactTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ContactTableViewCell
        
        let contact = cncontacts[indexPath.row]
        let formatter = CNContactFormatter()
        
        cell.NameText?.text = formatter.stringFromContact(contact)
        let contactNumber = contact.phoneNumbers[0].value as! CNPhoneNumber

        cell.NumberText = sanitize(contactNumber.stringValue)

        if indexPath.row % 2 == 1 {
            cell.backgroundColor = UIColor(red: 249/255, green: 250/255, blue: 250/255, alpha: 1.0)
        } else {
            cell.backgroundColor = UIColor.whiteColor();
        }
        
        // deselect all cells 
        cell.selected = false
        cell.accessoryType = UITableViewCellAccessoryType.None
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
            let friendsRef = userToUpdate.childByAppendingPath("friends")
            let friends1Ref = friendsRef.childByAutoId()
            friends1Ref.setValue(friendNumber)
            
            }, withCancelBlock: { error in
                print(error.description)
        })
        
    }
    
    
    @IBAction func doneAddFriends(sender: AnyObject) {
        for friendNumber in numbersToAdd{
            addFriend(friendNumber)
        }
        numbersToAdd.removeAll()
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
