//
//  TimeDetailTableViewCell.swift
//  Attendance_iosApp
//
//  Created by Apogee on 7/28/17.
//  Copyright © 2017 Apogee. All rights reserved.
//

import UIKit

class TimeDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var timeIn: UILabel!
    @IBOutlet weak var timeOut: UILabel!
    @IBOutlet weak var totalTime: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
