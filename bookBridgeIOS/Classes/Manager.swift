//
//  Manager.swift
//  bookBridgeIOS
//
//  Created by Aqeel on 3/9/18.
//  Copyright © 2018 Aqeel. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Manager {
    typealias CreateUser = (User? , String?) -> ()
    typealias UserProf = (UserProfile? , String?) -> ()
    typealias createUserRema = (String?) -> ()
    typealias upImage = (String? , String?) -> ()
    typealias getRooms = (Room?) -> ()
    typealias updateRoom = (String?) -> ()
    typealias signoutRoom = (String?) -> ()
    typealias features = (RoomFeature?) -> ()
    typealias reviews = (Reviews?) -> ()
    typealias stringType = (String?) -> ()
    
    //Mark :- Create User
    class func createUser(_ EmailID : String , _ Passowrd : String , completionHandler : @escaping CreateUser ){
        Auth.auth().createUser(withEmail: EmailID, password: Passowrd) { (user, error) in
            guard error == nil else {
                completionHandler(nil , error?.localizedDescription)
                return
            }
            completionHandler(user , nil)
        }
    }
    //Mark :- CreateUserRemaining
    class func createUserRemaining(_ uid : String,_ user : [String : Any] , completionHandler : @escaping createUserRema){
        let ref = Database.database().reference(fromURL: PubFirebaseURL)
        let userRef = ref.child("Users").child(uid)
        userRef.updateChildValues(user, withCompletionBlock: {
            (err,ref) in
            if(err != nil)
            {
                print(err!)
                completionHandler(err?.localizedDescription)
                return
            }
            completionHandler(nil)
        })
    }
    //Mark :- Login User
    class func LogIn(_ EmailID : String , _ Passowrd : String , completionHandler : @escaping CreateUser ){
        Auth.auth().signIn(withEmail: EmailID, password: Passowrd) { (user, error) in
            guard error == nil else {
                completionHandler(nil , error?.localizedDescription)
                return
            }
            completionHandler(user , nil)
        }
    }
    //Mark :- signout User
    class func signout( completionHandler : @escaping signoutRoom ){
        do{
            try Auth.auth().signOut()
            completionHandler("done")
        }catch{
            completionHandler(nil)
        }
    }
    //Mark :- GetCurrentUserData
    class func GetCurrentUserData(_ uuid : String , completionHandler : @escaping UserProf){
        let ref = Database.database().reference(fromURL: PubFirebaseURL)
        let contactref = ref.child("Users").child(uuid)
        contactref.keepSynced(true)
        contactref.observeSingleEvent(of: .value) { (DataSnapshot) in
            print(DataSnapshot)
            if let dictionary = DataSnapshot.value as? [String : Any]
            {
                let member = UserProfile(data: dictionary)
                completionHandler(member , nil)
            }else {
                completionHandler(nil , "Something Went Wrong")
            }
        }
    }
    //Mark :- Get All users
    class func getAllUsers(completionHandler : @escaping UserProf){
        let ref = Database.database().reference(fromURL: PubFirebaseURL)
        let contactref = ref.child("Users")
        contactref.keepSynced(true)
        contactref.observe(.childAdded, with: { (DataSnapshot) in
            print(DataSnapshot)
            if let dictionary = DataSnapshot.value as? [String : Any]
            {
                let prof = UserProfile(data: dictionary)
                completionHandler(prof,nil)
            }
            else {
                completionHandler(nil,nil)
            }
        }, withCancel: nil)
    }
    //Mark :- Upload Image
    class func uploadImage(_ imageFolder : String,_ uploadData : Data ,completionHandler : @escaping upImage){
        let ImageName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child(imageFolder).child("\(ImageName).png")
        storageRef.putData(uploadData, metadata: nil, completion: { (metaData, error) in
            if(error != nil)
            {
                print(error!)
                do{try
                    Auth.auth().signOut()
                }
                catch{print(error)}
                return
            }
            if let profileImageUrl = metaData?.downloadURL()?.absoluteString
            {
                completionHandler(profileImageUrl , error?.localizedDescription)
            }
        })
    }
    //Mark :- Delete Image
    class func deleteImage(_ imageFolder : String,_ imagName : String ,completionHandler : @escaping updateRoom){
        let storageRef = Storage.storage().reference().child(imageFolder).child(imagName)
        storageRef.delete { (error) in
            completionHandler(error?.localizedDescription)
        }
    }
    //Mark :- Get Rooms
    class func getAllRooms(completionHandler : @escaping getRooms){
        let ref = Database.database().reference(fromURL: PubFirebaseURL)
        let contactref = ref.child("Rooms")
        contactref.keepSynced(true)
        contactref.observe(.childAdded, with: { (DataSnapshot) in
            print(DataSnapshot)
            if let dictionary = DataSnapshot.value as? [String : Any]
            {
                let room = Room(data: dictionary)
                completionHandler(room)
            }
            else {
                completionHandler(nil)
            }
        }, withCancel: nil)
    }
    //Mark :- Room Update
    class func updatRoom(_ uid : String,_ room : [String : Any] , completionHandler : @escaping updateRoom){
        let ref = Database.database().reference(fromURL: PubFirebaseURL)
        let roomRef = ref.child("Rooms").child(uid)
        roomRef.updateChildValues(room, withCompletionBlock: {
            (err,ref) in
            if(err != nil)
            {
                print(err!)
                completionHandler(err?.localizedDescription)
                return
            }
            completionHandler(nil)
        })
    }
    //Mark :- Room upload
    class func uploadRoom(_ uid : String , _ room : [String : Any] , completionHandler : @escaping updateRoom){
        let ref = Database.database().reference(fromURL: PubFirebaseURL)
        let roomRef = ref.child("Rooms").child(uid)
        roomRef.updateChildValues(room, withCompletionBlock: {
            (err,ref) in
            if(err != nil)
            {
                print(err!)
                completionHandler(err?.localizedDescription)
                return
            }
            completionHandler(nil)
        })
    }
    //Markd :- Delete Room
    class func deleteRoom(_ uid : String , completionHandler : @escaping updateRoom){
        let ref = Database.database().reference(fromURL: PubFirebaseURL)
        let roomRef = ref.child("Rooms").child(uid)
        roomRef.removeValue { (err, ref) in
            if(err != nil)
            {
                print(err!)
                completionHandler(err?.localizedDescription)
                return
            }
            PubRoomCount = PubRoomCount - 1
            completionHandler(nil)
        }
    }
    
    //Markd :- Delete Room
    class func deleteUser(_ uid : String , completionHandler : @escaping updateRoom){
        let ref = Database.database().reference(fromURL: PubFirebaseURL)
        let UserRef = ref.child("Users").child(uid)
        UserRef.removeValue { (err, ref) in
            if(err != nil)
            {
                print(err!)
                completionHandler(err?.localizedDescription)
                return
            }
            completionHandler(nil)
        }
    }
    
    //Markd :- Delete Comment
    class func deleteComment(_ uid : String , completionHandler : @escaping stringType){
        let ref = Database.database().reference(fromURL: PubFirebaseURL)
        let roomRef = ref.child("Comments").child(uid)
        roomRef.removeValue { (err, ref) in
            if(err != nil)
            {
                print(err!)
                completionHandler(err?.localizedDescription)
                return
            }
            completionHandler(nil)
        }
    }
    
    //Mark :- uploadFeatures
    class func UploadFeatures(_ uid : String,_ feature : String , completionHandler : @escaping createUserRema){
        let featureUID = NSUUID().uuidString
        let feat = ["Feature" : feature,
                    "FUID" : featureUID]
        let ref = Database.database().reference(fromURL: PubFirebaseURL)
        let userRef = ref.child("Features").child(uid).child(featureUID)
        userRef.updateChildValues(feat, withCompletionBlock: {
            (err,ref) in
            if(err != nil)
            {
                print(err!)
                completionHandler(err?.localizedDescription)
                return
            }
            completionHandler(nil)
        })
    }
    //Mark :- DeleteFeatures
    class func DeleteFeatures(_ uid : String, completionHandler : @escaping createUserRema){
        let ref = Database.database().reference(fromURL: PubFirebaseURL)
        let featurRef = ref.child("Features").child(uid)
        featurRef.removeValue { (err, ref) in
            if(err != nil)
            {
                print(err!)
                completionHandler(err?.localizedDescription)
                return
            }
            completionHandler(nil)
        }
    }
    //Mark :- Delete A Feature
    class func DeleteAFeature(_ RUID : String , FUID : String , completionHandler : @escaping createUserRema){
        let ref = Database.database().reference(fromURL: PubFirebaseURL)
        let featurRef = ref.child("Features").child(RUID).child(FUID)
        featurRef.removeValue { (err, ref) in
            if(err != nil)
            {
                print(err!)
                completionHandler(err?.localizedDescription)
                return
            }
            completionHandler(nil)
        }
    }
    //Mark :- Update A Feature
    class func UpdateAFeature(_ RUID : String,_ FUID : String , feature : String , completionHandler : @escaping createUserRema){
        let feat = ["Feature" : feature,
                    "FUID" : FUID]
        let ref = Database.database().reference(fromURL: PubFirebaseURL)
        let userRef = ref.child("Features").child(RUID).child(FUID)
        userRef.updateChildValues(feat, withCompletionBlock: {
            (err,ref) in
            if(err != nil)
            {
                print(err!)
                completionHandler(err?.localizedDescription)
                return
            }
            completionHandler(nil)
        })
    }
    //Mark :- Get Features
    class func getFeatures(_ uid : String , completionHandler : @escaping features){
        let ref = Database.database().reference(fromURL: PubFirebaseURL)
        let contactref = ref.child("Features").child(uid)
        contactref.keepSynced(true)
        contactref.observe(.childAdded, with: { (DataSnapshot) in
            print(DataSnapshot)
            if let dictionary = DataSnapshot.value as? [String : Any]
            {
                let feature = RoomFeature(data: dictionary)
                completionHandler(feature)
            }
            else {
                completionHandler(nil)
            }
        }, withCancel: nil)
    }
    
    //Mark :- Get Room Rating
    class func getReviews( completionHandler : @escaping reviews){
        let ref = Database.database().reference(fromURL: PubFirebaseURL)
        let contactref = ref.child("Comments")
        contactref.keepSynced(true)
        contactref.observe(.childAdded, with: { (DataSnapshot) in
            print(DataSnapshot)
            if let dictionary = DataSnapshot.value as? [String : Any]
            {
                let rating  = Reviews(data: dictionary)
                completionHandler(rating)
            }
            else {
                completionHandler(nil)
            }
        }, withCancel: nil)
    }
    //Mark :- Get Room Rating
    class func postReviews( uid : String , _ review : [String : Any] , completionHandler : @escaping stringType){
        let ref = Database.database().reference(fromURL: PubFirebaseURL)
        let reviewRef = ref.child("Comments").child(uid)
        reviewRef.updateChildValues(review, withCompletionBlock: {
            (err,ref) in
            if(err != nil)
            {
                print(err!)
                completionHandler(err?.localizedDescription)
                return
            }
            completionHandler(nil)
        })
    }
    class func changePassword(_ email: String, _ currentPassword: String, _ newPassword: String, completion: @escaping stringType) {
        let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)
        Auth.auth().currentUser?.reauthenticate(with: credential, completion: { (error) in
            if error == nil {
                Auth.auth().currentUser?.updatePassword(to: newPassword) { (errror) in
                    completion(errror?.localizedDescription)
                }
            } else {
                completion(error.debugDescription)
            }
        })
    }
    
}
