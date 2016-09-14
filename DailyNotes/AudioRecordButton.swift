//
//  AudioRecordButton.swift
//  DailyNotes
//
//  Created by Zhicong Zang on 9/14/16.
//  Copyright © 2016 Zhicong Zang. All rights reserved.
//

import UIKit

class AudioRecordButton: UIButton {
    
    var topLayer: CALayer!
    
    var isRecording = false {
        didSet {
            if oldValue != isRecording {
                if isRecording {
                    UIView.animateWithDuration(0.3, animations: {
                        self.topLayer.frame = CGRect(x: 8, y: 8, width: self.frame.width - 16, height: self.frame.height - 16)
                        self.topLayer.cornerRadius = 2
                        }, completion: nil)
                } else {
                    UIView.animateWithDuration(0.3, animations: {
                        self.topLayer.frame = CGRect(x: 4, y: 4, width: self.frame.width - 8, height: self.frame.height - 8)
                        self.topLayer.cornerRadius = self.topLayer.frame.width / 2
                        }, completion: nil)
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        self.backgroundColor = UIColor.blackColor()
        self.layer.cornerRadius = frame.width / 2
        self.layer.masksToBounds = true
        let midLayer = CAShapeLayer()
        
        midLayer.path = UIBezierPath(arcCenter: CGPoint(x: self.frame.width / 2, y: self.frame.height / 2), radius: self.frame.width / 2 - 3, startAngle: 0, endAngle: 2 * CGFloat(M_PI), clockwise: true).CGPath
        midLayer.fillColor = UIColor.whiteColor().CGColor
        self.layer.addSublayer(midLayer)
        topLayer = CALayer()
        topLayer.backgroundColor = UIColor.redColor().CGColor
        topLayer.frame = CGRect(x: 4, y: 4, width: self.frame.width - 8, height: self.frame.height - 8)
        topLayer.cornerRadius = topLayer.frame.width / 2
        topLayer.masksToBounds = true
        self.layer.addSublayer(topLayer)
    }
    
}
