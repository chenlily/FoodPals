//
//  DataService.swift
//  FoodPals
//
//  Created by Wei, Yunhan on 3/7/16.
//  Copyright © 2016 PuppyCuddlers. All rights reserved.
//

import Foundation
import Firebase

class DataService {
    static let dataService = DataService()
    
    private var _BASE_REF = Firebase(url: "\(BASE_URL)")
    private var _USER_REF = Firebase(url: "\(BASE_URL)/users")
    private var _USER_INFO_REF = Firebase(url: "\(BASE_URL)/user_information")
    
    var BASE_REF: Firebase {
        return _BASE_REF
    }
    
    var USER_REF: Firebase {
        return _USER_REF
    }
    
    var USER_INFO_REF: Firebase {
        return _USER_INFO_REF
    }
    
    var CURRENT_USER_REF: Firebase {
        let userID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
        
        let currentUser = Firebase(url: "\(BASE_REF)").childByAppendingPath("users").childByAppendingPath(userID)
        
        return currentUser!
    }
    
    func createNewAccount(uid: String, user: Dictionary<String, String>) {
        // A User is born.
        USER_REF.childByAppendingPath(uid).setValue(user)
        
        // Add entry inside the firebase table for user information -- works but needs tweaking
        let user_mod: [String: String] = ["name": user["name"]!, "to": "placeholder", "from": "placeholder"]
        USER_INFO_REF.childByAppendingPath(user["phoneNumber"]).setValue(user_mod)
        
        addAvailability(uid, from: "11 AM", to: "12 PM")
    }
    
    func addAvailability(uid: String, from: String, to: String) {
        //update the user_information ref to have 1 child called from and 1 child called to
        
        
        // set up the ref
        //obtain phone number
        var phoneNumber = ""
        let ref = Firebase(url: "\(BASE_URL)/users/" + uid + "/phoneNumber")
        ref.observeEventType(.Value, withBlock: { snapshot in
                //phoneNumber = (snapshot.value as? String)!
                phoneNumber = "\(snapshot.value)"
            }, withCancelBlock: { error in
                print(error.description)
            })
        
        let info_ref = Firebase(url: "\(BASE_URL)/user_information/" + phoneNumber+"/")
        info_ref.updateChildValues([
            "to": to,
            "from": from
        ])
        //use phoneNumber to write to user_information table
        //let avail: [String: String] = ["to": to, "from": from]
        //USER_INFO_REF.childByAppendingPath(phoneNumber).setValue(avail)
//        let info_ref = Firebase(url: "\(BASE_URL)/user_information/" + phoneNumber+"/")
//        
//        print(from)
//        print(to)
        //USER_INFO_REF.childByAppendingPath(phoneNumber + "/to").setValue(to)
        /*
        info_ref.observeEventType(.Value, withBlock: { snapshot in
            //phoneNumber = (snapshot.value as? String)!
            print("\(snapshot.value)")
            }, withCancelBlock: { error in
                print(error.description)
        })*/

        //info_ref.setValue(<#T##value: AnyObject!##AnyObject!#>)
        //let avail: [String: String] = ["to": to, "from": from]
        //info_ref.childByAppendingPath("to").setValue(to)
        //info_ref.childByAppendingPath("from").setValue(from)
    }
}