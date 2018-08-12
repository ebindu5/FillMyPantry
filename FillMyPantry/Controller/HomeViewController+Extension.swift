//
//  HomeViewController+Extension.swift
//  FillMyPantry
//
//  Created by BINDU ELAKURTHI on 8/11/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit

extension HomeViewController {
     func activityIndicator() {
        indicator = UIActivityIndicatorView(frame: CGRect(x:0, y:0, width:80,height: 80))
        self.indicator.transform = CGAffineTransform(scaleX: 2, y: 2)
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        indicator.hidesWhenStopped = true
        indicator.center = self.view.center
        self.view.addSubview(indicator)
    }
    
     func navigateToShoppingListViewController(_ id : String){
        let shoppingListViewController = self.storyboard?.instantiateViewController(withIdentifier: "ShoppingListViewController") as! ShoppingListViewController
        
        shoppingListViewController.shoppingListId = id
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        navigationItem.backBarButtonItem?.tintColor = Constants.THEME_COLOR
        self.navigationController?.pushViewController(shoppingListViewController, animated: true)
    }
}
