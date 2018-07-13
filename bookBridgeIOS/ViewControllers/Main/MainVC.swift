//
//  MainVC.swift
//  bookBridgeIOS
//
//  Created by Aqeel on 2/13/18.
//  Copyright © 2018 Aqeel. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import NVActivityIndicatorView

class MainVC: UIViewController ,GIDSignInUIDelegate  {
    
    
    
    //*******Outlets*****
    //Start
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    //End
    
    
    //********Variables*******
    //Start
    
    var myTimer : Timer!
    //End
    
    
    //******Override******
    //Start
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        // TODO(developer) Configure the sign-in button look/feel
        // ...
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("--memory Warning main Screen--")
    }
    //End
    
    
    //*********Actions********
    //Start
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            // ...
            return
        }
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
    }
    
    @objc func checkCreatedUser () {
        guard googleSignInErr == "" else{
            self.stopAnimating()
            AlertBox(Heading: "Error", MSG: googleSignInErr, View: self)
            googleSignInErr = ""
            myTimer.invalidate()
            return
        }
        if PubGoogleLoggedIn {
            PubGoogleLoggedIn = false
            self.stopAnimating()
            myTimer.invalidate()
            if Pub.pub.user.Admin{
                PubIDSegue = "adminSegue"
            }else {
                PubIDSegue = "loggedInSegue"
            }
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    
    
    @IBAction func signIn(_ sender: Any) {
        PubIDSegue = "signInSegue"
        seguePeroform()
    }
    @IBAction func signUp(_ sender: Any) {
        PubIDSegue = "createProfileSegue"
        seguePeroform()
    }
    @IBOutlet weak var privacyPolicy: UIButton!
    //End
    
    @IBAction func GoogleBtn(_ sender: Any) {
        Pub.pub.user = UserProfile()
        if UserDefaults.standard.bool(forKey: PubLoggedInDefaultsKey) == true  {
            startAnimating()
            GIDSignIn.sharedInstance().signIn()
            DispatchQueue.main.async {
                self.myTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.checkCreatedUser), userInfo: nil, repeats: true)
            }
            
        }
        else {
            PubIDSegue = "signUpGoogle"
            seguePeroform()
        }
    }
    
    
    //**********Functions***********
    
    func startAnimating()  {
        self.view.isUserInteractionEnabled = false
        activityIndicator.startAnimating()
    }
    func stopAnimating()  {
        self.view.isUserInteractionEnabled = true
        activityIndicator.stopAnimating()
    }
    //Start
    func seguePeroform() {
        performSegue(withIdentifier: PubIDSegue, sender: nil)
    }
    //End
}
