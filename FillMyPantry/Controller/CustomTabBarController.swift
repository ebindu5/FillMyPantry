//
//  CustomTabBarController.swift
//  FillMyPantry
//
//  Created by NISHANTH NAGELLA on 7/25/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import  UIKit

class CustomTabBarController : UITabBarController {
    
  @IBOutlet weak var customTabBar: UITabBar!
    
    var shoppingListId : String!
    var shoppingListItems : [Item]!
    var groceryCatalog : [Grocery]!
    
        override func viewDidLoad() {
            super.viewDidLoad()
            GroceryCatalog.getGroceryCatalog().subscribe(){ event in
                if let catalog = event.element{
                    self.groceryCatalog = catalog
                }
            }
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        var customTabBar:CGRect = self.customTabBar.frame
//        customTabBar.origin.y = self.view.frame.origin.y
//        self.customTabBar.frame = customTabBar
//    }
    

    
}
