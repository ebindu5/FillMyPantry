//
//  ShoppingListViewController.swift
//  FillMyPantry
//
//  Created by NISHANTH NAGELLA on 7/12/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import UIKit

class ShoppingListViewController : UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var isActive = false
    var shoppingListId : String!
    var shoppingList : ShoppingList!
    var completedItems = [Item]()
    var uncompletedItems =  [Item]()
    
    var data = ["San Francisco","New York","San Jose","Chicago","Los Angeles","Austin","Seattle"]
    var filtered:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        FirebaseDAO.getShoppingListFromId(shoppingListId).subscribe{ event in
            if let shoppingListElement = event.element{
                self.shoppingList = shoppingListElement
                if let shoppingListItems = self.shoppingList.items{
                    self.completedItems = shoppingListItems.filter (){ $0.completed == true }
                    self.uncompletedItems = shoppingListItems.filter (){ $0.completed == false }
                }
                self.tableView.reloadData()
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isActive{
          return filtered.count
        } else{
        if let shoppingListValue = shoppingList {
            return (shoppingListValue.items?.count)! + 2
        }else{
            return 2
        }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isActive {
            let cell =  tableView.dequeueReusableCell(withIdentifier: "shoppingItemCell", for: indexPath) as! ShoppingListItemCell
            cell.itemLabel?.text = filtered[indexPath.row]
            return cell
        } else{
        
        if indexPath.row == uncompletedItems.count { // Add an Item
            let cell =  tableView.dequeueReusableCell(withIdentifier: "createShoppingListCell", for: indexPath)
            return cell
        } else if indexPath.row < uncompletedItems.count { // Uncompleted List Items
            let cell =  tableView.dequeueReusableCell(withIdentifier: "shoppingItemCell", for: indexPath) as! ShoppingListItemCell
            cell.itemLabel?.text = uncompletedItems[indexPath.row].name
            return cell
        } else if indexPath.row == uncompletedItems.count  + 1 { // Show Hide button
            let cell =  tableView.dequeueReusableCell(withIdentifier: "showHideButtonCell", for: indexPath) as! ShoppingListItemCell
            if Constants.showCompletedItems {
                cell.labeltoShowHide.text =  "Hide Completed Items"
            }else{
                cell.labeltoShowHide.text =  "Show Completed Items"
            }
            
            return cell
        }else { // Completed List Items
            let cell =  tableView.dequeueReusableCell(withIdentifier: "completedItemCell", for: indexPath) as! ShoppingListItemCell
            cell.itemLabel?.text = completedItems[indexPath.row - uncompletedItems.count - 2].name
            cell.checkBox.isEnabled = false
            if Constants.showCompletedItems {
                cell.isHidden = false
            }else{
                cell.isHidden = true
            }
            return cell
        }
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
      
        if indexPath.row == uncompletedItems.count + 1 {
            
            let cell = tableView.cellForRow(at: indexPath) as! ShoppingListItemCell
            if (cell.labeltoShowHide.text?.contains("Show"))! {
                cell.labeltoShowHide.text =  "Hide Completed Items"
                Constants.showCompletedItems = true
            }else{
                cell.labeltoShowHide.text =  "Show Completed Items"
                Constants.showCompletedItems = false
            }
            
        } else if indexPath.row == uncompletedItems.count {
            
            
        } else if indexPath.row < uncompletedItems.count {
            
            
        } else {
            
            
            
        }
        tableView.reloadData()
    }
}


extension ShoppingListViewController : UISearchBarDelegate {
  

    
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        isActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
         filtered = data.filter({ (text) -> Bool in
            let tmp: NSString = text as NSString
            let range = tmp.range(of: searchText, options: .caseInsensitive)
            return range.location != NSNotFound
        })
        if(filtered.count == 0){
            isActive = false;
        } else {
            isActive = true;
        }
        tableView.reloadData()
    }
}
