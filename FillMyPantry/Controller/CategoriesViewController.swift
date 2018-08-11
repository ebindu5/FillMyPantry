//
//  CategoriesViewController.swift
//  FillMyPantry
//
//  Created by NISHANTH NAGELLA on 7/25/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import UIKit

struct cellData {
    
    var opened = Bool()
    var title = String()
    var sectionData = [String]()
}

class  CategoriesViewController : UITableViewController{
    
    var catalogViewController = CatalogViewController()
    var shoppingListId : String!
    var groceryCatalog = [[String]]()
    var grocerySection = [String]()
    var expandData = [NSMutableDictionary]()
    var myBoolean = [Bool]()
    var tableViewData = [cellData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        var groceryMap = [String: [String]]()
        shoppingListId = catalogViewController.shoppingListId
        if let catalog = catalogViewController.groceryCatalog {
            for grocery in catalog {
                if groceryMap[grocery.category] != nil {
                    groceryMap[grocery.category]?.append(grocery.name)
                }else{
                    groceryMap[grocery.category] = [grocery.name]
                }
            }
            grocerySection = Array(groceryMap.keys)
            groceryCatalog = Array(groceryMap.values)
            
            for i in 0..<groceryCatalog.count {
                groceryCatalog[i].sort()
            }
        }
        
        for i in 0..<grocerySection.count {
            tableViewData.append(cellData(opened: true, title: grocerySection[i], sectionData: groceryCatalog[i]))
        }
        
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableViewData[section].opened == true {
            return  tableViewData[section].sectionData.count + 1
        }else{
            return 1
        }
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SectionCell") else{
                return UITableViewCell()
            }
            
            cell.textLabel?.text = tableViewData[indexPath.section].title
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoriesCell", for: indexPath) as! searchResultCell
            let groceryName = tableViewData[indexPath.section].sectionData[indexPath.row - 1]
            cell.textCell.text = groceryName
            
            cell.addButton.addTarget(self, action: #selector(CategoriesViewController.addItemtoShoppingList(_:)), for: .touchUpInside)
            cell.addButton.tag = (indexPath.section*100)+indexPath.row
            if catalogViewController.shoppingListItems.contains(groceryName){
                cell.addButton.setImage(UIImage(named: "icon_done"), for: .normal)
            }else{
                cell.addButton.setImage(UIImage(named: "circleAddIcon"), for: .normal)
                
            }
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row == 0) {
            if tableViewData[indexPath.section].opened == true {
                
                tableViewData[indexPath.section].opened = false
                let sections = IndexSet.init(integer : indexPath.section)
                tableView.reloadSections(sections, with: .fade)
            }else{
                tableViewData[indexPath.section].opened = true
                let sections = IndexSet.init(integer : indexPath.section)
                tableView.reloadSections(sections, with: .fade)
            }
        } else{
            
            tableView.deselectRow(at: indexPath, animated: true)
            self.addItem(indexPath as NSIndexPath)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        if  isGroceryItemPresent(indexPath){
            return nil
        } else{
            return indexPath
        }
    }
    
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return !isGroceryItemPresent(indexPath)
    }
    
    @objc func refreshTable(notification: NSNotification) {
        self.tableView.reloadData()
    }
    
    func isGroceryItemPresent(_ indexPath : IndexPath)-> Bool{
        if indexPath.row != 0 {
            let groceryName = tableViewData[indexPath.section].sectionData[indexPath.row - 1]
            if catalogViewController.shoppingListItems.contains(groceryName){
                return true
            } else{
                return false
            }
        }else{
            return false
        }
        
    }
    
    fileprivate func addItem(_ indexPath: NSIndexPath) {
        FirebaseDAO.addItemToShoppingList(shoppingListId, tableViewData[indexPath.section].sectionData[indexPath.row - 1], catalogViewController.order).subscribe{ event in
            if event.element != nil {
                self.catalogViewController.count = self.catalogViewController.count + 1
                FirebaseDAO.updateShoppingListItemCount(self.shoppingListId, self.catalogViewController.count)
            }
        }
        catalogViewController.order = catalogViewController.order + 1
        catalogViewController.shoppingListItems.append(tableViewData[indexPath.section].sectionData[indexPath.row - 1])
        self.tableView.reloadRows(at: [indexPath as IndexPath], with: .fade)
    }
    
    @objc func addItemtoShoppingList(_ sender: UIButton) {
        let section = sender.tag / 100
        let row = sender.tag % 100
        let indexPath = NSIndexPath(row: row, section: section)
        
        addItem(indexPath)
    }
    
}
