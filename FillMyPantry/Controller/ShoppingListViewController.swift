//
//  ShoppingListViewController.swift
//  FillMyPantry
//
//  Created by BINDU ELAKURTHI on 7/12/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class ShoppingListViewController : UIViewController, UITableViewDelegate,UITableViewDataSource, UISearchControllerDelegate, UISearchBarDelegate, UITabBarDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noItemsText: UITextField!
    @IBOutlet weak var tabBar: UITabBar!
   
    struct ShoppingListTableData {
        var completedItems = [Item]()
        var uncompletedItems =  [Item]()
        let title : String
        var newItemOrder = 1
        var uncompletedItemOrder = 1
        var count = 0
        
        init(title : String) {
            self.title = title
        }
    }
    
    var count = 0
    var searchResultsTableController : SearchResultsTableController!
    var searchController = UISearchController(searchResultsController: nil)
    var shoppingListId : String!
    var shoppingListTableData = ShoppingListTableData(title: "")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: .zero)
        configureTabBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        FirebaseDAO.getShoppingListFromId(shoppingListId).map{ shoppingList -> ShoppingListTableData  in
            
            var shoppingListData = ShoppingListTableData.init(title: shoppingList.name)
            if let shoppingListItems = shoppingList.items{
                var completedItems = shoppingListItems.filter (){ $0.completed == true }
                var uncompletedItems = shoppingListItems.filter (){ $0.completed == false }
                
                if uncompletedItems.count != 0 {
                    shoppingListData.newItemOrder = (uncompletedItems.max{$0.order < $1.order}?.order)! + 1
                    shoppingListData.uncompletedItemOrder = (uncompletedItems.min{$0.order < $1.order}?.order)! - 1
                    uncompletedItems.sort(by: { ($0.order) > ($1.order)})
                }
                
                if completedItems.count != 0 {
                    completedItems.sort(by: { ($0.completionDate)! > ($1.completionDate)!})
                }
                
                shoppingListData.completedItems = completedItems
                shoppingListData.uncompletedItems = uncompletedItems
                shoppingListData.count = completedItems.count + uncompletedItems.count
            }
            return shoppingListData
            }.subscribe{ event in
                if let shoppingData = event.element {
                    self.shoppingListTableData = shoppingData
                    self.noItemsText.isHidden = !( shoppingData.completedItems.count == 0 && shoppingData.uncompletedItems.count == 0 )
                    
                    self.count = shoppingData.count
                    self.configureNavigationBar()
                    self.configureSearchController()
                    self.searchResultsTableController.order = shoppingData.newItemOrder
                    self.searchResultsTableController.count = self.count
                    self.tableView.reloadData()
                }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count =  shoppingListTableData.uncompletedItems.count
        if shoppingListTableData.completedItems.count != 0 {
            count += 1
        }
        if Constants.showCompletedItems {
            count += shoppingListTableData.completedItems.count
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row < shoppingListTableData.uncompletedItems.count { // Uncompleted List Items
            let cell =  tableView.dequeueReusableCell(withIdentifier: "shoppingItemCell", for: indexPath) as! ShoppingListItemCell
            cell.itemLabel?.text = shoppingListTableData.uncompletedItems[indexPath.row].name
            cell.onButtonTapped = {
                FirebaseDAO.updateShoppingListItem(self.shoppingListTableData.uncompletedItems[indexPath.row].id, true, -1)
            }
            return cell
        } else if indexPath.row == shoppingListTableData.uncompletedItems.count { // Show Hide button
            let cell =  tableView.dequeueReusableCell(withIdentifier: "showHideButtonCell", for: indexPath) as! ShoppingListItemCell
            cell.isHidden = false
            if Constants.showCompletedItems {
                cell.labeltoShowHide.text =  "Hide Completed Items"
            }else{
                cell.labeltoShowHide.text =  "Show Completed Items"
            }
            return cell
        }else {               // Completed List Items
            let cell =  tableView.dequeueReusableCell(withIdentifier: "completedItemCell", for: indexPath) as! ShoppingListItemCell
            cell.itemLabel?.text = shoppingListTableData.completedItems[indexPath.row - shoppingListTableData.uncompletedItems.count - 1].name
            cell.checkBox.isEnabled = false
            cell.onButtonTapped = {
                FirebaseDAO.updateShoppingListItem(self.shoppingListTableData.completedItems[indexPath.row - self.shoppingListTableData.uncompletedItems.count - 1].id, false, self.shoppingListTableData.uncompletedItemOrder)
            }
            if Constants.showCompletedItems {
                cell.isHidden = false
            }else{
                cell.isHidden = true
            }
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == shoppingListTableData.uncompletedItems.count { // Show Hide button
            
            let cell = tableView.cellForRow(at: indexPath) as! ShoppingListItemCell
            if  Constants.showCompletedItems == false {
                cell.labeltoShowHide.text =  "Hide Completed Items"
            }else{
                cell.labeltoShowHide.text =  "Show Completed Items"
            }
            Constants.showCompletedItems = !Constants.showCompletedItems
            tableView.reloadData()
        } else if indexPath.row < shoppingListTableData.uncompletedItems.count { // Uncompleted List Items
            FirebaseDAO.updateShoppingListItem(shoppingListTableData.uncompletedItems[indexPath.row].id, true, -1)
            
        } else {      // Completed List Items
            FirebaseDAO.updateShoppingListItem(shoppingListTableData.completedItems[indexPath.row - shoppingListTableData.uncompletedItems.count - 1].id, false, shoppingListTableData.uncompletedItemOrder)
        }
    }
}


