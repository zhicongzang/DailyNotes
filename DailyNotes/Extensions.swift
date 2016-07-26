//
//  Extensions.swift
//  DailyNotes
//
//  Created by Zhicong Zang on 7/26/16.
//  Copyright © 2016 Zhicong Zang. All rights reserved.
//

import UIKit


extension UIButton {
    convenience init(image: UIImage?) {
        self.init(frame: CGRectZero)
        self.setImage(image, forState: UIControlState.Normal)
    }
}