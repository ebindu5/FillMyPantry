//
//  searchResultCell.swift
//  FillMyPantry
//
//  Created by NISHANTH NAGELLA on 7/24/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit

class searchResultCell: UITableViewCell {

    @IBOutlet weak var textCell: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    @IBAction func addButtonClicked(_ sender: Any) {
        if let onButtonTapped = self.onButtonTapped {
            onButtonTapped()
        }
    }
    
     var onButtonTapped : (() -> Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
