//
//  KeyboardButton.swift
//  DailyNotes
//
//  Created by Zhicong Zang on 7/21/16.
//  Copyright © 2016 Zhicong Zang. All rights reserved.
//

import UIKit

class KeyboardButton: NewNoteButton {

    let keyboardImage = UIImage(named: "Keyboard")
    let keyboardDownImage = UIImage(named: "KeyboardDown")
    
    var isTyping = false {
        didSet {
            if isTyping {
                self.setImage(keyboardDownImage, forState: UIControlState.Normal)
            } else {
                self.setImage(keyboardImage, forState: UIControlState.Normal)
            }
        }
    }

}
