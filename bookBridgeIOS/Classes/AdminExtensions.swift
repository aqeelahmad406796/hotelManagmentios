//
//  Extensions.swift
//  bookBridgeIOS
//
//  Created by Aqeel on 3/9/18.
//  Copyright © 2018 Aqeel. All rights reserved.
//

import Foundation
import Firebase
import UIKit
import PINRemoteImage

extension CreateProfileVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
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
            isImageUp = true
            profileImg.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}


extension GoogleSignUpVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
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
            isImageUp = true
            profileImg.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}



extension RoomDetaiVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
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
                uploadImage(Pub.pub.currentRoom.UUID)
            }
        }
        dismiss(animated: true) {
            self.startAnimating()
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
extension AddRoomVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
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
            roomImg.image = selectedImage
            isImgUp = true
        }
        dismiss(animated: true) {
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}





extension AddRoomVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "featureAddRoom", for: indexPath)
        cell.textLabel?.text = features[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return features.count
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteRowAction = UITableViewRowAction(style: .default , title: "Delete", handler:{action, indexpath in
            self.features.remove(at: indexPath.row)
            tableView.reloadData()
        });
        
        return [deleteRowAction];
    }
    
}

extension RoomDetaiVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "featureCell", for: indexPath)
        cell.textLabel?.text = features[indexPath.row].Feature
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return features.count
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteRowAction = UITableViewRowAction(style: .default , title: "Delete", handler:{action, indexpath in
            if self.features.count == 1 {
                AlertBox(Heading: "Error", MSG: "There must be atleast one feature", View: self)
            }else {
                Manager.DeleteAFeature(Pub.pub.currentRoom.UUID, FUID: self.features[indexPath.row].FUID, completionHandler: { (err) in
                    if err == nil {
                        self.features.remove(at: indexPath.row)
                        tableView.reloadData()
                        AlertBox(Heading: "Success", MSG: "Features has been deleted", View: self)
                    }else {
                        AlertBox(Heading: "Error", MSG: (err?.description)!, View: self)
                    }
                })
                
            }
        });
        
        return [deleteRowAction];
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        AlertInputfeature(indexPath.row)
    }
}

extension AEditProfileVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
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

extension AEditProfileVC : UITableViewDelegate, UITableViewDataSource {
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

extension AllUsersVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AUserCell", for: indexPath)
        cell.textLabel?.text = Pub.pub.allUsers[indexPath.row].EmailID
        cell.detailTextLabel?.text = "Rating is \(Pub.pub.allUsers[indexPath.row].Rating)"
        if Pub.pub.allUsers[indexPath.row].Image != "nil" {
            cell.imageView?.pin_updateWithProgress = true
            cell.imageView?.pin_setImage(from: URL(string: Pub.pub.allUsers[indexPath.row].Image)!)
        }else {
            cell.imageView?.image = #imageLiteral(resourceName: "DefaultAvatar")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Pub.pub.allUsers.count
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteRowAction = UITableViewRowAction(style: .default , title: "Delete", handler:{action, indexpath in
            self.Delete(Pub.pub.allUsers[indexpath.row].UUID, indexpath.row)
            self.startAnimating()
        });
        return [deleteRowAction];
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}



extension AHotelVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UReviewsCell", for: indexPath)
        cell.textLabel?.text = Pub.pub.allReviews[indexPath.row].EmailID
        cell.detailTextLabel?.text = Pub.pub.allReviews[indexPath.row].Comment
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteRowAction = UITableViewRowAction(style: .default , title: "Delete", handler:{action, indexpath in
            Manager.deleteComment(Pub.pub.allReviews[indexpath.row].CUID, completionHandler: { (err) in
                if err == nil {
                    Pub.pub.allReviews.remove(at: indexPath.row)
                    tableView.reloadData()
                    AlertBox(Heading: "Success", MSG: "Comment has been deleted", View: self)
                }else {
                    AlertBox(Heading: "Error", MSG: (err?.description)!, View: self)
                }
            })
        });
    
        return [deleteRowAction];
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Pub.pub.allReviews.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}




extension RoomsVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
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
        PubIDSegue = "roomDetailSegue"
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

