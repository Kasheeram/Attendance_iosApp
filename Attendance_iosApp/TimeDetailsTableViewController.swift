//
//  TimeDetailsTableViewController.swift
//  Attendance_iosApp
//
//  Created by Apogee on 7/27/17.
//  Copyright © 2017 Apogee. All rights reserved.
//

import UIKit
import Firebase

class TimeDetailsTableViewController: UITableViewController {
    
    @IBOutlet var tableview: UITableView!
    
    var comeInTime = [String]()
    var comeOutTime = [String]()
    var totalTime = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let uid = Auth.auth().currentUser?.uid
        if uid == nil{
            return
        }
        
        let ref = Database.database().reference()
        let employeeReference = ref.child("Employees").child(uid!)
        
        
        employeeReference.child("ComeIn").observeSingleEvent(of: .value, with: { snapshot in
                for rest in snapshot.children.allObjects as! [DataSnapshot] {
                self.comeInTime.append(rest.value! as! String)
            }
            self.tableview.reloadData()
        })
//
//        
        employeeReference.child("ComeOut").observeSingleEvent(of: .value, with: { snapshot in
            for rest in snapshot.children.allObjects as! [DataSnapshot] {
                self.comeOutTime.append(rest.value! as! String)
            }
            self.tableview.reloadData()
        })
        
        employeeReference.child("Duration").observeSingleEvent(of: .value, with: { snapshot in
            for rest in snapshot.children.allObjects as! [DataSnapshot] {
                self.totalTime.append(rest.value! as! String)
            }
            self.tableview.reloadData()
        })
        
    }
    
    
    
       override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.totalTime.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimeDetailTableViewCell", for: indexPath) as! TimeDetailTableViewCell

        cell.timeIn.text = self.comeInTime[indexPath.row]
        cell.timeOut.text = self.comeOutTime[indexPath.row]
        cell.totalTime.text = self.totalTime[indexPath.row]
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableview.reloadData()
    }
    
}
