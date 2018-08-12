//
//  ABCViewController+Extension.swift
//  FillMyPantry
//
//  Created by NISHANTH NAGELLA on 8/11/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit

extension ABCViewController {
    
     func addItem(_ indexPath: NSIndexPath){
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
    
    
    func isGroceryItemPresent(_ indexPath : IndexPath)-> Bool{
        let groceryName = groceryItems[indexPath.row]
        if catalogViewController.shoppingListItems.contains(groceryName){
            return true
        } else{
            return false
        }
    }
}
