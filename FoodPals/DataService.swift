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
    
    var phoneNumber = String()
    
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
    /*
    func getUserNumber(uid: String)->String{
        let sem = dispatch_semaphore_create(0)
        
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED),0)){
            let ref = Firebase(url: "\(BASE_URL)/users/" + uid + "/phoneNumber")
            ref.observeEventType(.Value, withBlock: { snapshot in
                self.phoneNumber = (snapshot.value as? String)!
                //phoneNumber = "\(snapshot.value)"
                print(self.phoneNumber)
            })
            
        }
        //var phoneNumber = String()

        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER)
        print(self.phoneNumber)
        return self.phoneNumber
    } */
    
    func getUserNumber(uid: String) -> String {
        var semaphore = dispatch_semaphore_create(0)
        let qualityOfServiceClass = QOS_CLASS_USER_INITIATED
        dispatch_async(dispatch_get_global_queue(qualityOfServiceClass, 0)){
            var myRef = Firebase(url: "\(BASE_URL)/users/" + uid + "/phoneNumber")
            myRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
                // do some stuff once
                print("WE ARE IN HERE")
                self.phoneNumber = (snapshot.value as? String)!
                //print(self.phoneNumber)
            })
            dispatch_semaphore_signal(semaphore)
        }
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        print("WE MADE IT OUT OF THERE:" + self.phoneNumber)
        return self.phoneNumber
    }
    
    func getFriends(phoneNumber: String)->Set<String>{
        var friendList = Set<String>()
        let ref = Firebase(url: "\(BASE_URL)/user_information/" + phoneNumber + "/friends")
        
        ref.observeEventType(.Value, withBlock: { snapshot in
            //phoneNumber = "\(snapshot.value)"
            print("\(snapshot.value)")
            }, withCancelBlock: { error in
                print(error.description)
        })
        
        return friendList
    }
    
}