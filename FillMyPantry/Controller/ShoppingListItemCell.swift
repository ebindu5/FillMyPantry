//
//  ShoppingListItemCell.swift
//  Fill My Pantry
//
//  Created by NISHANTH NAGELLA on 7/12/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit

class ShoppingListItemCell: UITableViewCell {

    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var checkBox: UIButton!    
    @IBOutlet weak var labeltoShowHide : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
