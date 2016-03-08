//
//  Contact.swift
//  FoodPals
//
//  Created by Wei, Yunhan on 3/8/16.
//  Copyright © 2016 PuppyCuddlers. All rights reserved.
//

import UIKit

class Contact {
    var name: String
    var email: String
    
    init?(name: String, email: String){
        self.name = name
        self.email = email
        
        if name.isEmpty || email.isEmpty{
            return nil
        }
    }
}
