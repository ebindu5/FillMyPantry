//
//  CategoriesTabViewController.swift
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

class  CategoriesTabViewController : UITableViewController{
    
    var segmentViewController : SegmentViewController!
    var shoppingListId : String!
    var shoppingListItems : [Item]!
    var groceryCatalog = [[String]]()
    var grocerySection = [String]()
    var expandData = [NSMutableDictionary]()
    var myBoolean = [Bool]()
    var tableViewData = [cellData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Auto resizing the height of the cell
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        var groceryMap = [String: [String]]()
        
        shoppingListId = segmentViewController.shoppingListId
        shoppingListItems = segmentViewController.shoppingListItems
        
        if let catalog = segmentViewController.groceryCatalog {
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
//            cell.accessoryView = UIImageView(image: UIImage(named: "icon_right_arrow"))
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoriesCell", for: indexPath)
            cell.textLabel?.text = tableViewData[indexPath.section].sectionData[indexPath.row - 1]
            return cell
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SectionCell")
            
            if tableViewData[indexPath.section].opened == true {
                
                tableViewData[indexPath.section].opened = false
                let sections = IndexSet.init(integer : indexPath.section)
                tableView.reloadSections(sections, with: .fade)
            }else{
                tableViewData[indexPath.section].opened = true
                let sections = IndexSet.init(integer : indexPath.section)
                tableView.reloadSections(sections, with: .fade)
            }
        }

    }
    
    
    
}
