//
//  SegmentViewController.swift
//  FillMyPantry
//
//  Created by NISHANTH NAGELLA on 7/26/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import  UIKit
import RxSwift
import RxCocoa

class SegmentViewController : UIViewController {

    @IBOutlet weak var segmentController : UISegmentedControl!
    
    var categoriesViewController:CategoriesTabViewController?
    var ABCviewVontroller : ABCTabViewController?
    

    
    var shoppingListId : String!
    var shoppingListItems : [Item]!
    var groceryCatalog : [Grocery]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoriesViewController?.view.isHidden = false
        ABCviewVontroller?.view.isHidden = true
//        GroceryCatalog.getGroceryCatalog().subscribe(){ event in
//            if let catalog = event.element{
//                self.groceryCatalog = catalog
//            }
//        }
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? CategoriesTabViewController {
            categoriesViewController = vc
            categoriesViewController?.segmentViewController = self
            
        }
        
        if let vc = segue.destination as? ABCTabViewController {
            ABCviewVontroller = vc
            ABCviewVontroller?.segmentViewController = self
        }
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GroceryCatalog.getGroceryCatalog().subscribe(){ event in
            if let catalog = event.element{
                self.groceryCatalog = catalog
            }
        }
        
    }
    
   @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        switch segmentController.selectedSegmentIndex {
        case 0:
            categoriesViewController?.view.isHidden = false
            ABCviewVontroller?.view.isHidden = true
            
//            categoriesView.isHidden = true
//            ABCView.isHidden = false
        case 1:
            
            categoriesViewController?.view.isHidden = true
            ABCviewVontroller?.view.isHidden = false
//            categoriesView.isHidden = false
//            ABCView.isHidden = true
            
        default:
            break
        }
    }
    
    
    @IBAction func doneButtonClicked(_ sender : Any){
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
