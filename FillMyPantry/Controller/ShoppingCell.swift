//
//  ShoppingListCell.swift
//  FillMyPantry
//
//  Created by BINDU ELAKURTHI on 6/29/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit

class ShoppingCell: UITableViewCell {

    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var listName: UILabel!
    @IBOutlet weak var count: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
