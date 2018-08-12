//
//  HomeViewController.swift
//  FillMyPantry
//
//  Created by BINDU ELAKURTHI on 6/28/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa


class HomeViewController : UITableViewController {
    
    var disposeBag = DisposeBag()
    var shoppingLists : [ShoppingList]!
    var indicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator()
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        indicator.startAnimating()
        indicator.backgroundColor = UIColor.clear
        self.indicator.hidesWhenStopped = true
        FirebaseDAO.getShoppingListsForUser().subscribe(){ event in
            if let element = event.element {
                self.shoppingLists = element
            }
            DispatchQueue.main.async {
                self.indicator.stopAnimating()
                self.tableView.reloadData()
            }
        }
        GroceryCatalog.getGroceryCatalog().subscribe()
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
            cell.count.text = String(shoppingLists[indexPath.row].count)
            
            return cell
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row ==  shoppingLists?.count ?? 0 {
            
            if (shoppingLists?.count ?? 0) == Constants.MAX_SHOPPING_LIST_COUNT{
                let alert = UIAlertController(title: "You've reached the limit", message: "Hello, You can only create upto 15 shopping lists.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }else{
                if Reachability.isConnectedToNetwork(){
                    FirebaseDAO.createShoppingList().subscribe { event in
                        if let id = event.element {
                            self.navigateToShoppingListViewController(id)
                        }
                    }
                }else{
                    Reachability.showNetworkUnavailableDialog(self)
                }
            }
        } else{
            navigateToShoppingListViewController(shoppingLists[indexPath.row].id)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row ==  shoppingLists?.count ?? 0 {
            return false
        } else{
            return true
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            if Reachability.isConnectedToNetwork(){
                FirebaseDAO.updateShoppingList(shoppingLists[indexPath.row].id).subscribe(){ event in
                    if let success = event.element, success == true {
                        self.shoppingLists.remove(at: indexPath.row)
                        self.tableView.reloadData()
                    }
                }
            }else{
                Reachability.showNetworkUnavailableDialog(self)
            }
        }
    }
    
}


