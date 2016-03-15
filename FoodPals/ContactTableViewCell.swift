//
//  ContactTableViewCell.swift
//  FoodPals
//
//  Created by Wei, Yunhan on 3/8/16.
//  Copyright © 2016 PuppyCuddlers. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    @IBOutlet weak var NameText: UILabel!
    @IBOutlet weak var EmailText: UILabel! //debug purposes
    @IBOutlet weak var addImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }

}
