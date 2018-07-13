//
//  URoomDetailVC.swift
//  bookBridgeIOS
//
//  Created by Aqeel Ahmad on 4/23/18.
//  Copyright © 2018 Aqeel. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class URoomDetailVC: UIViewController {

    
    //Mark :- Outlets
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    @IBOutlet weak var priceBtn: UIButton!
    @IBOutlet weak var availableLbl: UILabel!
    @IBOutlet weak var ReserveBtn: UIButton!
    
    
    //Mark :- Variables
    var features = [RoomFeature]()

    
    //Mark : Override
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        myImage.layer.cornerRadius = 75
        myImage.layer.masksToBounds = true
        if Pub.pub.currentRoom.Image != "nil" {
            myImage.pin_updateWithProgress = true
            myImage.pin_setImage(from: URL(string: Pub.pub.currentRoom.Image)!)
        }
        priceBtn.setTitle("Rs : \(String(describing: Pub.pub.currentRoom.Price))", for: .normal)
        RoomAvailable()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.delegate = self
        myTableView.dataSource = self
        GetFeatures()
        // Do any additional setup after loading the view.
    }

    

    @IBAction func BackBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func Reservation(_ sender: Any) {
        Pub.pub.currentRoom.Available = false
        Pub.pub.currentRoom.userID = Pub.pub.user.EmailID
        updateRoom(Pub.pub.currentRoom.UUID)
    }
   
    
    //Mark :- Function
    //Mark :- Update Room
    func updateRoom(_ uid : String ){
        Manager.updatRoom(uid, Pub.pub.currentRoom.toDict()) { (error) in
            self.stopAnimating()
            guard error == nil else {
                Pub.pub.currentRoom.Available = true
                Pub.pub.currentRoom.userID = "nil"
                AlertBox(Heading: "Error", MSG: (error?.description)!, View: self)
                return
            }
            AlertBox(Heading: "Notice", MSG: "Data Has Been Updated", View: self)
            self.RoomAvailable()
        }
    }
    func GetFeatures()  {
        Manager.getFeatures(Pub.pub.currentRoom.UUID, completionHandler: { (feat) in
            if feat != nil {
                self.features.append(feat!)
            }
            self.myTableView.reloadData()
        })
    }
    func RoomAvailable(){
        if Pub.pub.currentRoom.Available == false {
            availableLbl.text = "This Room is Not Available"
            ReserveBtn.isUserInteractionEnabled = false
            ReserveBtn.backgroundColor = UIColor.lightGray
        }else {
            availableLbl.text = "This Room is Available"
            ReserveBtn.isUserInteractionEnabled = true
            ReserveBtn.backgroundColor = UIColor.darkGray
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
