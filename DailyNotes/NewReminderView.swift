//
//  NewReminderView.swift
//  DailyNotes
//
//  Created by Zhicong Zang on 7/26/16.
//  Copyright © 2016 Zhicong Zang. All rights reserved.
//

import UIKit

class NewReminderView: UIView {

    let contentView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        self.backgroundColor = UIColor(white: 0.6, alpha: 0.3)
        let contentViewWidth = frame.width / 4 * 3
        let contentViewHeight = contentViewWidth / 4 * 3
        contentView.frame = CGRect(x: (frame.width - contentViewWidth) / 2, y: (frame.height - contentViewHeight) / 2, width: contentViewWidth, height: contentViewHeight)
        self.contentView.backgroundColor = UIColor.yellowColor()
        self.addSubview(contentView)
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        
        
    }
    
    func dismiss() {
        UIView.animateWithDuration(ZZPopOver.DefaultPopOverDismissAnimationDuration, delay: 0, options: .BeginFromCurrentState, animations: {
            self.contentView.transform = CGAffineTransformMakeScale(0.9, 0.9)
            self.contentView.alpha = 0
            }, completion: { (finished) in
                self.removeFromSuperview()
        })
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        touches.forEach { (touch) in
            let point = touch.locationInView(self)
            if !CGRectContainsPoint(contentView.frame, point) {
                dismiss()
            }
        }
    }
    
    func show(holder holder: UIViewController, animated: Bool) {
        holder.view.addSubview(self)
        if animated {
            self.contentView.transform = CGAffineTransformMakeScale(1.1, 1.1)
            self.contentView.alpha = 0
            UIView.animateWithDuration(ZZPopOver.DefaultPopOverDismissAnimationDuration, delay: 0, options: .BeginFromCurrentState, animations: {
                self.contentView.transform = CGAffineTransformIdentity
                self.contentView.alpha = 1
                }, completion: nil)
        }
        
    }

}