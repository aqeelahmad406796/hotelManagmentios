//
//  AllUsersVC.swift
//  bookBridgeIOS
//
//  Created by Aqeel Ahmad on 4/28/18.
//  Copyright © 2018 Aqeel. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class AllUsersVC: UIViewController {

    // Mark :- Outlets
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    
    
    
    //Markd :- Override
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.delegate = self
        myTableView.dataSource = self
        GetAllUsers()
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        myTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Mark :- Buttons
    @IBAction func Logout(_ sender: Any) {
        Manager.signout { (signOut) in
            if signOut == "done" {
                print("******signed out")
            }else {
                print("*****already signed out")
            }
            PubIDSegue = "mainSegue"
            Pub.pub.allReviews.removeAll()
            Pub.pub.allUsers.removeAll()
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        }
        
    }
    func GetAllUsers(){
        Manager.getAllUsers { (user, er) in
            guard user != nil else {
                return
            }
            guard user?.Admin == false else {
                return
            }
            Pub.pub.allUsers.append(user!)
            self.myTableView.reloadData()
        }
    }
    
    //Mark :- Functions
    func Delete( _ uid : String , _ ind : Int ){
        if Pub.pub.allUsers[ind].Image != "nil" {
            let url = URL(string: Pub.pub.allUsers[ind].Image)
            Manager.deleteImage("ProfileImages", (url?.lastPathComponent)!) { (err) in
                guard err == nil else {
                    self.stopAnimating()
                    AlertBox(Heading: "Error", MSG: (err?.description)!, View: self)
                    return
                }
                self.DeleteUser(uid, ind)
            }
        }else {
            DeleteUser(uid, ind)
        }
    }
    func DeleteUser( _ uid : String , _ ind : Int) {
        Manager.deleteUser(uid) { (err) in
            self.stopAnimating()
            guard err == nil else {
                AlertBox(Heading: "Error", MSG: (err?.description)!, View: self)
                return
            }
            Pub.pub.allUsers.remove(at: ind)
            self.myTableView.reloadData()
            self.deleteComments(uid , 0 )
        }
    }
    func deleteComments( _ uid : String , _ ind : Int ){
        if ind < Pub.pub.allReviews.count{
            if Pub.pub.allReviews[ind].UUID == uid {
                Manager.deleteComment(Pub.pub.allReviews[ind].CUID) { (err) in
                    guard err == nil else {
                        AlertBox(Heading: "Error", MSG: (err?.description)!, View: self)
                        return
                    }
                    Pub.pub.allReviews.remove(at: ind)
                    self.deleteComments(uid, ind+1)
                }
            }else {
                deleteComments(uid, ind+1)
            }
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
