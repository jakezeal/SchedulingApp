//
//  UIView+Shadow.swift
//  SchedulingApp
//
//  Created by Zeal on 4/26/16.
//  Copyright © 2016 Jake Zeal. All rights reserved.
//

import UIKit

extension UIView {
    func addShadow() {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 5
        self.layer.shadowOffset = CGSizeMake(3, 3)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.2
    }
}

