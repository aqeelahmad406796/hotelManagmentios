//
//  SplashVC.swift
//  bookBridgeIOS
//
//  Created by Aqeel on 2/15/18.
//  Copyright © 2018 Aqeel. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class SplashVC: UIViewController {
    
    
    //*******Outlets******
    //Start
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    @IBOutlet weak var subtitleLbl: UIStackView!
    //End
    
    
    //*******Variables********
    //Start
    var openFirstTime = true
    //End
    
    
    //*******Override*********
    //Start
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animation()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        activityIndicator.startAnimating()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("--memory Warning splash Screen--")
    }
    //End
    
    
    
    
    
    
    
    //*********Functions********
    //Start
    func LoggedIn () -> Bool {
//        if UserDefaults.standard.bool(forKey: PubLoggedInDefaultsKey) {
//            return true
//        }
        return false
    }
    func animation()  {
//        if LoggedIn(){
//            PubIDSegue = "loggedInSegue"
//        }else{
//            PubIDSegue = "mainSegue"
//        }
        if openFirstTime {
            subtitleLbl.center.y = subtitleLbl.center.y + 150
        }else {
            subtitleLbl.center.y = subtitleLbl.center.y + 10
        }
        UIView.animate(withDuration: 3.0, animations: {
            if self.openFirstTime {
                self.subtitleLbl.center.y = self.subtitleLbl.center.y - 150
                self.openFirstTime = false
            }else {
                self.subtitleLbl.center.y = self.subtitleLbl.center.y - 10
            }
        }) { (_) in
            self.activityIndicator.stopAnimating()
            self.seguePerform()
        }
    }
    func seguePerform(){
        performSegue(withIdentifier: PubIDSegue, sender: nil)
    }
    //End
}
