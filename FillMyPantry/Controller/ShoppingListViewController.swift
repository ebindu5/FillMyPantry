//
//  ShoppingListViewController.swift
//  FillMyPantry
//
//  Created by NISHANTH NAGELLA on 7/12/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class ShoppingListViewController : UIViewController, UITableViewDelegate,UITableViewDataSource, UISearchControllerDelegate, UISearchBarDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noItemsText: UITextField!
    @IBOutlet weak var tabBar: UITabBar!
    
    var searchResultsTableController : SearchResultsTableController!
    
    var searchController = UISearchController(searchResultsController: nil)
    
    var shoppingListId : String!

    struct ShoppingListTableData {
        var completedItems = [Item]()
        var uncompletedItems =  [Item]()
        let title : String
        var newItemOrder = 1
        var uncompletedItemOrder = 1
        
        init(title : String) {
            self.title = title
        }
    }
    
    var shoppingListTableData = ShoppingListTableData(title: "")
    

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
            }
            return shoppingListData
            }.subscribe{ event in
                if let shoppingData = event.element {
                    self.shoppingListTableData = shoppingData
                    self.noItemsText.isHidden = !( shoppingData.completedItems.count == 0 && shoppingData.uncompletedItems.count == 0 )
                    self.searchResultsTableController.order = shoppingData.newItemOrder
                    self.configureNavigationBar()
                    self.tableView.reloadData()
                }
                
        }
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
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
        catalogViewController?.shoppingListItems = shoppingListTableData.uncompletedItems
        
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
        self.navigationItem.title = shoppingListTableData.title
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
                if text != self.shoppingListTableData.title{
                    FirebaseDAO.renameShoppingList(self.shoppingListId,text)
                }
            }
        }
        alert.addTextField { (textField) in
            textField.text = self.shoppingListTableData.title
            NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: textField, queue: OperationQueue.main) { (notification) in
                doneAction.isEnabled = (textField.text?.count)! > 0
            }
        }
        alert.addAction(doneAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func shareTabSelected() {
        let firstActivityItem = getShareListText()
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [firstActivityItem], applicationActivities: nil)
        
        // This lines is for the popover you need to show in iPad
        //        activityViewController.popoverPresentationController?.sourceView = (sender as! UIButton)
        
        // This line remove the arrow of the popover to show in iPad
        //        activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.allZeros
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    func clearCompletedItems(){
        let alert = UIAlertController(title: "Clear Completed Items", message: "Would you like to clear completed items?", preferredStyle: UIAlertControllerStyle.alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (alertAction) in
            let completedItemDoumentRefs = self.shoppingListTableData.completedItems.map{$0.id}
            FirebaseDAO.clearCompletedItems(completedItemDoumentRefs)
            //            self.completedItems.removeAll()
        }
        alert.addAction(yesAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
        
        
    }
    
    func removeShoppingList(){
        
        let alert = UIAlertController(title: "Delete Shopping List", message: "Would you like to delete \(shoppingListTableData.title) ?", preferredStyle: UIAlertControllerStyle.alert)
        
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
    
    
    func getShareListText() -> String{
        var shareText = ""
        
        shareText.append("\(shoppingListTableData.title) \n\n")
        
        for item in shoppingListTableData.uncompletedItems {
            shareText.append("\(item.name)\n")
        }
        
        for item in shoppingListTableData.completedItems {
            shareText.append("\(item.name)\n")
        }
        
        shareText.append("\nSent with FillMyPantry. Available free for your phone.")
        return shareText
    }
    
    
    
}
