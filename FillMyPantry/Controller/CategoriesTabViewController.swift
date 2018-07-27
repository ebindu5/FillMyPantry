//
//  CategoriesTabViewController.swift
//  FillMyPantry
//
//  Created by NISHANTH NAGELLA on 7/25/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import UIKit


class  CategoriesTabViewController : UITableViewController,CollapsibleTableViewHeaderDelegate{

    struct Section {
        var name: String
        var collapsed: Bool
        
        init(name: String, collapsed: Bool = false) {
            self.name = name
            self.collapsed = collapsed
        }
    }
    
    var sections = [Section]()
    
    
   
    var segmentViewController = SegmentViewController()
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
        
        for i in 0..<grocerySection.count {
           let sec = Section(name: grocerySection[i], collapsed: false)
            sections.append(sec)
        }
       
    }
    
     func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sections[section].collapsed ? 0 : groceryCatalog[section].count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
     
        return grocerySection.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? CollapsibleTableViewHeader ?? CollapsibleTableViewHeader(reuseIdentifier: "header")
        
        header.titleLabel.text = sections[section].name
        header.arrowLabel.text = ">"
        header.setCollapsed(sections[section].collapsed)
        
        header.section = section
        header.delegate = self
        
        return header
    }
    
    
    func toggleSection(_ header: CollapsibleTableViewHeader, section: Int) {
        let collapsed = !sections[section].collapsed
        
        // Toggle collapse
        sections[section].collapsed = collapsed
        header.setCollapsed(collapsed)
        
        // Reload the whole section
        tableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
    }
    
   
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
//    {
//        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 40))
//        headerView.backgroundColor = UIColor.green
//        let label = UILabel(frame: CGRect(x: 5, y: 3, width: headerView.frame.size.width - 1, height: 20))
//        label.text = "\(grocerySection[section])"
//        headerView.layer.borderWidth = 0.1
//        headerView.addSubview(label)
//        headerView.tag = section + 100
//        
//        let tapgesture = UITapGestureRecognizer(target: self , action: #selector(self.sectionTapped(_:)))
//        headerView.addGestureRecognizer(tapgesture)
//        return headerView
//    }
//    
//    @objc func sectionTapped(_ sender: UITapGestureRecognizer){
//        if(self.expandData[(sender.view?.tag)! - 100].value(forKey: "isOpen") as! String == "1"){
//            self.expandData[(sender.view?.tag)! - 100].setValue("0", forKey: "isOpen")
//        }else{
//            self.expandData[(sender.view?.tag)! - 100].setValue("1", forKey: "isOpen")
//        }
//        self.tableView.reloadSections(IndexSet(integer: (sender.view?.tag)! - 100), with: .automatic)
//    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return grocerySection[section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoriesCell", for: indexPath)
        
        cell.textLabel?.text = groceryCatalog[indexPath.section][indexPath.row]
        return cell
    }
    
    
}
