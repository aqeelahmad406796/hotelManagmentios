//
//  SignInVC.swift
//  bookBridgeIOS
//
//  Created by Aqeel on 2/13/18.
//  Copyright © 2018 Aqeel. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Firebase

class SignInVC: UIViewController {
    
    //******IBOutlet*******
    //Start
    @IBOutlet weak var ActivityIndicator: NVActivityIndicatorView!
    @IBOutlet weak var EmailTF: UITextField!
    @IBOutlet weak var PassTF: UITextField!
    //End
    
    //******Variables******
    //Start
    //End
    
    
    
    
    //**********override functions**********
    //Start
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("--memory Warning signIn Screen--")
    }
    //End
    
    
    
    //*****Actions********
    //Start
    @IBAction func signIn(_ sender: Any) {
//        defaultValues(true)
        self.view.endEditing(true)
        apiCall()
    }
    @IBAction func forgotPass(_ sender: Any) {
        Auth.auth().sendPasswordReset(withEmail: EmailTF.text!) { (err) in
            guard err == nil else {
                AlertBox(Heading: "Error", MSG: (err?.localizedDescription)!, View: self)
                return
            }
            AlertBox(Heading: "Alert", MSG: "Open you email id and reset your password ", View: self)
        }
    }
    @IBAction func backBtn(_ sender: Any) {
        goBack()
    }
    //End
    
    
    
    //*****Functions*******
    //Start
    func apiCall(){
        startAnimating()
        Manager.LogIn(EmailTF.text!, PassTF.text!) { (userProfile, error) in
            guard error == nil else {
                AlertBox(Heading: "Error", MSG: (error?.description)!, View: self)
                self.stopAnimating()
                return
            }
            self.getUser((userProfile?.uid)!)
        }
    }
    func getUser( _ uid : String){
        Manager.GetCurrentUserData(uid, completionHandler: { (userProf, error) in
            self.stopAnimating()
            guard error == nil else {
                AlertBox(Heading: "Error", MSG: (error?.description)!, View: self)
                return
            }
            Pub.pub.user = userProf!
            if Pub.pub.user.Admin{
                PubIDSegue = "adminSegue"
            }else {
                PubIDSegue = "loggedInSegue"
            }
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        })
    }
    func defaultValues(_ loggedIn : Bool){
        UserDefaults.standard.set(loggedIn , forKey: PubLoggedInDefaultsKey)
        if loggedIn {
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }
    func goBack()  {
        view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    func seguePerform(){
        performSegue(withIdentifier: PubIDSegue, sender: nil)
    }
    func startAnimating()  {
        self.view.isUserInteractionEnabled = false
        ActivityIndicator.startAnimating()
    }
    func stopAnimating()  {
        self.view.isUserInteractionEnabled = true
        ActivityIndicator.stopAnimating()
    }
    //End
}
