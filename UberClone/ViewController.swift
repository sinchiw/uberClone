//
//  ViewController.swift
//  UberClone
//
//  Created by Wilmer sinchi on 5/31/19.
//  Copyright © 2019 Wilmer sinchi. All rights reserved.
//

import UIKit
import Firebase






class ViewController: UIViewController {
    
    @IBOutlet weak var switchButton: UISwitch!
    
    @IBOutlet weak var riderLabel: UILabel!
    
    @IBOutlet weak var driverLabel: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var singUpButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    
    var signUpMode = true
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func signUpActions(_ sender: Any) {
        
        
    }
    

    @IBAction func logInAction(_ sender: Any) {
        
        if (signUpMode){
            singUpButton.setTitle("Log In", for: .normal)
            logInButton.setTitle("Switch to Sign Up", for: .normal)
            riderLabel.isHidden = true
            driverLabel.isHidden = true
            switchButton.isHidden = true
            //this is important, so it know it change
            signUpMode = false
            
            
            
        } else {
            singUpButton.setTitle("Sign Up", for: .normal)
            logInButton.setTitle("Switch to Log In", for: .normal)
            riderLabel.isHidden = false
            driverLabel.isHidden = false
            switchButton.isHidden = false
            
            signUpMode = true
            
        }
    }
    
}

