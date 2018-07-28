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

    var segmentViewController : CatalogViewController!
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

       shoppingListId = segmentViewController.shoppingListId
       shoppingListItems = segmentViewController.shoppingListItems
        
        if let groceryCatalog = segmentViewController.groceryCatalog {
            groceryItems = groceryCatalog.map {$0.name}.sorted()
        }

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
