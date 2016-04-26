//
//  CalendarCollectionViewCell.swift
//  SchedulingApp
//
//  Created by Zeal on 4/21/16.
//  Copyright © 2016 Jake Zeal. All rights reserved.
//

import UIKit

class CalendarCollectionViewCell: UICollectionViewCell {
    
    //MARK:- Outlets
    @IBOutlet weak var groupLabel: UILabel!
    
    @IBOutlet weak var calendarImage: UIImageView!
 
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderColor = UIColor.blueColor().colorWithAlphaComponent(0.6).CGColor
        layer.borderWidth = 1.0
    }
}
