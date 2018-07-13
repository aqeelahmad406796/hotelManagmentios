//
//  UEditProfileVC.swift
//  bookBridgeIOS
//
//  Created by Aqeel Ahmad on 4/27/18.
//  Copyright © 2018 Aqeel. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class UEditProfileVC: UIViewController {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    
    
    //Mark :- Variables
    var tableVeiwTitle = [ "Email ID" , "Password" , "First Name" , "Last Name" , "City"]
    var currentAction = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        InitaialData()      // set data in the textfield
        // Do any additional setup after loading the view.
    }
    
    
   
    
    @IBAction func Logout(_ sender: Any) {
        Manager.signout { (signOut) in
            if signOut == "done" {
                print("******signed out")
            }else {
                print("*****already signed out")
            }
            PubIDSegue = "mainSegue"
            Pub.pub.allReviews.removeAll()
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    
    @IBAction func upImage(_ sender: Any) {
        if Pub.pub.user.Image == "nil"{
            currentAction = 0
        }else {
            currentAction = 1
        }
        handleSelectedImage()
    }
    
    
    
    
    func uploadImage(){
        if let profileImg = myImage.image, let uploadData = UIImageJPEGRepresentation(profileImg, 0.1){
            Manager.uploadImage("ProfileImages",uploadData,completionHandler: { (url , error) in
                self.stopAnimating()
                guard let URL = url else {
                    AlertBox(Heading: "Error", MSG: (error?.description)!, View: self)
                    return
                }
                Pub.pub.user.Image = URL
                self.updateProfile(0, "0")
            })
        }
    }
    func deleteImage(){
        let url = URL(string: Pub.pub.user.Image)
        Manager.deleteImage("ProfileImages", (url?.lastPathComponent)!) { (error) in
            guard error == nil else {
                self.stopAnimating()
                AlertBox(Heading: "Error", MSG: (error?.description)!, View: self )
                return
            }
            Pub.pub.currentRoom.Image = "nil"
            self.uploadImage()
        }
    }
    
    //text Field Alert
    func AlertInput (_ ind : Int){
        let alert = UIAlertController(title: "Update", message: "Update Your \(tableVeiwTitle[ind])", preferredStyle: UIAlertControllerStyle.alert)
        if tableVeiwTitle[ind].lowercased() != "password"{
            alert.addTextField(configurationHandler: { (textField) in
                textField.placeholder = self.tableVeiwTitle[ind]
            })
        }else {
            alert.addTextField(configurationHandler: { (textField) in
                textField.placeholder = "Old Password"
                textField.isSecureTextEntry = true
            })
            alert.addTextField(configurationHandler: { (textField) in
                textField.placeholder = "new Password"
                textField.isSecureTextEntry = true
            })
            alert.addTextField(configurationHandler: { (textField) in
                textField.placeholder = "Confirm Password"
                textField.isSecureTextEntry = true
            })
        }
        
        alert.addAction(UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: { [weak alert] (_) in
            if self.tableVeiwTitle[ind].lowercased() != "password" {
                if ((alert?.textFields![0].text) != nil ) {
                    self.updateProfile(ind , (alert?.textFields![0].text)!)
                }else {
                    AlertBox(Heading: "Alert", MSG: "Your Text Field is Empity", View: self)
                }
            }else {
                if ((alert?.textFields![0].text) != "" && (alert?.textFields![1].text) != "" && (alert?.textFields![2].text) != "") {
                    self.changePass((alert?.textFields![0].text)!,(alert?.textFields![1].text)!)
                }else {
                    AlertBox(Heading: "Alert", MSG: "Your Text Field is empity", View: self)
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func updateProfile( _ ind : Int , _ value : String){
        startAnimating()
        var values : [String:Any] = ["FirstName": Pub.pub.user.FirstName,
                                     "LastName": Pub.pub.user.LastName,
                                     "EmailID": Pub.pub.user.EmailID,
                                     "UUID" : Pub.pub.user.UUID,
                                     "Image" : Pub.pub.user.Image,
                                     "Rating" : Pub.pub.user.Rating,
                                     "City" : Pub.pub.user.City,
                                     "Admin" : false]
        if ind == 2 {
            values = ["FirstName": value,
                                         "LastName": Pub.pub.user.LastName,
                                         "EmailID": Pub.pub.user.EmailID,
                                         "UUID" : Pub.pub.user.UUID,
                                         "Image" : Pub.pub.user.Image,
                                         "Rating" : Pub.pub.user.Rating,
                                         "City" : Pub.pub.user.City,
                                         "Admin" : false]
        }else if ind == 3{
            values = ["FirstName": Pub.pub.user.FirstName,
                      "LastName": value,
                      "EmailID": Pub.pub.user.EmailID,
                      "UUID" : Pub.pub.user.UUID,
                      "Image" : Pub.pub.user.Image,
                      "Rating" : Pub.pub.user.Rating,
                      "City" : Pub.pub.user.City,
                      "Admin" : false]
        }else if ind == 4 {
            values = ["FirstName": Pub.pub.user.FirstName,
                      "LastName": Pub.pub.user.LastName,
                      "EmailID": Pub.pub.user.EmailID,
                      "UUID" : Pub.pub.user.UUID,
                      "Image" : Pub.pub.user.Image,
                      "Rating" : Pub.pub.user.Rating,
                      "City" : value,
                      "Admin" : false]
        }
        Manager.createUserRemaining(Pub.pub.user.UUID, values) { (err) in
            self.stopAnimating()
            guard err == nil else {
                AlertBox(Heading: "Error", MSG: (err?.description)!, View: self)
                return
            }
            if ind == 2 {
                Pub.pub.user.FirstName = value
            }else if ind == 3{
                Pub.pub.user.LastName = value
            }else if ind == 4 {
                Pub.pub.user.City = value
            }
            AlertBox(Heading: "Notice", MSG: "Data has been updated successfully", View: self)
            self.tableView.reloadData()
        }
    }
    func changePass( _ oldPass : String , _ newPass : String ) {
        startAnimating()
        Manager.changePassword(Pub.pub.user.EmailID, oldPass, newPass) { (err) in
            self.stopAnimating()
            guard err == nil else{
                AlertBox(Heading: "Error", MSG: (err?.description)!, View: self)
                return
            }
            AlertBox(Heading: "Notice", MSG: "Your Pass has been updated", View: self)
        }
    }
    
    
    //inital data on viewdidload
    func InitaialData(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 5
        myImage.layer.cornerRadius = 75
        myImage.layer.masksToBounds = true
        if Pub.pub.user.Image != "nil" {
            myImage.pin_updateWithProgress = true
            myImage.pin_setImage(from: URL(string: Pub.pub.user.Image)!)
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
    
  
}


