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
            ref = db?.collection("ShoppingLists").addDocument(data:[ "name": "My Shopping List","creationDate": FieldValue.serverTimestamp(),"items": []]) { error in
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
            existingDocs.append(newDocumentReference)
            db?.collection("Users").document(Constants.UID).setData(["shoppingLists" : existingDocs], merge: true)
            return newDocumentReference.documentID
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

    
    private static func getShoppingListFromDocumentSnapShot(_ documentSnapShot: DocumentSnapshot)->Observable<ShoppingList>{
        
        return Observable.create{ observer in
            if let data = documentSnapShot.data() {
                var name : String!
                var items :[Item]!
                var timestampDate : NSDate!
                db?.collection("ShoppingLists/\(documentSnapShot.documentID)/items").getDocuments(){ (querySnapshot, error) in
                    if let error = error {
                        items = []
                        observer.onError("Error getting documents: \(error)" as! Error)
                    } else {
                        if let names = data["name"] as? String {
                            name = names
                        }else{
                            name = ""
                        }
                        if let date =  data["creationDate"] as? Timestamp{
                            timestampDate =  date.dateValue() as NSDate
                        }else{
                            timestampDate = nil
                        }
                        if let snap = querySnapshot {
                            items =  getDataFromDocuments(snap.documents)
                        } else{
                            items = []
                        }
                        if let documents = querySnapshot?.documents {
                           items =  getDataFromDocuments(documents)
                        } else{
                            items = []
                        }
                        let shoppinglist = ShoppingList(documentSnapShot.documentID, name,timestampDate,items)
                        observer.onNext(shoppinglist)
                        observer.onCompleted()
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
            
            let itemName : String!
            let itemOrder : Int!
            let completionDate : NSDate!
            let creationDate: NSDate!
            let completed : Bool!

            if let name = item["name"] as? String{
                itemName = name
            } else{
                itemName = ""
            }
            
            if let order = item["order"] as? Int{
                itemOrder = order
            } else{
                itemOrder = 0
            }
            
            if let completionD = item["completionDate"] as? Timestamp{
                completionDate = completionD.dateValue() as NSDate
            } else{
                completionDate = nil
            }
            
            if let creationD = item["creationDate"] as? Timestamp{
                creationDate = creationD.dateValue() as NSDate
            } else{
                creationDate = nil
            }
            
            if let completedValue = item["completed"] as? Bool{
                completed = completedValue
            } else{
                completed = false
            }
            
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
            documentReference.getDocument(source: FirestoreSource.default, completion: { (documentSnapShot, error) in
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
        
        return Observable.zip(shoppingListObservableList){ shoppingLists in
            return shoppingLists
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
    
    static func updateShoppingListItem(_ documentReference : DocumentReference, _ isCompleted : Bool){
        documentReference.updateData([
            "completed": isCompleted
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    private static func listen(includeMetadataChanges: Bool) -> Observable<DocumentSnapshot> {
        return Observable<DocumentSnapshot>.create { observer in
            let listener = db?.collection("Users").document(Constants.UID).addSnapshotListener(includeMetadataChanges: includeMetadataChanges) { snapshot, error in
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








