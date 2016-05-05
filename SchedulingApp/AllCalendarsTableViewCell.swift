//
//  AllCalendarsTableViewCell.swift
//  SchedulingApp
//
//  Created by Joao Paulo Aquino on 2016-04-26.
//  Copyright © 2016 Jake Zeal. All rights reserved.
//

import UIKit
import Parse

class AllCalendarsTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var intervalLabel: UILabel!
    var event: PFObject!
}
