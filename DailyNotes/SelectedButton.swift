//
//  SelectedButton.swift
//  DailyNotes
//
//  Created by Zhicong Zang on 8/15/16.
//  Copyright © 2016 Zhicong Zang. All rights reserved.
//

import UIKit

class SelectedButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = min(frame.height, frame.width) / 2
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor(white: 0.8, alpha: 1).CGColor
        self.layer.borderWidth = 1
        self.addTarget(self, action: #selector(SelectedButton.didSelected(_:)), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    @objc func didSelected(sender: FontSettingButton) {
        selected = !selected
        setNeedsDisplay()
    }
    
    override func drawRect(rect: CGRect) {
        let path = UIBezierPath(roundedRect: CGRect(x: 5, y: 5, width: rect.width - 10, height: rect.height - 10), cornerRadius: (rect.width - 10) / 2)
        if selected {
            UIColor(white: 0.8, alpha: 1).set()
        }
        else {
            UIColor.whiteColor().set()
        }
        path.fill()
    }

}
