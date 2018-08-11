//
//  Constants.swift
//  FillMyPantry
//
//  Created by NISHANTH NAGELLA on 6/27/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import Firebase

class Constants {
    static var UID : String!
    static var dbRef : Firestore!
    static var showCompletedItems = false
    
    static let SEARCH_RESULTS_COUNT = 10
    static let THEME_COLOR = UIColor.init(red: 53 / 255.0, green: 188 / 255.0, blue: 0 / 255.0, alpha: 1.0)
    static let MAX_SHOPPING_LIST_COUNT = 15
//    static let TEXT_COLOR =  UIColor.init(red: 31 / 255.0, green: 202 / 255.0, blue: 29 / 255.0, alpha: 1.0)
}
