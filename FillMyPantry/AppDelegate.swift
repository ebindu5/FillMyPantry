//
//  AppDelegate.swift
//  Fill My Pantry
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

        Constants.dbRef = Firestore.firestore()
        let settings = Constants.dbRef.settings
        settings.areTimestampsInSnapshotsEnabled = true
        Constants.dbRef.settings = settings
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
    
        FirebaseApp.configure()
        FirebaseAuthDAO.logOutUserOnFreshInstall()
        
        if let currentUser = Auth.auth().currentUser {
            Constants.UID = currentUser.uid
            setRootViewController()
        } else {
           
            FirebaseAuthDAO.anonymousUserInstantiation().subscribe { event in
                switch event {
                case .success(let uid) : Constants.UID = uid

                self.setRootViewController()
                case .error(let error): print(error)
                }
                }
            
        }

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
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

