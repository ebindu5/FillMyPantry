//
//  AppDelegate.swift
//  FillMyPantry
//
//  Created by NISHANTH NAGELLA on 6/27/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func setRootViewController(){
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
        
        let navigationController = UINavigationController(rootViewController: initialViewController)
        navigationController.navigationBar.isTranslucent = false
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        Constants.UID = UserDefaults.standard.object(forKey: "uid") as? String
        print(Constants.dbRef, Constants.UID)
    }
    
    func setNetworkViewController(){
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "NoNetworkViewController")
        
        let navigationController = UINavigationController(rootViewController: initialViewController)
        navigationController.navigationBar.isTranslucent = false
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        Constants.UID = UserDefaults.standard.object(forKey: "uid") as? String
        print(Constants.dbRef, Constants.UID)
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        print("enterd launch options")
        FirebaseApp.configure()
        FirebaseAuthDAO.logOutUserOnFreshInstall()
        Constants.dbRef = Firestore.firestore()
        FirebaseDAO.db = Constants.dbRef
        let settings = Constants.dbRef.settings
        settings.areTimestampsInSnapshotsEnabled = true
        settings.isPersistenceEnabled = true
        Constants.dbRef.settings = settings
        
        print(Constants.dbRef, Constants.UID,"::::")
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        print("enterd foreground")
//        if Constants.UID != nil {
//             self.setRootViewController()
//        }else{
//            self.setNetworkViewController()
//        }
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
           print("enterd active")
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        if let currentUser = Auth.auth().currentUser {
            Constants.UID = currentUser.uid
            UserDefaults.standard.set(currentUser.uid, forKey: "uid")
            UserDefaults.standard.synchronize()
            setRootViewController()
        } else {
            
            FirebaseAuthDAO.anonymousAuthentication().subscribe{ event in
                switch event {
                case .success(let uid) : Constants.UID = uid
                UserDefaults.standard.set(uid, forKey: "uid")
                UserDefaults.standard.synchronize()
                self.setRootViewController()
                case .error(let error): self.setNetworkViewController()
                }
            }
        }
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

