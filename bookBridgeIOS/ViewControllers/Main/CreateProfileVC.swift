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

class CreateProfileVC: UIViewController {
    
    //********Outlets******
    //Start
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var emailAddressTF: UITextField!
    @IBOutlet weak var passTF: UITextField!
    @IBOutlet weak var confirmPassTF: UITextField!
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
//        defaultValues(true)
        apiCall()
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
    func defaultValues(_ loggedIn : Bool){
        UserDefaults.standard.set(loggedIn , forKey: PubLoggedInDefaultsKey)
        if loggedIn {
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }
    func apiCall(){
        guard isPassMatches() else {
            AlertBox(Heading: "Error", MSG: "Your Password and Confirm Password Does Not Matche", View: self)
            return
        }
        guard !isTFEmpity() else {
            AlertBox(Heading: "Error", MSG: "Your TextField is Empity", View: self)
            return
        }
        startAnimating()
        Manager.createUser(emailAddressTF.text!, passTF.text!) { (user, error) in
            guard error == nil else {
                self.stopAnimating()
                AlertBox(Heading: "Error", MSG: (error?.description)!, View: self)
                return
            }
            if self.isImageUp{
                self.uploadImage((user?.uid)!)
            }else{
                self.updateRemaining((user?.uid)!)
            }
        }
    }
    func updateRemaining(_ uid : String){
        let values : [String:Any] = ["FirstName": firstNameTF.text!,
                                     "LastName": lastNameTF.text!,
                                     "EmailID": emailAddressTF.text!,
                                     "UUID" : uid,
                                     "Image" : imgURL,
                                     "Rating" : 0,
                                     "City" : cityTF.text!,
                                     "Admin" : false]
        Pub.pub.user = UserProfile(data: values)
        Manager.createUserRemaining(Pub.pub.user.UUID , values) { (error) in
            self.stopAnimating()
            guard error == nil else {
                AlertBox(Heading: "Error", MSG: (error?.description)!, View: self)
                return
            }
            self.AlertBoxAction(Heading: "Notice", MSG: "Do you want to verify your email ID")
        }
    }
    public func AlertBoxAction(Heading : String , MSG : String ) {
        let alert = UIAlertController(title: Heading, message: MSG, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (_) in
            var user = Auth.auth().currentUser;
            self.startAnimating()
            user?.sendEmailVerification(completion: { (err) in
                guard err == nil else {
                    AlertBox(Heading: "Error", MSG: (err?.localizedDescription)!, View: self)
                    return
                }
                DispatchQueue.main.async {
                    self.myTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.verificationOfEmail), userInfo: nil, repeats: true)
                }
            })
           
        }))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action) in
            if Pub.pub.user.Admin{
                PubIDSegue = "adminSegue"
            }else {
                PubIDSegue = "loggedInSegue"
            }
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        }))
        alert.view.layer.cornerRadius = 15
        self.present(alert, animated: true, completion: nil)
    }
    @objc func verificationOfEmail(){
        Manager.LogIn(emailAddressTF.text!, passTF.text!) { (user, error) in
            if (user?.isEmailVerified)! {
                self.myTimer.invalidate()
                self.stopAnimating()
                if Pub.pub.user.Admin{
                    PubIDSegue = "adminSegue"
                }else {
                    PubIDSegue = "loggedInSegue"
                }
                self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
            }
        }
       
        
    }
    func uploadImage(_ uid: String ){
        if let profileImg = profileImg.image, let uploadData = UIImageJPEGRepresentation(profileImg, 0.1){
            Manager.uploadImage("ProfileImages",uploadData,completionHandler: { (url , error) in
                guard let URL = url else {
                    self.stopAnimating()
                    AlertBox(Heading: "Error", MSG: (error?.description)!, View: self)
                    return
                }
                self.imgURL = URL
                self.updateRemaining(uid)
            })
        }
    }
    func startAnimating()  {
        self.view.isUserInteractionEnabled = false
        activityIndicator.startAnimating()
    }
    func stopAnimating()  {
        self.view.isUserInteractionEnabled = true
        activityIndicator.stopAnimating()
    }
    func isPassMatches() -> Bool {
        return passTF.text! == confirmPassTF.text!
    }
    func isTFEmpity() -> Bool {
        return (firstNameTF.text == "" || lastNameTF.text == "" || emailAddressTF.text == "" || passTF.text == "" || confirmPassTF.text == "" || cityTF.text == "")
    }
    //End
}

