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
   
    var customTabController : CustomTabBarController!
    var shoppingListId : String!
    var shoppingListItems : [Item]!
    var groceryCatalog = [[String]]()
    var grocerySection = [String]()
    var expandData = [NSMutableDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customTabController = self.tabBarController as? CustomTabBarController
        
        
        
        self.expandData.append(["isOpen":"1","data":["banana","mango","apple"]])
        self.expandData.append(["isOpen":"1","data":["banana"]])
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         var groceryMap = [String: [String]]()
        
        shoppingListId = customTabController.shoppingListId
        shoppingListItems = customTabController.shoppingListItems

        if let catalog = customTabController.groceryCatalog {
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
            self.expandData.append(["isOpen":"1","data":groceryCatalog[i]])
        }

       
    }
    
    
    
    @IBAction func doneButtonClicked(_ sender : Any){
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.expandData[section].value(forKey: "isOpen") as! String == "1"{
            return 0
        }else{
            return groceryCatalog[section].count
        }
        
   
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
     
        return grocerySection.count
    }
    
   
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 40))
        headerView.backgroundColor = UIColor.green
        let label = UILabel(frame: CGRect(x: 5, y: 3, width: headerView.frame.size.width - 1, height: 20))
        label.text = "\(grocerySection[section])"
        headerView.layer.borderWidth = 0.1
        headerView.addSubview(label)
        headerView.tag = section + 100
        
        let tapgesture = UITapGestureRecognizer(target: self , action: #selector(self.sectionTapped(_:)))
        headerView.addGestureRecognizer(tapgesture)
        return headerView
    }
    
    @objc func sectionTapped(_ sender: UITapGestureRecognizer){
        if(self.expandData[(sender.view?.tag)! - 100].value(forKey: "isOpen") as! String == "1"){
            self.expandData[(sender.view?.tag)! - 100].setValue("0", forKey: "isOpen")
        }else{
            self.expandData[(sender.view?.tag)! - 100].setValue("1", forKey: "isOpen")
        }
        self.tableView.reloadSections(IndexSet(integer: (sender.view?.tag)! - 100), with: .automatic)
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
