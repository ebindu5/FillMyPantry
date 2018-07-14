//
//  ShoppingListStruct.swift
//  FillMyPantry
//
//  Created by NISHANTH NAGELLA on 6/29/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation

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
    var name : String
    var creationDate : NSDate
    var completionDate : NSDate?
    var completed: Bool
    var order : Int
    
    
    init(_ name : String, _ creationDate : NSDate, _ completionDate : NSDate?,_ completed : Bool, _ order : Int) {
        self.name = name
        self.creationDate = creationDate
        self.completed = completed
        self.order = order
        if let completionDate = completionDate {
             self.completionDate = completionDate
        }
    }
    
}
