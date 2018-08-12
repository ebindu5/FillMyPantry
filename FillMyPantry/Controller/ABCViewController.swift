//
//  ABCViewController.swift
//  FillMyPantry
//
//  Created by BINDU ELAKURTHI on 7/25/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import  UIKit

class  ABCViewController : UITableViewController{
    
    var catalogViewController = CatalogViewController()
    var shoppingListId : String!
    var groceryItems = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        shoppingListId = catalogViewController.shoppingListId
        if let groceryCatalog = catalogViewController.groceryCatalog {
            groceryItems = groceryCatalog.map {$0.name}.sorted()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groceryItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ABCTableCell", for: indexPath) as! SearchResultCell
        let groceryName = groceryItems[indexPath.row]
        cell.textCell.text = groceryName
        cell.addButton.addTarget(self, action: #selector(CategoriesViewController.addItemtoShoppingList(_:)), for: .touchUpInside)
        cell.addButton.tag = (indexPath.section*100)+indexPath.row
        if catalogViewController.shoppingListItems.contains(groceryName){
            cell.addButton.setImage(UIImage(named: "icon_done"), for: .normal)
            
        }else{
            cell.addButton.setImage(UIImage(named: "circleAddIcon"), for: .normal)
        }
        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.addItem(indexPath as NSIndexPath)
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if  isGroceryItemPresent(indexPath){
            return nil
        } else{
            return indexPath
        }
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return !isGroceryItemPresent(indexPath)
    }
    

}
