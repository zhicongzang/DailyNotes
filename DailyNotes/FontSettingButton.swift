//
//  FontSettingButton.swift
//  DailyNotes
//
//  Created by Zhicong Zang on 7/26/16.
//  Copyright © 2016 Zhicong Zang. All rights reserved.
//

import UIKit

class FontSettingButton: UIButton {
    
    var normalImage: UIImage?
    var highlightedImage: UIImage?
    
    override var selected: Bool {
        didSet {
            if selected {
                self.setImage(highlightedImage, forState: UIControlState.Normal)
                self.backgroundColor = UIColor.whiteColor()
            } else {
                self.setImage(normalImage, forState: UIControlState.Normal)
                self.backgroundColor = UIColor.clearColor()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(image: UIImage?, highlightedImage: UIImage?) {
        self.init(frame: CGRectZero)
        self.normalImage = image
        self.highlightedImage = highlightedImage
        self.setImage(image, forState: UIControlState.Normal)
        self.setBackgroundImage(UIImage(named: "WhiteBackground"), forState: UIControlState.Highlighted)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup() {
        self.layer.cornerRadius = 2
        self.layer.masksToBounds = true
    }
}
