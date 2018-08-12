//
//  CategoriesViewController+Extension.swift
//  FillMyPantry
//
//  Created by BINDU ELAKURTHI on 8/11/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit

extension CategoriesViewController{
    
    func isGroceryItemPresent(_ indexPath : IndexPath)-> Bool{
        if indexPath.row != 0 {
            let groceryName = tableViewData[indexPath.section].sectionData[indexPath.row - 1]
            if catalogViewController.shoppingListItems.contains(groceryName){
                return true
            } else{
                return false
            }
        }else{
            return false
        }
    }
    
     func addItem(_ indexPath: NSIndexPath) {
        FirebaseDAO.addItemToShoppingList(shoppingListId, tableViewData[indexPath.section].sectionData[indexPath.row - 1], catalogViewController.order).subscribe{ event in
            if event.element != nil {
                self.catalogViewController.count = self.catalogViewController.count + 1
                FirebaseDAO.updateShoppingListItemCount(self.shoppingListId, self.catalogViewController.count)
            }
        }
        catalogViewController.order = catalogViewController.order + 1
        catalogViewController.shoppingListItems.append(tableViewData[indexPath.section].sectionData[indexPath.row - 1])
        self.tableView.reloadRows(at: [indexPath as IndexPath], with: .fade)
    }
    
    @objc func addItemtoShoppingList(_ sender: UIButton) {
        let section = sender.tag / 100
        let row = sender.tag % 100
        let indexPath = NSIndexPath(row: row, section: section)
        
        addItem(indexPath)
    }
    
}
