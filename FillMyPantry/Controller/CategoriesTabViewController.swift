//
//  CategoriesTabViewController.swift
//  FillMyPantry
//
//  Created by NISHANTH NAGELLA on 7/25/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import UIKit


class  CategoriesTabViewController : UITableViewController{

    var segmentViewController : SegmentViewController!
    var shoppingListId : String!
    var shoppingListItems : [Item]!
    var groceryCatalog = [[String]]()
    var grocerySection = [String]()
    var expandData = [NSMutableDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
//        for i in 0..<grocerySection.count {
//           let sec = Section(name: grocerySection[i], collapsed: false)
//            sections.append(sec)
//        }


    }
    
     func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if self.expandData[section].value(forKey: "isOpen") as! String == "1"{
//            return 0
//        }else{
            return groceryCatalog[section].count
//        }

//        return sections[section].collapsed ? 0 : groceryCatalog[section].count
        

    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return grocerySection.count
    }
 

    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return grocerySection[section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoriesCell", for: indexPath)

        cell.textLabel?.text = groceryCatalog[indexPath.section][indexPath.row]
        return cell

    }
   
  
    
}
