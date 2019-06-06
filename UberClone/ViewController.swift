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
        if emailTextField.text == "" || passwordTextField.text == ""{
            print("Error empty textField")
            displayAlert(title: "Error", message: "Please enter Email & Password")
            
        } else {
            if signUpMode {
                //sign up
                Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                    if error != nil {
                        self.displayAlert(title: "Error", message: error!.localizedDescription)
                    } else {
                        self.displayAlert(title: "Sign Up", message: "Registration was a success, switch to log in to sign in (:")
                        //signing up for different type of user, one for rider, one for driver
                        if self.switchButton.isOn{
                            //DRIVER
                          let req =  Auth.auth().currentUser?.createProfileChangeRequest()
                            req?.displayName = "Driver"
                            req?.commitChanges(completion: nil)
                            print("Sign up success for Driver")
                            //fiz this part of coding
                            self.performSegue(withIdentifier: "driverSegue", sender: nil)

                        } else {
                            //RIDER
                            let req =  Auth.auth().currentUser?.createProfileChangeRequest()
                            req?.displayName = "Rider"
                            req?.commitChanges(completion: nil)
                            print("Sign up succes for Driver")
                             self.performSegue(withIdentifier: "riderSegue", sender: nil)
                        }
//                        print("Sign up Success")
//                        self.performSegue(withIdentifier: "riderSegue", sender: nil)
                        
                    }
                }
            } else {
                //sign in
                //if and else statement to sign in depending on a type of user(Driver or Rider) on line 84
                Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                    if error != nil {
                        self.displayAlert(title: "Error", message: error!.localizedDescription)
                   
                    } else {
                        //Driver
                        
                        if user?.user.displayName == "Driver"{
                            self.performSegue(withIdentifier: "driverSegue", sender: nil)
                            print ("Sign in Sucess for Driver")
                            
                        } else {
                            //Rider
                            self.performSegue(withIdentifier: "riderSegue", sender:nil)
                            print("Sign in Success for Rider")
                        }
                        
                        
                        
                    }
                }
                
            }
        }
        
    }
    
    func displayAlert(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            
//        } else if( title == "Sign up" & message == "Registration was a success"){
//            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in self.performSegue(withIdentifier: "riderSegue", sender: nil)}))
//             self.present(alertController, animated: true, completion: nil)
        
        
       
        
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

