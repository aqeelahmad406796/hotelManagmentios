//
//  Model.swift
//  bookBridgeIOS
//
//  Created by Aqeel on 3/9/18.
//  Copyright © 2018 Aqeel. All rights reserved.
//

import Foundation
import Firebase

//Mark :- User
class UserProfile{
    var FirstName = ""
    var LastName = ""
    var EmailID = ""
    var UUID = ""
    var Image = ""
    var City = ""
    var Admin = false
    var Rating = 0
    init(data : [String:Any]) {
        FirstName = data["FirstName"] as? String ?? ""
        LastName  = data["LastName"] as? String ?? ""
        EmailID = data["EmailID"] as? String ?? ""
        UUID = data["UUID"] as? String ?? ""
        Image = data["Image"] as? String ?? ""
        City = data["City"] as? String ?? ""
        Admin = data["Admin"] as? Bool ?? false
        Rating = data["Rating"] as? Int ?? 0
    }
    init() {
    }
    func toDict() -> [String:Any] {
        return ["FirstName": FirstName,
                "LastName": LastName,
                "EmailID": EmailID,
                "UUID" : UUID,
                "Image" : Image,
                "Rating" : Rating,
                "City" : City,
                "Admin" : Admin]
    }
}

//Mark :- Room
class Room{
    var Image = ""
    var Price = -1
    var Available = false
    var UUID = ""
    var Description = ""
    var userID = ""
    init(data : [String:Any]) {
        Available = data["Available"] as? Bool ?? false
        Image  = data["Image"] as? String ?? ""
        UUID = data["UUID"] as? String ?? ""
        userID = data["userID"] as? String ?? ""
        Price = data ["Price"] as? Int ?? -1
        Description = data ["Description"] as? String ?? ""
    }
    func toDict() -> [String:Any] {
        return ["Available": Available,
                "Image": Image,
                "Price": Price,
                "UUID" : UUID,
                "userID" : userID,
                "Description" : Description]
    }
}

// Mark :- Reviews

class Reviews{
    var CUID = ""
    var Image = "nil"
    var EmailID = ""
    var Comment = ""
    var UUID = ""
    init (data : [String : Any]){
        CUID = data["CUID"] as? String ?? ""
        Image = data["Image"] as? String ?? "nil"
        EmailID = data["EmailID"] as? String ?? ""
        Comment = data["Comment"] as? String ?? ""
        UUID = data["UUID"] as? String ?? ""
    }
}

//Mark :- Feature
class RoomFeature{
    var Feature = ""
    var FUID = ""
    init(data : [String:Any]) {
        Feature = data ["Feature"] as? String ?? ""
        FUID = data ["FUID"] as? String ?? ""
    }
}

