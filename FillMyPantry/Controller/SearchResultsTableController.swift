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
   
    var groceryNames = [String]()
    var filteredItems = [String]()
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.backgroundColor = UIColor.clear
        self.automaticallyAdjustsScrollViewInsets = false
        GroceryCatalog.getGroceryItems().subscribe(){ event in
            if let catalog = event.element{
                self.groceryNames = catalog
            }
        }
    }
}

extension SearchResultsTableController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        if (searchController.searchBar.text?.count)! > 0 {
            filteredItems.removeAll(keepingCapacity: false)
            let searchPredicate = NSPredicate(format: "SELF CONTAINS %@", searchController.searchBar.text!)
            let array = (groceryNames as NSArray).filtered(using: searchPredicate)
            filteredItems = array as! [String]
            print(filteredItems)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultCell", for: indexPath as IndexPath)
        let selectedItem = filteredItems[indexPath.row]
        cell.textLabel?.text = selectedItem
        cell.detailTextLabel?.text = ""
        
        return cell
    }
}

