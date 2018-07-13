//
//  RoomsVC.swift
//  bookBridgeIOS
//
//  Created by Aqeel on 3/10/18.
//  Copyright © 2018 Aqeel. All rights reserved.
//

import UIKit

class RoomsVC: UIViewController {
    
    //Mark :- Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MArk :- Variables
    var rooms = [Room]()
    
    //Mark :- override
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rooms.removeAll()
        InitialData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Mark :- Actions
    
    //Mark :- Addroom
    @IBAction func AddRooms(_ sender: Any) {
        PubIDSegue = "addSegue"
        seguePeroform()
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
    
    
    
    //Mark :- Functions
    func InitialData(){
        collectionView.register(UINib(nibName: "RoomsCVC", bundle: nil), forCellWithReuseIdentifier: "RoomCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        ApiCall()
    }
    func ApiCall(){
        if PubRoomCount == 0 {
            collectionView.reloadData()
        }
        Manager.getAllRooms { (room) in
            if room != nil {
                self.rooms.append(room!)
            }
            PubRoomCount = self.rooms.count
            self.collectionView.reloadData()
        }
    }
    func seguePeroform() {
        performSegue(withIdentifier: PubIDSegue, sender: nil)
    }

}
