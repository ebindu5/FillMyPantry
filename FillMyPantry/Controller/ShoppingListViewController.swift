//
//  ShoppingListViewController.swift
//  FillMyPantry
//
//  Created by NISHANTH NAGELLA on 7/12/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import UIKit

class ShoppingListViewController : UIViewController, UITableViewDelegate,UITableViewDataSource, UISearchControllerDelegate, UISearchBarDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noItemsText: UITextField!
    @IBOutlet weak var tabBar: UITabBar!
    
    var searchResultsTableController : SearchResultsTableController!
    
    var searchController = UISearchController(searchResultsController: nil)
    
    var shoppingListId : String!
    var shoppingList : ShoppingList!
    var completedItems = [Item]()
    var uncompletedItems =  [Item]()
    var newItemOrder = 1
    var completedItemOrder : Int!
    var uncompletedItemOrder = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.reloadData()
        tabBar.delegate = self
        configureSearchController()
        
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        FirebaseDAO.getShoppingListFromId(shoppingListId).subscribe{ event in
            if let shoppingListElement = event.element{
                
                self.shoppingList = shoppingListElement
                if let shoppingListItems = self.shoppingList.items{
                    DispatchQueue.main.async {
                        self.noItemsText.isHidden = true
                    }
                    self.completedItems = shoppingListItems.filter (){ $0.completed == true }
                    self.uncompletedItems = shoppingListItems.filter (){ $0.completed == false }
                    
                    if self.uncompletedItems.count != 0 {
                        self.newItemOrder = (self.uncompletedItems.max{$0.order < $1.order}?.order)! + 1
                        self.uncompletedItemOrder = (self.uncompletedItems.min{$0.order < $1.order}?.order)! - 1
                        self.uncompletedItems.sort(by: { ($0.order) > ($1.order)})
                        
                    }
                    
                    if self.completedItems.count != 0 {
                        self.completedItems.sort(by: { ($0.completionDate)! > ($1.completionDate)!})
                    }
                    
                    
                }else{
                    DispatchQueue.main.async {
                        self.noItemsText.isHidden = false
                    }
                }
                self.searchResultsTableController.order = self.newItemOrder
            }
            DispatchQueue.main.async {
                self.configureNavigationBar()
                self.tableView.reloadData()
            }
            
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let shoppingListValue = shoppingList {
            return (shoppingListValue.items?.count ?? 0 ) + 1
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row < uncompletedItems.count { // Uncompleted List Items
            let cell =  tableView.dequeueReusableCell(withIdentifier: "shoppingItemCell", for: indexPath) as! ShoppingListItemCell
            cell.itemLabel?.text = uncompletedItems[indexPath.row].name
            return cell
        } else if indexPath.row == uncompletedItems.count { // Show Hide button
            let cell =  tableView.dequeueReusableCell(withIdentifier: "showHideButtonCell", for: indexPath) as! ShoppingListItemCell
            if (completedItems.count) != 0 {
                cell.isHidden = false
                if Constants.showCompletedItems {
                    cell.labeltoShowHide.text =  "Hide Completed Items"
                }else{
                    cell.labeltoShowHide.text =  "Show Completed Items"
                }
            }else{
                cell.isHidden = true
            }
            return cell
            
        }else {               // Completed List Items
            let cell =  tableView.dequeueReusableCell(withIdentifier: "completedItemCell", for: indexPath) as! ShoppingListItemCell
            cell.itemLabel?.text = completedItems[indexPath.row - uncompletedItems.count - 1].name
            cell.checkBox.isEnabled = false
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
        
        if indexPath.row == uncompletedItems.count { // Show Hide button
            
            let cell = tableView.cellForRow(at: indexPath) as! ShoppingListItemCell
            if (cell.labeltoShowHide.text?.contains("Show"))! {
                cell.labeltoShowHide.text =  "Hide Completed Items"
                Constants.showCompletedItems = true
            }else{
                cell.labeltoShowHide.text =  "Show Completed Items"
                Constants.showCompletedItems = false
            }
        } else if indexPath.row < uncompletedItems.count { // Uncompleted List Items
            FirebaseDAO.updateShoppingListItem(uncompletedItems[indexPath.row].id, true, -1)
            completedItems.append(uncompletedItems[indexPath.row])
            uncompletedItems.remove(at: indexPath.row)
        } else {      // Completed List Items
            FirebaseDAO.updateShoppingListItem(completedItems[indexPath.row - uncompletedItems.count - 1].id, false, uncompletedItemOrder)
            uncompletedItems.append(completedItems[indexPath.row - uncompletedItems.count - 1])
            completedItems.remove(at: indexPath.row - uncompletedItems.count )
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    
}

extension ShoppingListViewController {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.showsBookmarkButton = false
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.showsBookmarkButton =  true
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        let catalogViewController = storyboard?.instantiateViewController(withIdentifier: "CatalogViewController") as? CatalogViewController
        catalogViewController?.shoppingListId = shoppingListId
        catalogViewController?.shoppingListItems = uncompletedItems
        
        self.present(catalogViewController!, animated: true, completion: nil)
        
    }
    
}

extension ShoppingListViewController{
    
    func configureSearchController() {
        searchResultsTableController = storyboard!.instantiateViewController(withIdentifier: "SearchResultsTableController") as! SearchResultsTableController
        searchResultsTableController.shoppingListID = shoppingListId
        
        searchController = UISearchController(searchResultsController: searchResultsTableController)
        searchController.searchResultsUpdater = searchResultsTableController
        searchController.dimsBackgroundDuringPresentation = true
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchBar.delegate = self
        searchController.searchBar.showsBookmarkButton = true
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Add an Item..."
        searchController.searchBar.sizeToFit()
        
        searchController.searchBar.setImage(UIImage(named: "icon_ios_add"), for: UISearchBarIcon.search, state: UIControlState.normal)
        
        self.definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
    
    
    func configureNavigationBar(){
        self.navigationItem.title = shoppingList?.name
        
    }
}

extension ShoppingListViewController : UITabBarDelegate {
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        switch item.title {
        case "Rename" :
            renameTabSelected()
        case "Share" :
            shareTabSelected()
        case "Clear" :
            clearCompletedItems()
        case "Delete" : removeShoppingList()
        default : break
            
            
        }
        
        
    }
    
    fileprivate func renameTabSelected() {
        let alert = UIAlertController(title: "Rename Shopping List", message: "Would you like to rename your Shopping List?", preferredStyle: UIAlertControllerStyle.alert)
        let doneAction = UIAlertAction(title: "Done", style: .default) { (alertAction) in
            if let text = alert.textFields![0].text {
                if text != self.shoppingList.name {
                    FirebaseDAO.renameShoppingList(self.shoppingListId,text)
                }
            }
        }
        alert.addTextField { (textField) in
            textField.text = self.shoppingList?.name
            NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: textField, queue: OperationQueue.main) { (notification) in
                doneAction.isEnabled = (textField.text?.count)! > 0
            }
        }
        alert.addAction(doneAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func shareTabSelected() {
        
    }
    
    func clearCompletedItems(){
        let alert = UIAlertController(title: "Clear Completed Items", message: "Would you like to clear completed items?", preferredStyle: UIAlertControllerStyle.alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (alertAction) in
            let completedItemDoumentRefs = self.completedItems.map{$0.id}
            FirebaseDAO.clearCompletedItems(completedItemDoumentRefs)
            self.completedItems.removeAll()
           
        }
        alert.addAction(yesAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
        

    }
    
    func removeShoppingList(){
        
        let alert = UIAlertController(title: "Delete Shopping List", message: "Would you like to delete \(shoppingList.name) ?", preferredStyle: UIAlertControllerStyle.alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (alertAction) in
            FirebaseDAO.updateShoppingList(self.shoppingListId).subscribe(){ event in
                if let success = event.element, success == true {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        alert.addAction(yesAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    
    
}
