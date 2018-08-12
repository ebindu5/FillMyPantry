//
//  SearchResultsTableController.swift
//  FillMyPantry
//
//  Created by BINDU ELAKURTHI on 7/23/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class SearchResultsTableController : UITableViewController, UISearchResultsUpdating  {
    
    var groceryCatalog = [Grocery]()
    var filteredItems = [String]()
    var shoppingListID : String!
    var order : Int!
    var count : Int!

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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredItems.count
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableView.contentInset = UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0)
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultCell", for: indexPath as IndexPath) as! SearchResultCell
        let selectedItem = filteredItems[indexPath.row]
        cell.textCell.text = selectedItem
        cell.onButtonTapped = {
            self.addItemtoShoppingList(indexPath)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        addItemtoShoppingList(indexPath)
    }
    
}


