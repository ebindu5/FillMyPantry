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
        if let groceryCatalog = catalogViewController.groceryCatalog {
            groceryItems = groceryCatalog.map {$0.name}.sorted()
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groceryItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ABCTableCell", for: indexPath) as! searchResultCell
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.addItem(indexPath as NSIndexPath)
    }
    
    
    fileprivate func addItem(_ indexPath: NSIndexPath){
        FirebaseDAO.addItemToShoppingList(shoppingListId,groceryItems[indexPath.row], catalogViewController.order).subscribe(){ event in
            if event.element != nil {
                self.catalogViewController.count = self.catalogViewController.count + 1
                FirebaseDAO.updateShoppingListItemCount(self.shoppingListId, self.catalogViewController.count)
            }
            
        }
        catalogViewController.order = catalogViewController.order + 1
        catalogViewController.shoppingListItems.append(groceryItems[indexPath.row])
        self.tableView.reloadRows(at: [indexPath as IndexPath], with: .fade)
    }
    
    @objc func addItemtoShoppingList(_ sender: UIButton) {
        let section = sender.tag / 100
        let row = sender.tag % 100
        let indexPath = NSIndexPath(row: row, section: section)
        
        addItem(indexPath)
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
    
    
    func isGroceryItemPresent(_ indexPath : IndexPath)-> Bool{
        let groceryName = groceryItems[indexPath.row]
        if catalogViewController.shoppingListItems.contains(groceryName){
            return true
        } else{
            return false
        }
    }
}
