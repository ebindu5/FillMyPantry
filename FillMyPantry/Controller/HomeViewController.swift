//
//  HomeViewController.swift
//  Fill My Pantry
//
//  Created by NISHANTH NAGELLA on 6/28/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa


class HomeViewController : UITableViewController {
    var users:[NSDictionary] = []
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
            print("rows:..",shoppingLists.count)
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
            return cell
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        FirebaseDAO.createShoppingList().subscribe()
        
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 {
            return true
        } else{
            return false
        }
    }
    
}
