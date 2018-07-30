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
    var groceryCatalog : [Grocery]!
    
    var indicator = UIActivityIndicatorView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        indicator.startAnimating()
        indicator.backgroundColor = UIColor.clear
        FirebaseDAO.getShoppingListsForUser().subscribe(){ event in
            if let element = event.element {
                self.shoppingLists = element
                DispatchQueue.main.async {
                    self.indicator.stopAnimating()
                    self.indicator.hidesWhenStopped = true
                    self.tableView.reloadData()
                }
            }
        }
        
        GroceryCatalog.getGroceryCatalog().subscribe{ event in
            if let element = event.element{
                self.groceryCatalog = element
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
            
            FirebaseDAO.createShoppingList().subscribe { event in
                if let id = event.element {
                    let shoppingListViewController = self.storyboard?.instantiateViewController(withIdentifier: "ShoppingListViewController") as! ShoppingListViewController
                    shoppingListViewController.shoppingListId = id
                    self.navigationController?.pushViewController(shoppingListViewController, animated: true)
                }
            }
        } else{
            let shoppingListViewController = self.storyboard?.instantiateViewController(withIdentifier: "ShoppingListViewController") as! ShoppingListViewController
            
            shoppingListViewController.shoppingListId = shoppingLists[indexPath.row].id
            self.navigationController?.pushViewController(shoppingListViewController, animated: true)
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
            FirebaseDAO.updateShoppingList(shoppingLists[indexPath.row].id).subscribe(){ event in
                if let success = event.element, success == true {
                    self.shoppingLists.remove(at: indexPath.row)
                    tableView.reloadData()
                }
            }
            
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func activityIndicator() {
        indicator = UIActivityIndicatorView(frame: CGRect(x:0, y:0, width:80,height: 80))
        self.indicator.transform = CGAffineTransform(scaleX: 2, y: 2)
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        indicator.hidesWhenStopped = true
        indicator.center = self.view.center
        self.view.addSubview(indicator)
    }
    
}
