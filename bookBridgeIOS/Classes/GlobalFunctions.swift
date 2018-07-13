//
//  GlobalFunctions.swift
//  bookBridgeIOS
//
//  Created by Aqeel on 3/10/18.
//  Copyright © 2018 Aqeel. All rights reserved.
//

import Foundation
import UIKit


public func AlertBox(Heading : String , MSG : String , View : UIViewController) {
    let alert = UIAlertController(title: Heading, message: MSG, preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
    alert.view.layer.cornerRadius = 15
    View.present(alert, animated: true, completion: nil)
}

public func UploadRemaingData ( _ uid : String , _ value : [String : Any]) {
    Manager.createUserRemaining(uid , value) { (err) in
        guard err == nil else{
            googleSignInErr = err!
            return
        }
        googleSignInErr = ""
        PubGoogleLoggedIn = true
    }
}


