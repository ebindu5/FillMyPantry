//
//  FirebaseData.swift
//  Fill My Pantry
//
//  Created by NISHANTH NAGELLA on 6/29/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import Firebase
import RxSwift
import RxCocoa

class FirebaseDAO {
    
    static var db = Constants.dbRef
    
    static func createShoppingList() {
        var ref: DocumentReference? = nil
        ref = db?.collection("ShoppingLists").addDocument(data:[ "name": "Tokyo","creationDate": FieldValue.serverTimestamp(),"items": []]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                var shoppingLists = UserData.userShoppingList
                shoppingLists?.append((db?.document("/ShoppingLists/\((ref?.documentID)!)"))!)
                db?.collection("users").document(Constants.UID).setData(["shoppingLists" : shoppingLists!], merge: true) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        UserData.userShoppingList = shoppingLists
                        print("Document successfully written!")
                    }
                }
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
    
    //    static func testGetShoppingList(){
    //        getShoppingListRefsForUser().subscribe(){ event in
    //            if let element = event.element {
    //                for i in element {
    //                    print(i.path)
    //                }
    //            }
    //        }
    //    }
    
    static private func getShoppingListRefsForUser()->Observable<[DocumentReference]>{
        
        let docRef = db?.collection("users").document(Constants.UID)
        return Observable.create { observer in
            docRef?.getDocument { documentSnapShot, error in
                if let error = error {
                    observer.onError(error)
                } else if let documentSnapShot = documentSnapShot, documentSnapShot.exists {
                    if let data = documentSnapShot.data() {
                        let shoppingLists = data["shoppingLists"] as! [DocumentReference]
                        observer.onNext(shoppingLists)
                    }else{
                        observer.onNext([])
                    }
                    observer.onCompleted()
                } else {
                    observer.onError(NSError(domain: FirestoreErrorDomain, code: FirestoreErrorCode.notFound.rawValue, userInfo: nil))
                }
            }
            return Disposables.create()
        }
    }
    
    
    static  func listen(includeMetadataChanges: Bool) -> Observable<DocumentSnapshot> {
        return Observable<DocumentSnapshot>.create { observer in
            let listener = db?.collection("users").document(Constants.UID).addSnapshotListener(includeMetadataChanges: includeMetadataChanges) { snapshot, error in
                if let error = error {
                    observer.onError(error)
                } else if let snapshot = snapshot {
                    observer.onNext(snapshot)
                }
            }
            return Disposables.create {
                listener!.remove()
            }
        }
    }
    
    
    
}








