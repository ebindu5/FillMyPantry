//
//  SearchResultsTableController.swift
//  FillMyPantry
//
//  Created by NISHANTH NAGELLA on 7/23/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class SearchResultsTableController : UITableViewController {
    
    var groceryCatalog = [Grocery]()
    var filteredItems = [String]()
    var shoppingListID : String!
    var order : Int!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.backgroundColor = UIColor.clear
        self.automaticallyAdjustsScrollViewInsets = false
        tableView.tableFooterView = UIView(frame: .zero)
        GroceryCatalog.getGroceryCatalog().subscribe(){ event in
            if let catalog = event.element{
                self.groceryCatalog = catalog
            }
        }
        
    }
}

extension SearchResultsTableController : UISearchResultsUpdating {
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
}


extension SearchResultsTableController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredItems.count
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        tableView.contentInset = UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0)
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultCell", for: indexPath as IndexPath) as? searchResultCell
        let selectedItem = filteredItems[indexPath.row]
        cell?.textCell.text = selectedItem

        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        FirebaseDAO.addItemToShoppingList(shoppingListID, filteredItems[indexPath.row], order).subscribe()
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
}

