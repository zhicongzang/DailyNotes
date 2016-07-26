//
//  RootButton.swift
//  DailyNotes
//
//  Created by Zhicong Zang on 7/20/16.
//  Copyright © 2016 Zhicong Zang. All rights reserved.
//

import UIKit

class RootButton: UIButton {
    
    let AnimationDuration = 0.1
    let AnimationScale:CGFloat = 0.85
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(frame: CGRect, image: UIImage?) {
        super.init(frame: frame)
        self.setImage(image, forState: UIControlState.Normal)
    }
    
    init(image: UIImage?) {
        super.init(frame: CGRectZero)
        self.setImage(image, forState: UIControlState.Normal)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        UIView.animateKeyframesWithDuration(AnimationDuration, delay: 0, options: UIViewKeyframeAnimationOptions.BeginFromCurrentState, animations: {
            self.layer.setAffineTransform(CGAffineTransformMakeScale(self.AnimationScale, self.AnimationScale))
            }, completion: nil)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        UIView.animateKeyframesWithDuration(AnimationDuration, delay: 0, options: UIViewKeyframeAnimationOptions.BeginFromCurrentState, animations: {
            self.layer.setAffineTransform(CGAffineTransformIdentity)
            }, completion: nil)
    }
}

