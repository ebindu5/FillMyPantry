//
//  CatalogViewController.swift
//  FillMyPantry
//
//  Created by NISHANTH NAGELLA on 7/26/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import  UIKit
import RxSwift
import RxCocoa

class CatalogViewController : UIViewController {

    @IBOutlet weak var segmentController : UISegmentedControl!
    @IBOutlet weak var categoriesContentView: UIView!
    @IBOutlet weak var ABCContentView: UIView!
    
    var categoriesViewController:CategoriesViewController?
    var ABCviewVontroller : ABCViewController?
    

    
    var shoppingListId : String!
    var shoppingListItems : [Item]!
    var groceryCatalog : [Grocery]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
//        let titleTextAttributes = [kCTForegroundColorAttributeName: UIColor.black]
        
        segmentController.setTitleTextAttributes(titleTextAttributes, for: .normal)
        segmentController.setTitleTextAttributes(titleTextAttributes, for: .selected)
        segmentController.tintColor = UIColor.green

        categoriesContentView.isHidden = false
        ABCContentView.isHidden = true
        
//        categoriesViewController?.view.isHidden = false
//        ABCviewVontroller?.view.isHidden = true
//        GroceryCatalog.getGroceryCatalog().subscribe(){ event in
//            if let catalog = event.element{
//                self.groceryCatalog = catalog
//            }
//        }
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        
        if let vc = segue.destination as? ABCViewController {
            ABCviewVontroller = vc
            ABCviewVontroller?.segmentViewController = self
        }
        
        if let vc = segue.destination as? CategoriesViewController {
            categoriesViewController = vc
            categoriesViewController?.catalogViewController = self
            
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
            categoriesContentView.isHidden = false
            ABCContentView.isHidden = true
//            categoriesViewController?.view.isHidden = false
//            ABCviewVontroller?.view.isHidden = true
        case 1:
            categoriesContentView.isHidden = true
            ABCContentView.isHidden = false
            
//            categoriesViewController?.view.isHidden = true
//            ABCviewVontroller?.view.isHidden = false
        default:
            break
        }
    }
    
    
    @IBAction func doneButtonClicked(_ sender : Any){
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
