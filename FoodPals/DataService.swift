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
        let user_mod: [String: String] = ["name": user["name"]!, "to": "", "from": ""]
        USER_INFO_REF.childByAppendingPath(user["phoneNumber"]).setValue(user_mod)
        
        // addAvailability(uid, from: "11 AM", to: "12 PM")
    }
    
//    func getFriends(phoneNumber: String)->Set<String>{
//        var friendList = Set<String>()
//        let ref = Firebase(url: "\(BASE_URL)/user_information/" + phoneNumber)
//        
//        return friendList
//    }
    
}