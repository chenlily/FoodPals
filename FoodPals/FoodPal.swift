//
//  FoodPal.swift
//  FoodPals
//
//  Created by Schonsheck, Kaylee on 3/3/16.
//  Copyright © 2016 PuppyCuddlers. All rights reserved.
//

import UIKit

class FoodPal {
    
    // MARK: Properties
    
    var first_name: String
    var last_name: String
    var from: String
    var to: String
    var phoneNumber: String
    
    // MARK: Initialization
    
    init?(first_name: String, last_name: String, from: String, to: String, phone_number: String) {
        self.first_name = first_name
        self.last_name = last_name
        self.from = from
        self.to = to
        self.phoneNumber = phone_number
        
        if first_name.isEmpty || from.isEmpty || to.isEmpty || phone_number.isEmpty {
            return nil
        }
    }
}
