//
//  ABCTabViewController.swift
//  FillMyPantry
//
//  Created by NISHANTH NAGELLA on 7/25/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import  UIKit

class  ABCTabViewController : UITableViewController{

    var customTabController : CustomTabBarController!
    var shoppingListId : String!
    var shoppingListItems : [Item]!
    var groceryItems = [String]()
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    customTabController = self.tabBarController as? CustomTabBarController
       shoppingListId = customTabController.shoppingListId
       shoppingListItems = customTabController.shoppingListItems
        
        if let groceryCatalog = customTabController.groceryCatalog {
            groceryItems = groceryCatalog.map {$0.name}.sorted()
        }

    }
    
    @IBAction func doneButtonClicked(_ sender : Any){
        self.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return groceryItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ABCTableCell", for: indexPath)
        cell.textLabel?.text = groceryItems[indexPath.row]
        return cell
    }
    
}
