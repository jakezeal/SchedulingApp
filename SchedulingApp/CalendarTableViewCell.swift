//
//  CalendarTableViewCell.swift
//  SchedulingApp
//
//  Created by Jeffrey Ip on 2016-04-21.
//  Copyright © 2016 Jake Zeal. All rights reserved.
//

import UIKit

class CalendarTableViewCell: UITableViewCell {
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventDetails: UILabel!
    
    override func prepareForReuse() {
        self.eventDetails.text = ""
        self.eventName.text = ""
    }
}
