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
            let keysToFetch = [CNContactFormatter.descriptorForRequiredKeysForStyle(.FullName), CNContactEmailAddressesKey]
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
    
    override func viewDidLoad(){
        super.viewDidLoad()
        loadSampleContact()
        getContacts()
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
//        
//        // Table view cells are reused and should be dequeued using a cell identifier
//        let cellIdentifier = "ContactTableViewCell"
//        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ContactTableViewCell
//        
//        // Fetches the appropriate FoodPal for the data source layout
//        let contact = contacts[indexPath.row]
//        
//        cell.NameText.text = contact.name
//        cell.EmailText.text = contact.email
//        
//        if indexPath.row % 2 == 1 {
//            cell.backgroundColor = UIColor(red: 249/255, green: 250/255, blue: 250/255, alpha: 1.0)
//        } else {
//            cell.backgroundColor = UIColor.whiteColor();
//        }
//        
//        return cell
        
        let cellIdentifier = "ContactTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ContactTableViewCell
        
        let contact = cncontacts[indexPath.row]
        let formatter = CNContactFormatter()
        
        cell.NameText?.text = formatter.stringFromContact(contact)
        //cell.EmailText?.text = contact.emailAddresses.first?.value as? String
        
        if indexPath.row % 2 == 1 {
            cell.backgroundColor = UIColor(red: 249/255, green: 250/255, blue: 250/255, alpha: 1.0)
        } else {
            cell.backgroundColor = UIColor.whiteColor();
        }
        
        return cell
        
    }
    
}