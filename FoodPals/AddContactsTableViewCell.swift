//
//  AvailableTableViewCell.swift
//  FoodPals
//
//  Created by Wei, Yunhan on 3/3/16.
//  Copyright © 2016 PuppyCuddlers. All rights reserved.
//

import UIKit

class AddContactsTableViewCell: UITableViewCell {
    
    // MARK: Properties

    @IBOutlet weak var NameText: UILabel!
    @IBOutlet weak var EmailText: UILabel! //for debug delete later brah
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
