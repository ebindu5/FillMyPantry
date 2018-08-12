//
//  ShoppingListViewController+Extension.swift
//  FillMyPantry
//
//  Created by NISHANTH NAGELLA on 8/11/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit

extension ShoppingListViewController {
    
    //MARK: - SearchBar Delegate Methods
    
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
        catalogViewController?.order = shoppingListTableData.newItemOrder
        catalogViewController?.count = shoppingListTableData.count
        self.present(catalogViewController!, animated: true, completion: nil)
    }

    //MARK: - Configure view controller
    
    func configureSearchController() {
        searchResultsTableController = storyboard!.instantiateViewController(withIdentifier: "SearchResultsTableController") as! SearchResultsTableController
        searchResultsTableController.shoppingListID = shoppingListId
        searchResultsTableController.count = count
        
        searchController = UISearchController(searchResultsController: searchResultsTableController)
        searchController.searchResultsUpdater = searchResultsTableController
        searchController.dimsBackgroundDuringPresentation = true
        searchController.view.backgroundColor = UIColor.init(red: 51 / 255.0, green: 51 / 255.0, blue: 51 / 255.0, alpha: 0.55)
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchBar.delegate = self
        searchController.searchBar.showsBookmarkButton = true
        searchController.searchBar.barTintColor = UIColor.init(red: 230 / 255.0, green: 230 / 255.0, blue: 230 / 255.0, alpha: 1.0)
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Add an Item..."
        searchController.searchBar.sizeToFit()
        
        searchController.searchBar.setImage(UIImage(named: "icon_plus"), for: UISearchBarIcon.search, state: UIControlState.normal)
        
        searchController.searchBar.setImage(UIImage(named: "icon_catalog"), for: UISearchBarIcon.bookmark, state: UIControlState.normal)
        
        self.definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
    
    
    func configureNavigationBar(){
        self.navigationItem.title = shoppingListTableData.title
    }
    
    func configureTabBar(){
        self.tabBarController?.tabBar.tintColor = Constants.THEME_COLOR
        let titleTextAttributes_normal = [NSAttributedStringKey.foregroundColor: Constants.THEME_COLOR]
        UITabBarItem.appearance().setTitleTextAttributes(titleTextAttributes_normal, for: .normal)
    }
    
    //MARK: - Tab bar delegate Methods
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
        if let popOver = activityViewController.popoverPresentationController {
            popOver.sourceView = self.view
        }
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    func clearCompletedItems(){
        let alert = UIAlertController(title: "Clear Completed Items", message: "Would you like to clear completed items?", preferredStyle: UIAlertControllerStyle.alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (alertAction) in
            let completedItemDoumentRefs = self.shoppingListTableData.completedItems.map{$0.id}
            FirebaseDAO.clearCompletedItems(completedItemDoumentRefs)
            FirebaseDAO.updateShoppingListItemCount(self.shoppingListId, self.shoppingListTableData.uncompletedItems.count)
        }
        alert.addAction(yesAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func removeShoppingList(){
        
        if Reachability.isConnectedToNetwork(){
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
        }else{
            Reachability.showNetworkUnavailableDialog(self)
        }
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
