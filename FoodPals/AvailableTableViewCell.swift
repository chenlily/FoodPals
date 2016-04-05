//
//  AvailableTableViewCell.swift
//  FoodPals
//
//  Created by Schonsheck, Kaylee on 3/3/16.
//  Copyright © 2016 PuppyCuddlers. All rights reserved.
//

import UIKit

class AvailableTableViewCell: UITableViewCell {
    
    // MARK: Properties
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var availabilityLabel: UILabel!
    var phoneNumber = String()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
