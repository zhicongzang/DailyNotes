//
//  FlashButton.swift
//  DailyNotes
//
//  Created by Zhicong Zang on 8/1/16.
//  Copyright © 2016 Zhicong Zang. All rights reserved.
//

import UIKit

enum FlashMode {
    case On
    case Off
    case Auto
}

class FlashButton: UIButton {
    
    let autoImage = UIImage(named: "FlashAuto")!
    let onImage = UIImage(named: "FlashOn")!
    let offImage = UIImage(named: "FlashOff")!
    
    var flashMode = FlashMode.Auto {
        didSet {
            switch flashMode {
            case .Auto:
                self.setImage(autoImage, forState: UIControlState.Normal)
            case .On:
                self.setImage(onImage, forState: UIControlState.Normal)
            case .Off:
                self.setImage(offImage, forState: UIControlState.Normal)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setImage(autoImage, forState: UIControlState.Normal)
        setBorder()
    }
    
    func changeFlashMode() {
        switch flashMode {
        case .Auto:
            flashMode = .On
        case .On:
            flashMode = .Off
        case .Off:
            flashMode = .Auto
        }
    }
    
}
