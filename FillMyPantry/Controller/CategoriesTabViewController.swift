//
//  CategoriesTabViewController.swift
//  FillMyPantry
//
//  Created by NISHANTH NAGELLA on 7/25/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import UIKit

class  CategoriesTabViewController : UITableViewController{
   
    var customTabController : CustomTabBarController!
    var shoppingListId : String!
    var shoppingListItems : [Item]!
    var groceryCatalog = [[String]]()
    var grocerySection = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customTabController = self.tabBarController as? CustomTabBarController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         var groceryMap = [String: [String]]()
        
        shoppingListId = customTabController.shoppingListId
        shoppingListItems = customTabController.shoppingListItems

        if let catalog = customTabController.groceryCatalog {
            for grocery in catalog {
                if groceryMap[grocery.category] != nil {
                    groceryMap[grocery.category]?.append(grocery.name)
                }else{
                   groceryMap[grocery.category] = [grocery.name]
                }
            }
            grocerySection = Array(groceryMap.keys)
            groceryCatalog = Array(groceryMap.values)
            
            for i in 0..<groceryCatalog.count {
                groceryCatalog[i].sort()
            }
        }

       
    }
    
    
    
    @IBAction func doneButtonClicked(_ sender : Any){
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groceryCatalog[section].count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return grocerySection.count
    }
    
   
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return grocerySection[section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoriesCell", for: indexPath)
        
        cell.textLabel?.text = groceryCatalog[indexPath.section][indexPath.row]
        return cell
    }
    
    
}
