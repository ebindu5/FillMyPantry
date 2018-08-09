//
//  FirebaseData.swift
//  FillMyPantry
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

    private static func createNewShoppingListDocument()->Observable<DocumentReference>{
        return Observable.create { observer in
            var ref: DocumentReference? = nil
            ref = db?.collection("ShoppingLists").addDocument(data:[ "name": "My Shopping List","creationDate": FieldValue.serverTimestamp()]) { error in
                if let error = error {
                    observer.onError("Error adding document: \(error)" as! Error)
                } else {
                    observer.onNext(ref!)
                    observer.onCompleted()
                }
            }
            return  Disposables.create()
        }
    }
    
    static func createShoppingList()->Observable<String> {
        
        return Observable.zip(createNewShoppingListDocument(), getShoppingListRefsForUser()){ (newDocumentReference, exisitingDocumentReferences) in
            var existingDocs = exisitingDocumentReferences
            if existingDocs != nil {
                existingDocs.append(newDocumentReference)
            }else{
                existingDocs = [newDocumentReference]
            }
            
            db?.collection("Users").document(Constants.UID).setData(["shoppingLists" : existingDocs], merge: true)
            return newDocumentReference.documentID
        }
    }
    
    
    static func renameShoppingList(_ documentID :String, _ text : String){
        let shoppingListRef = db?.collection("ShoppingLists").document(documentID)

        shoppingListRef?.updateData([
            "name": text
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    private static func testGetShoppingList(){
        getShoppingListRefsForUser().flatMap { docRefArray  in
            return getShoppingListsFromDocRefArray(docRefArray)
            }.subscribe(){ event in
                if let element = event.element {
                    print(element,"::::")
                }
        }
    }
    
    static func getShoppingListsForUser()-> Observable<[ShoppingList]>{
        return getShoppingListRefsForUser().flatMap { docRefArray  in
            return getShoppingListsFromDocRefArray(docRefArray)
        }
        
    }
    
    private static func getShoppingListRefsForUser()->Observable<[DocumentReference]>{
        let docRef = db?.collection("Users").document(Constants.UID)
        return Observable.create { observer in
            docRef?.addSnapshotListener { documentSnapShot, error in
                if let error = error {
                    observer.onError(error)
                } else if let documentSnapShot = documentSnapShot, documentSnapShot.exists {
                    if let data = documentSnapShot.data() {
                        let shoppingLists = data["shoppingLists"] as! [DocumentReference]
                        observer.onNext(shoppingLists)
                    }else{
                        observer.onNext([])
                    }
                } else {
                    observer.onNext([])
                }
            }
            return Disposables.create()
        }
    }
    
    
    private static func getShoppingListFromDocumentSnapShot(_ documentSnapShot: DocumentSnapshot)->Observable<ShoppingList>{
        
        return Observable.create{ observer in
            if let data = documentSnapShot.data() {
                
                var items :[Item]!
                
                
                let name = data["name"] as? String ?? ""
                let timestampDate = ((data["creationDate"] as? Timestamp) ?? Timestamp.init()).dateValue()
                
                
                db?.collection("ShoppingLists/\(documentSnapShot.documentID)/items").addSnapshotListener{  (querySnapshot, error) in
                    
                    if let error = error {
                        items = []
                        observer.onError("Error getting documents: \(error)" as! Error)
                    } else {
                        
                        if let documents = querySnapshot?.documents {
                            items =  getDataFromDocuments(documents)
                        } else{
                            items = []
                        }
                        
                        let shoppinglist = ShoppingList(id: documentSnapShot.documentID, name: name,creationDate: timestampDate as Date,items: items)
                        observer.onNext(shoppinglist)
                    }
                }
            }
            return Disposables.create()
        }
    }
    
    private static func getDataFromDocuments(_ documents : [QueryDocumentSnapshot])->[Item]?{
        var items :[Item]!
        for document in documents {
            let item = document.data()
            
            let itemName = item["name"] as? String ?? ""
            let itemOrder = item["order"] as? Int ?? 1
            let completionDate = ((item["completionDate"] as? Timestamp) ?? Timestamp.init()).dateValue()
            let creationDate = ((item["creationDate"] as? Timestamp) ?? Timestamp.init()).dateValue()
            let completed = item["completed"] as? Bool ?? false
            
            if items != nil {
                items.append(Item(document.reference,itemName,creationDate, completionDate, completed,itemOrder))
            }else{
                items = [Item(document.reference,itemName,creationDate, completionDate, completed,itemOrder)]
            }
        }
        return items
    }
    
    static func getShoppingListFromId(_ documentID : String)->Observable<ShoppingList>{
        
        let documentReference = (db?.document("/ShoppingLists/\((documentID))"))!
        return getShoppingListFromDocRef(documentReference)
    }
    
    private static func getShoppingListFromDocRef(_ documentReference : DocumentReference)-> Observable<ShoppingList>{
        
        return getSnapshotFromDocRef(documentReference).flatMap({ documentSnapShot in
            return getShoppingListFromDocumentSnapShot(documentSnapShot)
        })
    }
    
    private static func getSnapshotFromDocRef(_ documentReference : DocumentReference) -> Observable<DocumentSnapshot>{
        
        return Observable.create{ observer in
            
            documentReference.addSnapshotListener({ (documentSnapShot, error) in
                
                if let error = error {
                    observer.onError(error)
                } else if let documentSnapShot = documentSnapShot, documentSnapShot.exists {
                    observer.onNext(documentSnapShot)
                }else {
                    observer.onError(NSError(domain: FirestoreErrorDomain, code: FirestoreErrorCode.notFound.rawValue, userInfo: nil))
                }
            })
            return Disposables.create()
        }
    }
    
    
    private static func getShoppingListsFromDocRefArray(_ documentReferences : [DocumentReference])->Observable<[ShoppingList]>{
        var shoppingListObservableList = [Observable<ShoppingList>]()
        for documentReference in documentReferences{
            shoppingListObservableList.append(getShoppingListFromDocRef(documentReference))
        }
        
        if shoppingListObservableList.count == 0 {
            return Observable.just([])
        }else{
            return Observable.zip(shoppingListObservableList){ shoppingLists in
                return shoppingLists
            }
        }
       
    }
    
    private static  func deleteShoppingList(_ documentID : String)->Observable<DocumentReference>{
        let documentReference = (db?.document("/ShoppingLists/\((documentID))"))!
        
        return Observable.create{ observer in
            documentReference.delete() { error in
                if let error = error {
                    observer.onError("Error removing document: \(error)" as! Error)
                } else {
                    observer.onNext(documentReference)
                }
            }
            return Disposables.create()
        }
    }
    
    
    static func updateShoppingList(_ documentID : String)->Observable<Bool> {
        return Observable.zip(deleteShoppingList(documentID), getShoppingListRefsForUser()){ (deletableDocumentReference, exisitingDocumentReferences) in
            var existingDocs = exisitingDocumentReferences
            if let index = existingDocs.index(of: deletableDocumentReference) {
                existingDocs.remove(at: index)
            }
            db?.collection("Users").document(Constants.UID).setData(["shoppingLists" : existingDocs], merge: true)
            return true
        }
    }
    
    static func updateShoppingListItem(_ documentReference : DocumentReference, _ isCompleted : Bool, _ order : Int){
       
            documentReference.updateData([
                "completed": isCompleted,
                "completionDate" : FieldValue.serverTimestamp(),
                "order" : order
                
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }

    }
    
    
    static  func addItemToShoppingList(_ documentId: String, _ itemName : String, _ order : Int)-> Observable<Bool>{
        
        return Observable.create { observer in
            var ref: DocumentReference? = nil
            ref = db?.collection("ShoppingLists/\(documentId)/items").addDocument(data:["completed": false,"creationDate": FieldValue.serverTimestamp(),"completionDate" : FieldValue.serverTimestamp() , "name" : itemName, "order" : order ]) { error in
                if let error = error {
                    observer.onError("Error adding document: \(error)" as! Error)
                } else {
                    observer.onNext(true)
                    observer.onCompleted()
                }
            }
            return  Disposables.create()
        } 
    }
    

   static func clearCompletedItems(_ documentRefs : [DocumentReference]!){
        for document in documentRefs {
            document.delete(){ err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                }
            }
        }
        
    }
}








