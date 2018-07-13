//
//  AddRoomVC.swift
//  bookBridgeIOS
//
//  Created by Aqeel Ahmad on 4/23/18.
//  Copyright © 2018 Aqeel. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class AddRoomVC: UIViewController {
    
    //Mark :- Outlets
    @IBOutlet weak var roomImg: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var AddPriceTF: UITextField!
    @IBOutlet weak var AddDesTF: UITextField!
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    @IBOutlet weak var availableLbl: UILabel!
    
    
    //Mark :- Variables
    var features = [String]()
    var available = true
    var isImgUp = false
    var countOfFeatures = 0
    
    //Mark :- override
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        roomImg.layer.cornerRadius = 50
        roomImg.layer.masksToBounds = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    //Mark :- Actions
    
    @IBAction func backButton(_ sender: Any) {
         self.dismiss(animated: true, completion: nil)
    }
    @IBAction func AddImg(_ sender: Any) {
        self.handleSelectedImage()
    }
    @IBAction func AddFeatures(_ sender: Any) {
        AlertInput()
    }
    @IBAction func Save(_ sender: Any) {
        if TextFieldNotEmpity(){
            if features.count > 0 {
                startAnimating()
                if self.isImgUp{
                    self.uploadImage()
                }else{
                    self.uploadRoom("nil")
                }
            }else{
                AlertBox(Heading: "Error" , MSG: "There must be atleast one feature", View: self)
            }
        }else{
            AlertBox(Heading: "Error", MSG: "Any of your text field is empity", View: self)
        }
    }
    @IBAction func AvailableSwitch(_ sender: Any) {
        if (sender as AnyObject).isOn {
            availableLbl.text = "Available"
            available = true
        }else{
            availableLbl.text = "Not Available"
            available = false
        }
    }
    
    
    
    
    
    
    //Mark :- Functions
    //text Field Alert
    func AlertInput (){
        let alert = UIAlertController(title: "Features", message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Add Feature"
        })
        
        
    alert.addAction(UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: { [weak alert] (_) in
        self.features.append((alert?.textFields![0].text)!)
        self.tableView.reloadData()
    }))
    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
    self.present(alert, animated: true, completion: nil)
    }
    
    
    //
    func TextFieldNotEmpity() -> Bool {
        return (AddDesTF.text != "" && AddPriceTF.text != "")
    }
    //
    
    
    //Mark :- Upload Room
    func uploadRoom(_ url : String){
        let UUID = NSUUID().uuidString
        let price = Int( AddPriceTF.text! )
        let room = ["Available": available,
                    "Image": url,
                    "Price": price!,
                    "UUID" : UUID,
                    "userID" : "nil",
                    "Description" : AddDesTF.text!] as [String : Any]
        Manager.uploadRoom(UUID, room) { (err) in
            guard err == nil else {
                self.stopAnimating()
                AlertBox(Heading: "Error", MSG: (err?.description)!, View: self)
                return
            }
            self.uploadFeature(UUID)
        }
    }
    
    //Mark :- upload image
    func uploadImage(){
        if let profileImg = roomImg.image, let uploadData = UIImageJPEGRepresentation(profileImg, 0.1){
            Manager.uploadImage(PubRoomFolder,uploadData,completionHandler: {  (url , error) in
                guard let URL = url else {
                    self.stopAnimating()
                    AlertBox(Heading: "Error", MSG: (error?.description)!, View: self)
                    return
                }
                self.uploadRoom(URL)
            })
        }
    }
    
    //Mark :- UploadFeatures
    func uploadFeature( _ uid : String){
        if countOfFeatures < features.count {
            Manager.UploadFeatures(uid, features[countOfFeatures]) { (err) in
                guard err == nil else {
                    self.stopAnimating()
                    AlertBox(Heading: "Error", MSG: (err?.description)!, View: self)
                    return
                }
                self.countOfFeatures = self.countOfFeatures + 1
                self.uploadFeature(uid)
            }
        }else {
            stopAnimating()
            self.dismiss(animated: true, completion: nil)
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
