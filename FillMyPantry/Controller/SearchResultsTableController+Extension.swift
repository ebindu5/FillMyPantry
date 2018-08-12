//
//  SearchResultsTableController+Extension.swift
//  FillMyPantry
//
//  Created by BINDU ELAKURTHI on 8/11/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit

extension SearchResultsTableController {
    func updateSearchResults(for searchController: UISearchController) {
        if (searchController.searchBar.text?.count)! > 0 {
            let text =  searchController.searchBar.text
            filteredItems.removeAll(keepingCapacity: false)
            
            filteredItems = SearchDAO.getSearchResults(groceryCatalog, (text?.trimmingCharacters(in: CharacterSet(charactersIn: " ")))!)
            
            tableView.reloadData()
        }
        else {
            filteredItems.removeAll(keepingCapacity: false)
            tableView.reloadData()
        }
    }
    
     func addItemtoShoppingList(_ indexPath: IndexPath) {
        FirebaseDAO.addItemToShoppingList(shoppingListID, filteredItems[indexPath.row], order).subscribe(){ event in
            if event.element != nil {
                FirebaseDAO.updateShoppingListItemCount(self.shoppingListID, self.count + 1)
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
}

