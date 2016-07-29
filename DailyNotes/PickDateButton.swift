//
//  PickDateButton.swift
//  DailyNotes
//
//  Created by Zhicong Zang on 7/28/16.
//  Copyright © 2016 Zhicong Zang. All rights reserved.
//

import UIKit

class PickDateButton: UIButton {
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        backgroundColor = UIColor(white: 0.9, alpha: 0.8)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        backgroundColor = UIColor.clearColor()
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        touchesCancelled(touches, withEvent: event)
        backgroundColor = UIColor.clearColor()
    }
}
