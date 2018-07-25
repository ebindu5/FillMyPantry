//
//  GroceryCatlog.swift
//  FillMyPantry
//
//  Created by NISHANTH NAGELLA on 7/19/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Firebase

class GroceryCatalog {
    
    private static var groceryCatalog = [Grocery]()
    static var db = Constants.dbRef
    
    static func getGroceryCatalog()-> Observable<[Grocery]>{
        if groceryCatalog.count != 0 {
            return Observable.deferred{
                return  Observable.just(groceryCatalog)
            }
        } else{
            return Observable.create{ observer in
                db?.collection("GroceryCatalog").addSnapshotListener{ documentSnapshot, error in
                    
                    if error != nil {
                        observer.onError(error!)
                    }
//                    print(documentSnapshot?.metadata.isFromCache,"--->DataIsFromCache", documentSnapshot?.documents.count)
                    if let documents = documentSnapshot?.documents {
                        getDataFromDocuments(documents)
                        
                        observer.onNext(groceryCatalog)
                    }
                }
                return Disposables.create()
            }
        }
    }
    
    
    private static func getDataFromDocuments(_ documents : [QueryDocumentSnapshot]){
        groceryCatalog.removeAll()
        for document in documents {
            let data = document.data()
            let name = data["name"] as? String ?? ""
            let category = data["category"] as? String ?? ""
            groceryCatalog.append(Grocery(name,category))
        }
        
    }
    
}
