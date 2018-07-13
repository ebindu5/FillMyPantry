//
//  ShoppingListViewController.swift
//  Fill My Pantry
//
//  Created by NISHANTH NAGELLA on 7/12/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import UIKit

class ShoppingListViewController : UIViewController, UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var shoppingList : ShoppingList!
    var completedItems : [Item]!
    var uncompletedItems: [Item]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        if let shoppingListItems = shoppingList?.items{
            completedItems = shoppingListItems.filter (){ $0.completed == true }
            uncompletedItems = shoppingListItems.filter (){ $0.completed == false }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let shoppingListValue = shoppingList {
            return (shoppingListValue.items?.count)! + 2 ?? 2
        }else{
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if indexPath.row == uncompletedItems.count {
            let cell =  tableView.dequeueReusableCell(withIdentifier: "createShoppingListCell", for: indexPath)
            return cell
        } else if indexPath.row < uncompletedItems.count{
            let cell =  tableView.dequeueReusableCell(withIdentifier: "shoppingItemCell", for: indexPath) as! ShoppingListItemCell
            cell.itemLabel?.text = uncompletedItems[indexPath.row].name
            return cell
        } else if indexPath.row == uncompletedItems.count + 1 {
            let cell =  tableView.dequeueReusableCell(withIdentifier: "showHideButtonCell", for: indexPath) as! ShoppingListItemCell
            return cell
        }else {
            let cell =  tableView.dequeueReusableCell(withIdentifier: "completedItemCell", for: indexPath) as! ShoppingListItemCell
            cell.itemLabel?.text = completedItems[indexPath.row - completedItems.count - 1].name
            cell.checkBox.isEnabled = false
            return cell
        }

    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == uncompletedItems.count + 1 {
            let cell = tableView.cellForRow(at: indexPath) as! ShoppingListItemCell
            
            let completeCell = tableView.dequeueReusableCell(withIdentifier: "completedItemCell")
            if (cell.labeltoShowHide.text?.contains("Show"))! {
                cell.labeltoShowHide.text =  "Hide Completed Items"
                completeCell?.isHidden = false
                
            }else{
                cell.labeltoShowHide.text =  "Show Completed Items"
                completeCell?.isHidden = true
                
            }
        }
      
    }
    
    
    
    
}
