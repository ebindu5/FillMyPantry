//
//  ShoppingListViewController.swift
//  FillMyPantry
//
//  Created by NISHANTH NAGELLA on 7/12/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import UIKit

class ShoppingListViewController : UIViewController, UITableViewDelegate,UITableViewDataSource{
    
//    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    let searchController = UISearchController(searchResultsController: nil)
    
    var shoppingListId : String!
    var shoppingList : ShoppingList!
    var completedItems = [Item]()
    var uncompletedItems =  [Item]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    
        searchController.searchBar.showsCancelButton = true
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.dimsBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "Add an Item..."
//        mysearchController.searchBar.barStyle = UIBarStyle.black

      
        for subView1 in searchController.searchBar.subviews{
            for subView2 in subView1.subviews{

                if subView2.isKind(of: UIButton.self){
                    let customizedCancelButton:UIButton = subView2 as! UIButton
                    customizedCancelButton.isEnabled = true
                    customizedCancelButton.setTitle("", for: .normal)
                    let image1 = UIImage(named: "icon_ios_folder")
                    customizedCancelButton.setBackgroundImage(image1, for: .normal)
                    customizedCancelButton.addTarget(self, action: #selector(sort), for: UIControlEvents.touchUpInside)
                }
            }
        }
        
        tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
    }
    
    @objc func sort(){
        print("sort button fired!!!")
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
        if let shoppingListValue = shoppingList {
            return (shoppingListValue.items?.count)! + 2
        }else{
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
        }else {               // Completed List Items
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
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
      
        if indexPath.row == uncompletedItems.count + 1 { // Show Hide button
            
            let cell = tableView.cellForRow(at: indexPath) as! ShoppingListItemCell
            if (cell.labeltoShowHide.text?.contains("Show"))! {
                cell.labeltoShowHide.text =  "Hide Completed Items"
                Constants.showCompletedItems = true
            }else{
                cell.labeltoShowHide.text =  "Show Completed Items"
                Constants.showCompletedItems = false
            }
        } else if indexPath.row == uncompletedItems.count { // Add an Item
            
            
        } else if indexPath.row < uncompletedItems.count { // Uncompleted List Items
                FirebaseDAO.updateShoppingListItem(uncompletedItems[indexPath.row].id, true)
            completedItems.append(uncompletedItems[indexPath.row])
            uncompletedItems.remove(at: indexPath.row)
        } else {      // Completed List Items
                FirebaseDAO.updateShoppingListItem(completedItems[indexPath.row - uncompletedItems.count - 2].id, false)
            uncompletedItems.append(completedItems[indexPath.row - uncompletedItems.count - 2])
            completedItems.remove(at: indexPath.row - uncompletedItems.count - 1)
        }
        tableView.reloadData()
    }
    
  
}

extension ShoppingListViewController {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        LoadingOverlay.shared.showOverlay(self.view)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        LoadingOverlay.shared.hideOverlayView()
    }

}
