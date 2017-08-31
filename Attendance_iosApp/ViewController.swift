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
import CoreLocation

class ViewController: UIViewController,CLLocationManagerDelegate {
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var month: UILabel!
    @IBOutlet weak var collectionview: JTAppleCalendarView!
    
    let locationManager = CLLocationManager()
    var currentLocation:CLLocation!
    var lat: Double!
    var log: Double!
   
    let currentDate = Date()
    let formatter = DateFormatter()
    let userCalendar = Calendar.current
    let requestedComponent: Set<Calendar.Component> = [.month,.day,.hour,.minute,.second]
    
    let outsideMonthColor = UIColor(colorWithHexValue: 0x584a66)
    let monthColor = UIColor.white
    let selectedMonthColor = UIColor(colorWithHexValue: 0x3a294b)
    let currentDateSelectedViewColor = UIColor(colorWithHexValue: 0x4e3f5d)
    let todayDate = UIColor.orange
   
    var check:Bool!
    var previousDat:String!
    let timeDetails = [[String]]()
    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.stopMonitoringSignificantLocationChanges()
        
        UserDefaults.standard.set("12.9145506221853", forKey: "latitude")
        UserDefaults.standard.set("77.6122452890918", forKey: "longitude")
        
        LogoutButton()
        self.collectionview.isScrollEnabled = false;
        setupCalendarView()
        calendarView.scrollToDate(Date.init())

        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: Date())
        // convert your string to date
        let yourDate = formatter.date(from: myString)
        //then again set the date format whhich type of output you need
        formatter.dateFormat = "dd-MMM-yyyy"
        // again convert your date to string
        let currentDate = formatter.string(from: yourDate!)
        
        let uid = Auth.auth().currentUser?.uid
        if uid == nil{
            return
        }
        
        let employeeStatus = Database.database().reference().child("Employees").child(uid!).child("Status")
        employeeStatus.child("PreviousDate").observeSingleEvent(of:.value, with: {(DataSnapshot) in
            let previousDate = DataSnapshot.value as? String
            print("check123=\(String(describing: previousDate))")
            if previousDate != currentDate{
                employeeStatus.updateChildValues(["Check":false], withCompletionBlock: { (err, ref) in
                    if err != nil{
                        print(err)
                        return
                    }
                })
            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        locationAutStatus()
    }
    
    func locationAutStatus(){
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            currentLocation = locationManager.location
            print(currentLocation.coordinate.latitude)
            print(currentLocation.coordinate.longitude)
            
            lat = currentLocation.coordinate.latitude
            log = currentLocation.coordinate.longitude
        }else{
            locationManager.requestWhenInUseAuthorization()
            locationAutStatus()
        }
    }

    func setupCalendarView()
    {
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
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
//            let timeDuration = UserDefaults.standard.value(forKey: "timeduration") as! String
//            if timeDuration >= "9" {
//                validCell.selectedView.backgroundColor = .green
//            }else{
            validCell.selectedView.backgroundColor = hexStringToUIColor (hex:"#FBC94D")
           // }
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(ViewController.rightButtonAction))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Status", style: .plain, target: self, action: #selector(ViewController.leftButtonAction))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        LogoutButton()
        self.navigationItem.setHidesBackButton(true, animated:true);
    }
    
    func rightButtonAction(){
        try! Auth.auth().signOut()
        let storyBoard = UIStoryboard(name:"Main",bundle:nil)
        let vcOBJ = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(vcOBJ, animated: true)
    }
    
    func leftButtonAction(){
        let storyBoard = UIStoryboard(name:"Main",bundle:nil)
        let vcOBJ = storyBoard.instantiateViewController(withIdentifier: "TimeDetailsTableViewController") as! TimeDetailsTableViewController
        vcOBJ.title = "Attendance Details"
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
        let uid = Auth.auth().currentUser?.uid
        if uid == nil{
            return
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy HH:mm:ss"
        let myString = formatter.string(from: Date())
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = "dd-MMM-yyyy"
        let myStringafd = formatter.string(from: yourDate!)
        let selectedDate = formatter.string(from: cellState.date)
        print("date12=\(selectedDate)")
        if selectedDate != myStringafd{
            return
        }
        self.handleCellSelectedColor(view: cell, cellState: cellState)
        print("date12=\(myStringafd)")
        let values = [myStringafd:myString]
        let ref = Database.database().reference()
        let employeeStatus = ref.child("Employees").child(uid!).child("Status")
        let employeeDuration = ref.child("Employees").child(uid!).child("Duration")
        let employeeReferenceIn = ref.child("Employees").child(uid!).child("ComeIn")
        let employeeReferenceOut = ref.child("Employees").child(uid!).child("ComeOut")
        //let check:Bool!
        let radius: Double = 100 // miles // meters
        let userLocation = CLLocation(latitude: lat, longitude: log)
        let venueLocation = CLLocation(latitude: 12.9145506221853, longitude: 77.6122452890918)
        let distanceInMeters = userLocation.distance(from: venueLocation)
        //let distanceInMiles = distanceInMeters * 0.00062137
        if distanceInMeters > radius {
            // user is near the venue
            print("You are not in office")
            return
        }
        employeeStatus.child("Check").observeSingleEvent(of:.value, with: {(DataSnapshot) in
            self.check = DataSnapshot.value as? Bool
            print("check125=\(self.check)")
            if !self.check{
                employeeReferenceIn.updateChildValues(values, withCompletionBlock: { (err, ref) in
                    if err != nil{
                        print(err)
                        return
                    }
                })
                UserDefaults.standard.set(Date(), forKey: "inTiming")
                employeeStatus.updateChildValues(["Check":true,"PreviousDate":myStringafd], withCompletionBlock: { (err, ref) in
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
                UserDefaults.standard.set(Date(), forKey: "outTiming")
                UserDefaults.standard.synchronize()
                formatter.dateFormat = "dd/MM/yy hh:mm:ss"
                var timeIn = UserDefaults.standard.object(forKey: "inTiming") as? Date
                if timeIn == nil{
                    timeIn = Date()
                }
                let timeOut = UserDefaults.standard.object(forKey: "outTiming") as? Date
                let timeDifference = self.userCalendar.dateComponents(self.requestedComponent, from: timeIn!, to: timeOut!)
                let time = "\(timeDifference.hour!):\(timeDifference.minute!)"
                let timeduration = "\(timeDifference.hour!)" as! String
                UserDefaults.standard.set(timeduration, forKey: "timeduration")
                employeeDuration.updateChildValues([myStringafd:time], withCompletionBlock: { (err, ref) in
                    if err != nil{
                        print(err)
                        return
                    }
                })
                                    
            }
            
        })
        
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



