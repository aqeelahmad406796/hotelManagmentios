//
//  UserExtension.swift
//  bookBridgeIOS
//
//  Created by Aqeel Ahmad on 4/23/18.
//  Copyright © 2018 Aqeel. All rights reserved.
//

import Foundation
import Firebase
import UIKit
import PINRemoteImage


extension UEditProfileVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func handleSelectedImage()
    {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImage : UIImage?
        
        if let orignalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage
        {
            selectedImage = orignalImage
        }
        if let EditedImage = info["UIImagePickerControllerEditedImage"] as? UIImage
        {
            selectedImage = EditedImage
        }
        if let selectedImage = selectedImage
        {
            myImage.image = selectedImage
            startAnimating()
            if currentAction == 1 {
                deleteImage()
            }else{
                uploadImage()
            }
        }
        dismiss(animated: true) {
            self.startAnimating()
        }
    }
    
}



extension UEditProfileVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableVeiwTitle.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath)
        cell.textLabel?.text = tableVeiwTitle[indexPath.row]
        if indexPath.row == 0{
            cell.detailTextLabel?.text = Pub.pub.user.EmailID
        }else if indexPath.row == 1 {
            cell.detailTextLabel?.text = ""
        }else if indexPath.row == 2{
            cell.detailTextLabel?.text = Pub.pub.user.FirstName
        }
        else if indexPath.row == 3{
            cell.detailTextLabel?.text = Pub.pub.user.LastName
        }else {
            cell.detailTextLabel?.text = Pub.pub.user.City
        }
        if indexPath.row != 0 {
            cell.accessoryType = .disclosureIndicator
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row != 0 {
            AlertInput(indexPath.row)
        }
    }
}



extension URoomDetailVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "featureCell", for: indexPath)
        cell.textLabel?.text = features[indexPath.row].Feature
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return features.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


extension UHotelVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UReviewsCell", for: indexPath)
        cell.textLabel?.text = allReviews[indexPath.row].EmailID
        cell.detailTextLabel?.text = allReviews[indexPath.row].Comment
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allReviews.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}




extension UserRoomsVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    //number of cells
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rooms.count
    }
    
    
    //cell Formate and assigning labels to each cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RoomCell", for: indexPath) as! RoomsCVC
        cell.PriceTF.text = "Rs \(rooms[indexPath.row].Price)"
        cell.Description.text = rooms[indexPath.row].Description
        cell.Image.layer.cornerRadius = 75
        cell.Image.layer.masksToBounds = true
        if rooms[indexPath.row].Image != "nil"{
            cell.Image.pin_updateWithProgress = true
            cell.Image.pin_setImage(from: URL(string: rooms[indexPath.row].Image)!)
        }else {
            cell.Image.image = #imageLiteral(resourceName: "NoResultsIcon")
        }
        cell.layer.cornerRadius = 4
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Pub.pub.currentRoom = rooms[indexPath.row]
        PubIDSegue = "URoomDetailSegue"
        seguePeroform()
    }
    
    
    //return size of cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        return CGSize(width: screenWidth - 20, height: screenWidth * 0.5)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
    }
}
