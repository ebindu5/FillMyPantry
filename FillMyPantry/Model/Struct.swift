//
//  ShoppingListStruct.swift
//  FillMyPantry
//
//  Created by NISHANTH NAGELLA on 6/29/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import Firebase

struct ShoppingList {
    var id : String
    var name : String
    var creationDate : NSDate
    var items : [Item]?
    
    init(_ id : String, _ name : String, _ creationDate : NSDate, _ items : [Item]?) {
        self.id = id
        self.name = name
        self.creationDate = creationDate
        
        if let items = items {
            self.items = items
        } else{
            self.items = []
        }
    }
}

struct Item {
    let id : DocumentReference
    var name : String
    var creationDate : NSDate
    var completionDate : NSDate?
    var completed: Bool
    var order : Int
    
    
    init(_ id : DocumentReference, _ name : String, _ creationDate : NSDate, _ completionDate : NSDate?,_ completed : Bool, _ order : Int) {
        self.id = id
        self.name = name
        self.creationDate = creationDate
        self.completed = completed
        self.order = order
        if let completionDate = completionDate {
             self.completionDate = completionDate
        }
    }
    
}


struct Grocery {
    let name : String
    let category: String
    
    init(_ name : String, _ category: String) {
        self.category = category
        self.name = name
    }
}
