//
//  RoomDetaiVC.swift
//  bookBridgeIOS
//
//  Created by Aqeel on 3/10/18.
//  Copyright © 2018 Aqeel. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class RoomDetaiVC: UIViewController {
    
    //Mark :- Outlets
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    @IBOutlet weak var priceBtn: UIButton!
    @IBOutlet weak var availableLbl: UILabel!
    @IBOutlet weak var switchAvail: UISwitch!
    @IBOutlet weak var reserveBy: UILabel!
    
    //Mark :- Variables
    var currentAction = 0
    var deleteRoom = false
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
        if Pub.pub.currentRoom.Available == false {
            availableLbl.text = "Not Available"
            switchAvail.setOn(false, animated: false)
        }
        reservation()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.delegate = self
        myTableView.dataSource = self
        GetFeatures()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Mark :- Actions
    @IBAction func ImageBtn(_ sender: Any) {
        if Pub.pub.currentRoom.Image == "nil" {
            actionSheet(true)
        }else {
            actionSheet(false)
        }
    }
    @IBAction func delet(_ sender: Any) {
        deleteRoom = true
        startAnimating()
        if Pub.pub.currentRoom.Image != "nil"{
            deleteImage()
        }else {
            delRoom()
        }
    }
    @IBAction func AddNewFeature(_ sender: Any) {
        AlertInputNew()
    }
    @IBAction func BackBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func RoomPrice(_ sender: Any) {
        AlertInput()
    }
    @IBAction func availableSwitch(_ sender: Any) {
        if (sender as AnyObject).isOn {
            Pub.pub.currentRoom.Available = true
            availableLbl.text = "Available"
            Pub.pub.currentRoom.userID = "nil"
        }else {
            Pub.pub.currentRoom.Available = false
            availableLbl.text = "Not Available"
        }
        startAnimating()
        updateRoom(Pub.pub.currentRoom.UUID)
    }
    //Mark :- ActionSheet
    func reservation(){
        if Pub.pub.currentRoom.userID == "nil"{
            if Pub.pub.currentRoom.Available == true {
                reserveBy.text = "None"
            }else {
                reserveBy.text = "You"
            }
        }else {
            reserveBy.text = Pub.pub.currentRoom.userID
        }
    }
    func actionSheet(_ type : Bool)  {
        let alert = UIAlertController(title: "File Management", message: "You Can Update Room Image", preferredStyle: .actionSheet)
        if type {
            alert.addAction(UIAlertAction(title: "Upload", style: .default , handler:{ (UIAlertAction)in
                self.currentAction = 0
                self.AlertBoxAction(Heading: "Notice", MSG: "Are you sure that you want to upload image ?")
            }))
        }else {
            alert.addAction(UIAlertAction(title: "Update", style: .default , handler:{ (UIAlertAction)in
                self.currentAction = 1
                self.AlertBoxAction(Heading: "Notice", MSG: "Are you sure that you want to update the image ?")
            }))
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive , handler:{ (UIAlertAction)in
                self.currentAction = 2
                self.AlertBoxAction(Heading: "Notice", MSG: "Are you sure that you want to delete the image ?")
            }))
        }
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        alert.popoverPresentationController?.sourceView = self.view
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    func AlertInputfeature (_ ind : Int){
        let alert = UIAlertController(title: "Feature", message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField(configurationHandler: { (textField) in
            textField.text = self.features[ind].Feature
        })
        
        alert.addAction(UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: { [weak alert] (_) in
            if (alert?.textFields![0].text != "") {
                self.features[ind].Feature = (alert?.textFields![0].text)!
                Manager.UpdateAFeature(Pub.pub.currentRoom.UUID, self.features[ind].FUID, feature: self.features[ind].Feature, completionHandler: { (err) in
                    if err == nil {
                        self.myTableView.reloadData()
                    }else{
                        AlertBox(Heading: "Error", MSG: (err?.description)!, View: self)
                    }
                })
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    //text Field Alert
    func AlertInputNew (){
        let alert = UIAlertController(title: "Feature", message: "Add New Feature", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Enter Feature Here"
        })
        
        alert.addAction(UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: { [weak alert] (_) in
            if (alert?.textFields![0].text != "") {
                Manager.UploadFeatures(Pub.pub.currentRoom.UUID, (alert?.textFields![0].text)!, completionHandler: { (err) in
                    if err == nil {
                        AlertBox(Heading: "Success", MSG: "Feature update Successfully", View: self)
                    }else {
                        AlertBox(Heading: "Error", MSG: (err?.description)!, View: self)
                    }
                })
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    //Mark :- Alert Input
    func AlertInput (){
        let alert = UIAlertController(title: "Change Price", message: "Old Price is \(Pub.pub.currentRoom.Price)", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Add New Price"
            textField.keyboardType = .numberPad
        })
        
        
        alert.addAction(UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: { [weak alert] (_) in
            Pub.pub.currentRoom.Price = Int((alert?.textFields![0].text)!)!
            self.priceBtn.setTitle("Rs : \(String(describing : Pub.pub.currentRoom.Price))", for: .normal)
            self.startAnimating()
            self.updateRoom(Pub.pub.currentRoom.UUID)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //Mark :- upload image
    func uploadImage(_ uid: String ){
        if let profileImg = myImage.image, let uploadData = UIImageJPEGRepresentation(profileImg, 0.1){
            Manager.uploadImage(PubRoomFolder,uploadData,completionHandler: { (url , error) in
                guard let URL = url else {
                    self.stopAnimating()
                    AlertBox(Heading: "Error", MSG: (error?.description)!, View: self)
                    return
                }
                Pub.pub.currentRoom.Image = URL
                self.updateRoom(uid)
            })
        }
    }
    //Mark :- Update Room
    func updateRoom(_ uid : String ){
        Manager.updatRoom(uid, Pub.pub.currentRoom.toDict()) { (error) in
            self.stopAnimating()
            guard error == nil else {
                AlertBox(Heading: "Error", MSG: (error?.description)!, View: self)
                return
            }
            self.reservation()
            AlertBox(Heading: "Notice", MSG: "Data Has Been Updated", View: self)
            if Pub.pub.currentRoom.Image == "nil" {
                //self.myImage.image = #imageLiteral(resourceName: "NoResultsIcon")
            }
        }
    }
    
    //Mark :- Action
    public func AlertBoxAction(Heading : String , MSG : String ) {
        let alert = UIAlertController(title: Heading, message: MSG, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (_) in
            if self.currentAction == 0{
                self.handleSelectedImage()
            }else if self.currentAction == 1 {
                self.handleSelectedImage()
            }
            else if self.currentAction == 2 {
                self.startAnimating()
                self.deleteImage()
            }
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
        alert.view.layer.cornerRadius = 15
        self.present(alert, animated: true, completion: nil)
    }
    func deleteImage(){
        let url = URL(string: Pub.pub.currentRoom.Image)
        Manager.deleteImage(PubRoomFolder, (url?.lastPathComponent)!) { (error) in
            guard error == nil else {
                self.stopAnimating()
                AlertBox(Heading: "Error", MSG: (error?.description)!, View: self )
                return
            }
            Pub.pub.currentRoom.Image = "nil"
            guard self.deleteRoom == false else{
                self.delRoom()
                return
            }
            if self.currentAction == 1 {
                self.uploadImage(Pub.pub.currentRoom.UUID)
            }else{
                self.updateRoom(Pub.pub.currentRoom.UUID)
            }
        }
    }
    
    func delRoom(){
        Manager.deleteRoom(Pub.pub.currentRoom.UUID) { (err) in
            guard err == nil else {
                self.stopAnimating()
                AlertBox(Heading: "Error", MSG: (err?.description)!, View: self)
                return
            }
            self.deleteFeatures()
        }
    }
    
    func deleteFeatures(){
        Manager.DeleteFeatures(Pub.pub.currentRoom.UUID) { (err) in
            self.stopAnimating()
            guard err == nil else {
                AlertBox(Heading: "Error", MSG: (err?.description)!, View: self)
                return
            }
            self.dismiss(animated: true, completion: nil)
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
