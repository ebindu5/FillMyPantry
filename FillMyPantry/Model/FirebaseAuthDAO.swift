//
//  FirebaseAuthDAO.swift
//  FillMyPantry
//
//  Created by NISHANTH NAGELLA on 7/9/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import Firebase
import RxSwift
import RxCocoa

class FirebaseAuthDAO {
    static var db = Constants.dbRef
    
    static func  anonymousUserInstantiation() -> Single<String>{
        return Single<String>.create { singleObserver in
            Auth.auth().signInAnonymously() { (authResult, error) in
                guard error == nil else {
                    singleObserver(.error(error!.localizedDescription as! Error))
                    return
                }
                guard let authResult = authResult else {
                    singleObserver(.error("FIRAuthDataResult object is nil" as! Error))
                    return
                }
                print("AuthId =  ", authResult.user.uid)
                Constants.UID = authResult.user.uid
                singleObserver(.success(authResult.user.uid))
            }
              return Disposables.create()
        }
    }
    
    
    private  static func createDocumentInUsersNode(_ uid : String) -> Single<String>{
        return Single<String>.create{ singleObserver in
            print("UID = ", uid)
            db?.collection("Users").document(uid).setData([
                "shoppingLists": []
            ]) { error in
                if let error = error {
                    singleObserver(.error(error.localizedDescription as! Error))
                    return
                } else {
                   
                    singleObserver(.success(uid))
                }
            }
            return Disposables.create()
        }
        
    }
    
    static func anonymousAuthentication() -> Single<String>{
        return anonymousUserInstantiation().flatMap({ uid in
            return createDocumentInUsersNode(uid)
        })
        
    }
    
    static func logOutUserOnFreshInstall(){
        let userDefaults = UserDefaults.standard
        if userDefaults.value(forKey: "appFirstTimeOpend") == nil {
            //if app is first time opened then it will be nil
            userDefaults.set(true, forKey: "appFirstTimeOpend")
            // signOut from FIRAuth
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
        }
    }
}
