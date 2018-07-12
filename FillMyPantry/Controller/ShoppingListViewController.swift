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
            let cell =  tableView.dequeueReusableCell(withIdentifier: "showHideButtonCell", for: indexPath)
            return cell
        }else {
            let cell =  tableView.dequeueReusableCell(withIdentifier: "completedItemCell", for: indexPath) as! ShoppingListItemCell
            cell.itemLabel?.text = completedItems[indexPath.row - completedItems.count - 1].name
            return cell
        }

    }
    
    
}
