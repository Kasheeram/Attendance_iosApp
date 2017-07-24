//
//  ViewController.swift
//  Attendance_iosApp
//
//  Created by Apogee on 7/20/17.
//  Copyright © 2017 Apogee. All rights reserved.
//

import UIKit
import JTAppleCalendar
import Firebase

class ViewController: UIViewController {
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var month: UILabel!
    
    
    let outsideMonthColor = UIColor(colorWithHexValue: 0x584a66)
    let monthColor = UIColor.white
    let selectedMonthColor = UIColor(colorWithHexValue: 0x3a294b)
    let currentDateSelectedViewColor = UIColor(colorWithHexValue: 0x4e3f5d)
    let todayDate = UIColor.orange
    let formatter = DateFormatter()
    var check:Bool!
    var previousDat:String!
    
    let defaults = UserDefaults.standard
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        LogoutButton()
        
        
        setupCalendarView()
        calendarView.scrollToDate(Date.init())
        
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let myString = formatter.string(from: Date())
        // convert your string to date
        let yourDate = formatter.date(from: myString)
        //then again set the date format whhich type of output you need
        formatter.dateFormat = "dd-MMM-yyyy"
        // again convert your date to string
        let currentDate = formatter.string(from: yourDate!)
        
        let ref = Database.database().reference(fromURL: "https://attendanceios-1be2b.firebaseio.com/")
        
        
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            print("user id=\(String(describing: user?.uid))")
            guard let uid = user?.uid else{
                return
            }
            
            
            let employeeCheck = ref.child("Employees").child(uid).child("ComeIn")
            
            guard let previousDate = self.defaults.value(forKey: "previousDate") else {
                
                return
            }
            
            
            if previousDate as! String != currentDate{
                
                employeeCheck.updateChildValues(["Check":false], withCompletionBlock: { (err, ref) in
                    if err != nil{
                        print(err)
                        return
                    }
                })
                
                
//                print("currentdate123=\(currentDate)")
//                print("currentdate123=\(previousDate)")
            }

        }
        
    }

    func setupCalendarView()
    {
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        
        // setup label
        
        calendarView.visibleDates{(visbleDates) in
            
            self.setupViewOfCalendar(from: visbleDates)
        }
        
    }
    
    func handleCellTextColor(view: JTAppleCell?,cellState: CellState){
        guard let validCell = view as? CustomCell else { return }
        
        if validCell.isSelected{
            validCell.dateLabel.textColor = selectedMonthColor
        }else{
            if cellState.dateBelongsTo == .thisMonth{
                validCell.dateLabel.textColor = monthColor
            }else{
                validCell.dateLabel.textColor = outsideMonthColor
            }
        }
        
        
        
        let date = cellState.date
        self.formatter.dateFormat = "yyyy MM dd"
        let dt  = self.formatter.string(from: date)
        let date2 = Date()
        let dt2 = self.formatter.string(from: date2)
        
        if dt == dt2{
            validCell.dateLabel.textColor = todayDate
            validCell.selectedView.isHidden = false
        }

       
    }

    
    
    
    func handleCellSelectedColor(view: JTAppleCell?,cellState: CellState){
         guard let validCell = view as? CustomCell else{ return }
        
        if validCell.isSelected{
            validCell.selectedView.isHidden = false
            validCell.selectedView.backgroundColor = hexStringToUIColor (hex:"#FBC94D")
        }else{
            validCell.selectedView.isHidden = true
        }
    }
    
    func setupViewOfCalendar(from visbleDates:DateSegmentInfo){
        let date = visbleDates.monthDates.first!.date
        self.formatter.dateFormat = "yyyy"
        self.year.text = self.formatter.string(from: date)
        
        self.formatter.dateFormat = "MMMM"
        self.month.text = self.formatter.string(from: date)

    }
    
    
    func LogoutButton(){
//        let rightButtonItem = UIBarButtonItem.init(
//            title: "Logout",
//            style: .done,
//            target: self,
//            action: Selector(("rightButtonAction:"))
//        )
//        
//        self.navigationItem.rightBarButtonItem = rightButtonItem
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(ViewController.rightButtonAction))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        LogoutButton()
        self.navigationItem.setHidesBackButton(true, animated:true);
    }
    
    
    func rightButtonAction(){
        let storyBoard = UIStoryboard(name:"Main",bundle:nil)
        let vcOBJ = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        // self.navigationController?.navigationBar.barTintColor = UIColor.green
        self.navigationController?.pushViewController(vcOBJ, animated: true)

        
    }
    
}

    extension ViewController: JTAppleCalendarViewDataSource{
        func configureCalendar(_ calendar: JTAppleCalendarView)->ConfigurationParameters{
            formatter.dateFormat = "yyyy MM dd"
            formatter.timeZone = Calendar.current.timeZone
            let startDate = formatter.date(from:"2017 01 01")
            let endDate = formatter.date(from:"2017 12 31")
            let parameters = ConfigurationParameters(startDate: startDate!,endDate: endDate!)
            return parameters
        }
        
    }

extension ViewController: JTAppleCalendarViewDelegate{
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
        cell.dateLabel.text = cellState.text
        
        handleCellSelectedColor(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
//        handleCellSelectedColor(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
       // print("date123=\(cellState.date)")
        
        
        
        Auth.auth().addStateDidChangeListener { auth, user in
            guard let uid = user?.uid else{
                return
            }
            
            
            
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
            
            let selectedDate = formatter.string(from: cellState.date)
            print("date12=\(selectedDate)")
            
            if selectedDate != myStringafd{
                return
            }
            
            self.handleCellSelectedColor(view: cell, cellState: cellState)
             print("date12=\(myStringafd)")
             let values = [myStringafd:myString]
            
            // employeeReference.setValue(values)
            
            self.defaults.set(myStringafd, forKey: "previousDate")
            self.defaults.synchronize()
            //self.previousDat = myStringafd
            let ref = Database.database().reference(fromURL: "https://attendanceios-1be2b.firebaseio.com/")
            let employeeReferenceIn = ref.child("Employees").child(uid).child("ComeIn")
            let employeeReferenceOut = ref.child("Employees").child(uid).child("ComeOut")
            //let check:Bool!
            
            employeeReferenceIn.child("Check").observeSingleEvent(of:.value, with: {(DataSnapshot) in
                
                self.check = DataSnapshot.value as? Bool
                print("check123=\(self.check)")
                
                        if !self.check{
                                employeeReferenceIn.updateChildValues(values, withCompletionBlock: { (err, ref) in
                                    if err != nil{
                                        print(err)
                                        return
                                    }
                                })
                
                                employeeReferenceIn.updateChildValues(["Check":true], withCompletionBlock: { (err, ref) in
                                    if err != nil{
                                        print(err)
                                        return
                                    }
                                })
                                
                            }else{
                
                                employeeReferenceOut.updateChildValues(values, withCompletionBlock: { (err, ref) in
                                    if err != nil{
                                        print(err)
                                        return
                                    }
                                })
                            }
                
            })
            
        }
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        
         handleCellSelectedColor(view: cell, cellState: cellState)
         handleCellTextColor(view: cell, cellState: cellState)
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        self.setupViewOfCalendar(from: visibleDates)
       
    }
    
    
}

extension UIColor{
    convenience init(colorWithHexValue value:Int, alpha:CGFloat = 1.0){
        self.init(
            red: CGFloat((value & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((value & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(value & 0x0000FF) / 255.0,
            alpha:alpha
            
            )
    }
}

func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.characters.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}



