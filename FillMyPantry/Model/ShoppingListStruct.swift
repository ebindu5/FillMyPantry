//
//  Struct.swift
//  Fill My Pantry
//
//  Created by NISHANTH NAGELLA on 6/29/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation

struct ShoppingList {
    var name : String
    var creationDate : NSDate
    var items : [Item]?
    
    init(_ name : String, _ creationDate : NSDate, _ items : [Item]?) {
        self.name = name
        self.creationDate = creationDate
        
        if let items = items {
            self.items = items
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
