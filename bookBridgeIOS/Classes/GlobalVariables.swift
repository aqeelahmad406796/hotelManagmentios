//
//  GlobalVariables.swift
//  bookBridgeIOS
//
//  Created by Aqeel on 2/15/18.
//  Copyright © 2018 Aqeel. All rights reserved.
//

import Foundation
import UIKit


public var PubIDSegue = "mainSegue"
public var PubLoggedInDefaultsKey = "LoggedIn"
public var PubAdminDefaulsKey = "AdminDefaults"
public var PubFirebaseURL = "https://hotel-management-cloud.firebaseio.com/"
public let PubGreenColor = UIColor(red: 77/255, green: 186/255, blue: 19/255, alpha: 1)
public let PubRoomFolder = "RoomImages"
public var PubRoomCount = 0
public var PubRoomIndex = -1
public var googleSignInErr = ""
public var PubGoogleLoggedIn = false






class Pub{
    static let pub = Pub()
    var user : UserProfile = UserProfile()
    var currentRoom : Room!
    var allUsers = [UserProfile]()
    var allReviews = [Reviews]()
}
