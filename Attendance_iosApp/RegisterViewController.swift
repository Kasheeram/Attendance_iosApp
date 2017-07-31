//
//  RegisterViewController.swift
//  Attendance_iosApp
//
//  Created by Apogee on 7/24/17.
//  Copyright © 2017 Apogee. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase


class RegisterViewController: UIViewController {

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var emailId: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirompass: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        
        // Do any additional setup after loading the view.
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        
        
                if isValidEmail(testStr: emailId.text!) && (password.text?.characters.count)! > 0 {
        
                    if password.text! != confirompass.text! {
                        let alertController = UIAlertController(title: "Error", message: "confirm password is not same as password", preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                    }else{
        
                        Auth.auth().createUser(withEmail: emailId.text!, password: password.text!) { (user, error) in
        
                            if error == nil {
                               // Toast(text: "You have sucessfully created your account").show()
                                
                                guard let uid = user?.uid else{
                                    return
                                }
                                
                                let ref = Database.database().reference(fromURL: "https://attendanceios-1be2b.firebaseio.com/")
                                let employeeReference = ref.child("Employees").child(uid)
                                
                                let values = ["name":self.userName.text,"email":self.emailId.text]
                                employeeReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                                    if err != nil{
                                        print(err)
                                        return
                                    }
                                })
                                
                                
                                
                                let formatter = DateFormatter()
                                // initially set the format based on your datepicker date
                                formatter.dateFormat = "dd-MMM-yyyy HH:mm:ss"
                                let myString = formatter.string(from: Date())
                                // convert your string to date
                                let yourDate = formatter.date(from: myString)
                                //then again set the date format whhich type of output you need
                                formatter.dateFormat = "dd-MMM-yyyy"
                                // again convert your date to string
                                let myStringafd = formatter.string(from: yourDate!)
                                
                                let employeeStatus = ref.child("Employees").child(uid).child("Status")
                                employeeStatus.updateChildValues(["Check":false,"PreviousDate":myStringafd], withCompletionBlock: { (err, ref) in
                                    if err != nil{
                                        print(err)
                                        return
                                    }
                                })
                              
                                
                                print("Save user successfully into firebase DB")
                                
                                self.emailId.text = ""
                                self.password.text = ""
                                self.confirompass.text = ""
                                self.userName.text = ""
                                
        
                            }else{
                                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                                alertController.addAction(defaultAction)
                                self.present(alertController, animated: true, completion: nil)
                            }
                            
                        }
        
                        try! Auth.auth().signOut()
                    }
        
                }else{
        
        
                    let alertController = UIAlertController(title: "Error", message: "Please enter the valid email id or password", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
                
        
    }

    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    
}
