//
//  LoginViewController.swift
//  Attendance_iosApp
//
//  Created by Apogee on 7/21/17.
//  Copyright © 2017 Apogee. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    @IBOutlet weak var emailId: UITextField!
    @IBOutlet weak var password: UITextField!

   // var ref: DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ref = Database.database().reference()
        
//        Auth.auth().addStateDidChangeListener { (auth, user) in
//            print("user id=\(String(describing: user?.uid))")
//        }
        
        self.navigationController?.navigationBar.barTintColor = UIColor.yellow
       // let interval = laterDate.timeIntervalSinceDate(earlierDate)

        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        
        
        
        
        if (emailId.text?.characters.count)! > 0 && (password.text?.characters.count)! > 0{
            
            Auth.auth().signIn(withEmail: emailId.text!, password: password.text!) { (user, error) in
                
                if error == nil {
                   // Toast(text: "You have successfully logged in").show()
                    let storyBoard = UIStoryboard(name:"Main",bundle:nil)
                    let vcOBJ = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                    self.presentedViewController?.show(vcOBJ, sender: true)
                    //                    self.navigationController?.navigationBar.barTintColor = UIColor.green
                    self.navigationController?.pushViewController(vcOBJ, animated: true)
                    
                    
                } else {
                    
                    //Tells the user that there is an error and then gets firebase to tell them the error
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
            
        }else{
            
            let alertController = UIAlertController(title: "Error", message: "Please don't enter null value", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }

        
    }
    
    
    @IBAction func registrationButtonTapped(_ sender: Any) {
        
        
        let storyBoard = UIStoryboard(name:"Main",bundle:nil)
        let vcOBJ = storyBoard.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        //self.presentedViewController?.show(vcOBJ, sender: true)
        // self.navigationController?.navigationBar.barTintColor = UIColor.green
        self.navigationController?.pushViewController(vcOBJ, animated: true)

        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.setHidesBackButton(true, animated:true);
        self.navigationController?.navigationBar.barTintColor = UIColor.yellow
    }

    
    
    
}
