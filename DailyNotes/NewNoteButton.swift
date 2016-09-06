//
//  NewNoteButton.swift
//  DailyNotes
//
//  Created by Zhicong Zang on 7/26/16.
//  Copyright © 2016 Zhicong Zang. All rights reserved.
//

import UIKit

class NewNoteButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        self.setBackgroundImage(UIImage(named: "LightGrayBackground"), forState: UIControlState.Highlighted)
        self.layer.cornerRadius = 2
        self.layer.masksToBounds = true
    }

}

class NewNoteReminderButton: NewNoteButton {
    var isSet = false {
        didSet {
            if oldValue != isSet {
                if isSet {
                    self.setImage(UIImage(named: "ReminderFilled"), forState: UIControlState.Normal)
                } else {
                    self.setImage(UIImage(named: "Reminder"), forState: UIControlState.Normal)
                }
            }
        }
    }
}
