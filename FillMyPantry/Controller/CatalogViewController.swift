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
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    var categoriesViewController:CategoriesViewController?
    var ABCviewVontroller : ABCViewController?
    var order : Int!
    
    var shoppingListId : String!
    var shoppingListItems = [String]()
    var groceryCatalog : [Grocery]!
    var count : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let titleTextAttributes_normal = [NSAttributedStringKey.foregroundColor: UIColor.black]
        let titleTextAttributes_selected = [NSAttributedStringKey.foregroundColor: UIColor.white]
        segmentController.setTitleTextAttributes(titleTextAttributes_normal, for: .normal)
        segmentController.setTitleTextAttributes(titleTextAttributes_selected, for: .selected)
        segmentController.tintColor = Constants.THEME_COLOR
        doneButton.tintColor = Constants.THEME_COLOR
        categoriesContentView.isHidden = false
        ABCContentView.isHidden = true
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ABCViewController {
            ABCviewVontroller = vc
            ABCviewVontroller?.catalogViewController = self
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
        case 1:
            categoriesContentView.isHidden = true
            ABCContentView.isHidden = false
        default:
            break
        }
    }
    
    
    @IBAction func doneButtonClicked(_ sender : Any){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
}
