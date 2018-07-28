//
//  ImportData.swift
//  FillMyPantry
//
//  Created by NISHANTH NAGELLA on 7/27/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import Firebase

var db = Constants.dbRef

func readData() {
    var groceryList = [Grocery]()
//    let path = Bundle.main.path(forResource: "GroceryData" , ofType: "csv")!
    let path = Bundle.main.path(forResource: "GroceryData", ofType: "csv")!
    let csvData = try? NSString.init(contentsOf: URL(fileURLWithPath: path), encoding: String.Encoding.utf8.rawValue)
    if let gcRawData = csvData?.components(separatedBy: "\r"){
        for row in gcRawData {
           let values =  row.split(separator: ",")
            
            groceryList.append(Grocery(String(values[0]), String(values[1])))
        }
    }

    createData(groceryList)
    print(groceryList,":::")
    
}


func createData(_ catalog : [Grocery]){
        var ref: DocumentReference? = nil
    
    for i in 0..<catalog.count {
        
        
       db?.collection("GroceryCatalog").document(String(i)).setData([
            "name": catalog[i].name,
            "category": catalog[i].category,
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
        
//            .addDocument(data:[ "name": "My Shopping List","creationDate": FieldValue.serverTimestamp()]) { error in
//            if let error = error {
//                observer.onError("Error adding document: \(error)" as! Error)
//            } else {
//                observer.onNext(ref!)
//                observer.onCompleted()
//            }
//        }
        
    }
    

}

//NSString *lines = [NSString stringWithContentsOfFile:path];
//let db = try! Connection(path, readonly: true)

//let fileName = "Tasks.csv"
//let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
