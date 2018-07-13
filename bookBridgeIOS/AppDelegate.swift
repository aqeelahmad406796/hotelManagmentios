//
//  AppDelegate.swift
//  bookBridgeIOS
//
//  Created by Aqeel on 2/13/18.
//  Copyright © 2018 Aqeel. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase
import GoogleSignIn


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        launchScreenFunctions()
        // Use Firebase library to configure APIs
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        return true
    }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any])
        -> Bool {
            return GIDSignIn.sharedInstance().handle(url , sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String , annotation: [:])
    }
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url , sourceApplication: sourceApplication , annotation: annotation)
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        googleSignInErr = ""
        if let error = error {
            googleSignInErr = error.localizedDescription
            // ...
            return
        }
        
        guard let authentication = user.authentication else {
            googleSignInErr = "something went wrong"
            return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                googleSignInErr = error.localizedDescription
                // ...
                return
            }
            Pub.pub.user.UUID = (user?.uid)!
            Pub.pub.user.EmailID = (user?.email)!
            let values : [String:Any] = ["FirstName": Pub.pub.user.FirstName,
                                         "LastName": Pub.pub.user.LastName,
                                         "EmailID": Pub.pub.user.EmailID,
                                         "UUID" : Pub.pub.user.UUID,
                                         "Image" : Pub.pub.user.Image,
                                         "Rating" : 0,
                                         "City" : Pub.pub.user.City,
                                         "Admin" : false]
            if (Pub.pub.user.City != "" && Pub.pub.user.City != nil) {
                UploadRemaingData(Pub.pub.user.UUID, values)
            }
            else {
                Manager.GetCurrentUserData(Pub.pub.user.UUID, completionHandler: { (userProile, err) in
                    if err == nil {
                        Pub.pub.user = userProile!
                        PubGoogleLoggedIn = true
                    }
                })
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        do{
            try Auth.auth().signOut()
        }catch{
            print("error\(error.localizedDescription)")
        }
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
    
    
    //****************************My Custom Functions********************************
    func launchScreenFunctions() {
        
        //Enabling IQkeyboardmanager
        //Start
        IQKeyboardManager.sharedManager().enable = true
        FirebaseApp.configure()
        //End
    }
    

}

