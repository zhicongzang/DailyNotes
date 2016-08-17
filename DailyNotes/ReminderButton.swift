//
//  SelectedButton.swift
//  DailyNotes
//
//  Created by Zhicong Zang on 8/15/16.
//  Copyright © 2016 Zhicong Zang. All rights reserved.
//

import UIKit

class ReminderButton: UIButton {
    
    dynamic var completed = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = min(frame.height, frame.width) / 2
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor(white: 0.8, alpha: 1).CGColor
        self.layer.borderWidth = 1
        self.addTarget(self, action: #selector(ReminderButton.didSelected(_:)), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    @objc func didSelected(sender: FontSettingButton) {
        completed = !completed
    }
    
    override func drawRect(rect: CGRect) {
        let path = UIBezierPath(roundedRect: CGRect(x: 5, y: 5, width: rect.width - 10, height: rect.height - 10), cornerRadius: (rect.width - 10) / 2)
        if completed {
            UIColor(white: 0.8, alpha: 1).set()
        }
        else {
            UIColor.whiteColor().set()
        }
        path.fill()
    }

}
