//
//  UHotelVC.swift
//  bookBridgeIOS
//
//  Created by Aqeel Ahmad on 4/27/18.
//  Copyright © 2018 Aqeel. All rights reserved.
//


import UIKit
import NVActivityIndicatorView

class AHotelVC: UIViewController {
    
    
    //Mark :- Outlets
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    @IBOutlet weak var CommentTF: UITextField!
    @IBOutlet weak var ratingLbl: UILabel!
    
    
    //Mark :- Variables

    
    
    //Mark : Override
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ratingLbl.text = "Hotel Rating is : \(findRating())"
        myTableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        getReviews()
        // Do any additional setup after loading the view.
    }
    
   
    @IBAction func PostBtn(_ sender: Any) {
        if CommentTF.text != "" {
            postComment()
        }
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
            Pub.pub.allUsers.removeAll()
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        }
        
    }
    
    
    //Mark :- Function
    func findRating() -> String {
        var sum = 0
        for i in Pub.pub.allUsers {
            sum = i.Rating + sum
        }
        if Pub.pub.allUsers.count != 0{
            return String(describing: sum / Pub.pub.allUsers.count)
        }
        return "3"
    }
    func postComment(){
        self.view.endEditing(true)
        startAnimating()
        self.view.endEditing(true)
        let ReviewUID = NSUUID().uuidString
        let value = ["CUID" : ReviewUID,
                     "UUID" : Pub.pub.user.UUID,
                     "EmailID" : Pub.pub.user.EmailID,
                     "Image" : Pub.pub.user.Image,
                     "Comment" : CommentTF.text!] as [String : Any]
        CommentTF.text = ""
        Manager.postReviews(uid: ReviewUID, value) { (err) in
            self.stopAnimating()
            guard err == nil else {
                AlertBox(Heading: "Error", MSG: (err?.description)!, View: self)
                return
            }
            
        }
    }
    func getReviews(){
        myTableView.delegate = self
        myTableView.dataSource = self
        Manager.getReviews { (review) in
            guard review != nil else{
                return
            }
            Pub.pub.allReviews.append(review!)
            self.myTableView.reloadData()
        }
    }
    
    func seguePeroform() {
        performSegue(withIdentifier: PubIDSegue, sender: nil)
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
