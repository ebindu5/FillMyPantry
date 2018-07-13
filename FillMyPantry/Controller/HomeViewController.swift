//
//  HomeViewController.swift
//  FillMyPantry
//
//  Created by NISHANTH NAGELLA on 6/28/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa


class HomeViewController : UITableViewController {
    
    var disposeBag = DisposeBag()
    var shoppingLists : [ShoppingList]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        FirebaseDAO.getShoppingListsForUser().subscribe(){ event in
            if let element = event.element {
                self.shoppingLists = element
                self.tableView.reloadData()
            }
        }
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let shoppingLists = shoppingLists {
            return shoppingLists.count + 1
        }else{
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if (indexPath.row ==  shoppingLists?.count ?? 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CreateListCell", for: indexPath)
            return cell
        } else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingCell", for: indexPath) as! ShoppingCell
            cell.listName.text = shoppingLists[indexPath.row].name
            if let items = shoppingLists[indexPath.row].items {
             cell.count.text = String(items.count)
            } else{
                cell.count.text = "0"
            }
            
            
            return cell
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
      if indexPath.row ==  shoppingLists?.count ?? 0 {
        FirebaseDAO.createShoppingList().subscribe()
        let shoppingListViewController = self.storyboard?.instantiateViewController(withIdentifier: "ShoppingListViewController") as! ShoppingListViewController
        self.navigationController?.pushViewController(shoppingListViewController, animated: true)
      } else{
        let shoppingListViewController = self.storyboard?.instantiateViewController(withIdentifier: "ShoppingListViewController") as! ShoppingListViewController
        
        shoppingListViewController.shoppingList = shoppingLists[indexPath.row]
        self.navigationController?.pushViewController(shoppingListViewController, animated: true)
        }
       

    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row ==  shoppingLists?.count ?? 0 {
            return true
        } else{
            return false
        }
    }
    
}
