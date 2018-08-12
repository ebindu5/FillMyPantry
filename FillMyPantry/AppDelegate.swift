//
//  AppDelegate.swift
//  FillMyPantry
//
//  Created by BINDU ELAKURTHI on 6/27/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func setRootViewController(_ identifier : String){
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: identifier)
        
        let navigationController = UINavigationController(rootViewController: initialViewController)
        navigationController.navigationBar.isTranslucent = false
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        Constants.UID = UserDefaults.standard.object(forKey: "uid") as? String
        debugPrint(Constants.dbRef, Constants.UID)
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        FirebaseAuthDAO.logOutUserOnFreshInstall()
        Constants.dbRef = Firestore.firestore()
        FirebaseDAO.db = Constants.dbRef
        let settings = Constants.dbRef.settings
        settings.areTimestampsInSnapshotsEnabled = true
        settings.isPersistenceEnabled = true
        Constants.dbRef.settings = settings
        return true
    }
    
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        if let currentUser = Auth.auth().currentUser {
            Constants.UID = currentUser.uid
            UserDefaults.standard.set(currentUser.uid, forKey: "uid")
            UserDefaults.standard.synchronize()
            setRootViewController("HomeViewController")
        } else {
            
            FirebaseAuthDAO.anonymousAuthentication().subscribe{ event in
                switch event {
                case .success(let uid) : Constants.UID = uid
                UserDefaults.standard.set(uid, forKey: "uid")
                UserDefaults.standard.synchronize()
                self.setRootViewController("HomeViewController")
                case .error(let error): self.setRootViewController("NoNetworkViewController")
                }
            }
        }
        
    }
    

    
    
}

