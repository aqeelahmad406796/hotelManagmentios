//
//  FindPassVC.swift
//  bookBridgeIOS
//
//  Created by Aqeel on 2/15/18.
//  Copyright © 2018 Aqeel. All rights reserved.
//

import UIKit

class FindPassVC: UIViewController {
    //********outlets******
    //Start
    @IBOutlet weak var emailTF: UITextField!
    //End
    
    
    //*********Variables*******
    //Start
    //End
    
    
    //*******override
    //Start
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("--memory Warning findPass Screen--")
    }
    //End
    
    
    
    //*******Actions*****
    //Start
    @IBAction func emailMeMyPass(_ sender: Any) {
    }
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    //End

    
    
    //*******Functions*******
    //Start
    //End

}
