//
//  UHotelVC.swift
//  bookBridgeIOS
//
//  Created by Aqeel Ahmad on 4/27/18.
//  Copyright © 2018 Aqeel. All rights reserved.
//


import UIKit
import NVActivityIndicatorView

class UHotelVC: UIViewController {
    
    
    //Mark :- Outlets
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    @IBOutlet weak var star1: UIButton!
    @IBOutlet weak var star2: UIButton!
    @IBOutlet weak var star3: UIButton!
    @IBOutlet weak var star4: UIButton!
    @IBOutlet weak var star5: UIButton!
    @IBOutlet weak var CommentTF: UITextField!
    
    
    //Mark :- Variables
    var allReviews = [Reviews]()
    
    
    //Mark : Override
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        starColor(rate: Pub.pub.user.Rating)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        getReviews()
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
    @IBAction func star1Btn(_ sender: Any) {
        updateRemaining(rating: 1)
        star1F()
    }
    @IBAction func Star2Btn(_ sender: Any) {
        updateRemaining(rating: 2)
        Star2F()
    }
    @IBAction func Star3Btn(_ sender: Any) {
        updateRemaining(rating: 3)
        Star3F()
    }
    @IBAction func Star4Btn(_ sender: Any) {
        updateRemaining(rating: 4)
        Star4F()
    }
    @IBAction func Star5Btn(_ sender: Any) {
        updateRemaining(rating: 5)
        Star5F()
    }
    @IBAction func PostBtn(_ sender: Any) {
        if CommentTF.text != "" {
            postComment()
        }
    }
    
    
    //Mark :- Function
    func postComment(){
        self.view.endEditing(true)
        startAnimating()
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
            self.allReviews.append(review!)
            self.myTableView.reloadData()
        }
    }
    func updateRemaining(rating : Int){
        startAnimating()
        let values : [String:Any] = ["FirstName": Pub.pub.user.FirstName,
                                     "LastName": Pub.pub.user.LastName,
                                     "EmailID": Pub.pub.user.EmailID,
                                     "UUID" : Pub.pub.user.UUID,
                                     "Image" : Pub.pub.user.Image,
                                     "Rating" : rating,
                                     "City" : Pub.pub.user.City,
                                     "Admin" : false]
        Pub.pub.user = UserProfile(data: values)
        Manager.createUserRemaining(Pub.pub.user.UUID , values) { (error) in
            self.stopAnimating()
            guard error == nil else {
                AlertBox(Heading: "Error", MSG: (error?.description)!, View: self)
                return
            }
            AlertBox(Heading: "Note", MSG: "Rating is updated successfully", View: self)
        }
    }
    func star1F() {
        star1.backgroundColor = UIColor.blue
        star2.backgroundColor = UIColor.white
        star3.backgroundColor = UIColor.white
        star4.backgroundColor = UIColor.white
        star5.backgroundColor = UIColor.white
    }
    func Star2F() {
        star1.backgroundColor = UIColor.blue
        star2.backgroundColor = UIColor.blue
        star3.backgroundColor = UIColor.white
        star4.backgroundColor = UIColor.white
        star5.backgroundColor = UIColor.white
    }
    func Star3F() {
        star1.backgroundColor = UIColor.blue
        star2.backgroundColor = UIColor.blue
        star3.backgroundColor = UIColor.blue
        star4.backgroundColor = UIColor.white
        star5.backgroundColor = UIColor.white
    }
    func Star4F() {
        star1.backgroundColor = UIColor.blue
        star2.backgroundColor = UIColor.blue
        star3.backgroundColor = UIColor.blue
        star4.backgroundColor = UIColor.blue
        star5.backgroundColor = UIColor.white
    }
    func Star5F() {
        star1.backgroundColor = UIColor.blue
        star2.backgroundColor = UIColor.blue
        star3.backgroundColor = UIColor.blue
        star4.backgroundColor = UIColor.blue
        star5.backgroundColor = UIColor.blue
    }
    func starColor(rate : Int){
        if rate > 4 {
            Star5F()
        }else if rate > 3 {
            Star4F()
        }else if rate > 2 {
            Star3F()
        }else if rate > 1 {
            Star2F()
        }else if rate > 0 {
            star1F()
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
