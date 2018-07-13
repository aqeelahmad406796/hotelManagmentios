
//
//  CreateProfileVC.swift
//  bookBridgeIOS
//
//  Created by Aqeel on 2/15/18.
//  Copyright © 2018 Aqeel. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView
import GoogleSignIn

class GoogleSignUpVC: UIViewController  , GIDSignInUIDelegate{
    
    //********Outlets******
    //Start
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    //End
    
    
    
    //*********Variables*****
    //Start
    var imgURL = "nil"
    var isImageUp = false
    var myTimer : Timer!
    //End
    
    
    //*********Override*******
    //Start
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImg.layer.masksToBounds = true
        profileImg.layer.cornerRadius = profileImg.frame.height/2
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("--memory Warning createProfile Screen--")
    }
    //End
    
    
    //********Actions*****
    //Start
    @IBAction func doneBtn(_ sender: Any) {
        
        if !(isTFEmpity()){
            startAnimating()
            Pub.pub.user = UserProfile()
            Pub.pub.user.Admin = false
            Pub.pub.user.City = cityTF.text!
            Pub.pub.user.FirstName = firstNameTF.text!
            Pub.pub.user.Image = "nil"
            Pub.pub.user.LastName = lastNameTF.text!
            Pub.pub.user.Rating = 0
            GIDSignIn.sharedInstance().signIn()
            DispatchQueue.main.async {
                self.myTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.checkCreatedUser), userInfo: nil, repeats: true)
            }
        }
    }
    @IBAction func imgBtn(_ sender: Any) {
        handleSelectedImage()
    }
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    //End
    
    
    
    //*******Functions******
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
            stopAnimating()
            AlertBox(Heading: "Error", MSG: googleSignInErr, View: self)
            googleSignInErr = ""
            myTimer.invalidate()
            return
        }
        if PubGoogleLoggedIn {
            PubGoogleLoggedIn = false
            stopAnimating()
            myTimer.invalidate()
            if Pub.pub.user.Admin{
                PubIDSegue = "adminSegue"
            }else {
                PubIDSegue = "loggedInSegue"
            }
            defaultValues(true)
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }
    func defaultValues(_ loggedIn : Bool){
        UserDefaults.standard.set(loggedIn , forKey: PubLoggedInDefaultsKey)
        
    }
    
    
    func startAnimating()  {
        self.view.isUserInteractionEnabled = false
        activityIndicator.startAnimating()
    }
    func stopAnimating()  {
        self.view.isUserInteractionEnabled = true
        activityIndicator.stopAnimating()
    }
    func isTFEmpity() -> Bool {
        return (firstNameTF.text == "" || lastNameTF.text == ""  || cityTF.text == "")
    }
    //End
}


