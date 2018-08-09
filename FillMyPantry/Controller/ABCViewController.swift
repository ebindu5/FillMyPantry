//
//  ABCViewController.swift
//  FillMyPantry
//
//  Created by NISHANTH NAGELLA on 7/25/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import  UIKit

class  ABCViewController : UITableViewController{
    
    var catalogViewController = CatalogViewController()
    var shoppingListId : String!
    var shoppingListItems : [Item]!
    var groceryItems = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        shoppingListId = catalogViewController.shoppingListId
//        shoppingListItems = catalogViewController.shoppingListItems
        
        if let groceryCatalog = catalogViewController.groceryCatalog {
            groceryItems = groceryCatalog.map {$0.name}.sorted()
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groceryItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ABCTableCell", for: indexPath) as! searchResultCell
        cell.textCell.text = groceryItems[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        FirebaseDAO.addItemToShoppingList(shoppingListId,groceryItems[indexPath.row], catalogViewController.order).subscribe()
        catalogViewController.order = catalogViewController.order + 1
    }
    
}
