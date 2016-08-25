//
//  NoteTableViewTitle.swift
//  DailyNotes
//
//  Created by Zhicong Zang on 8/24/16.
//  Copyright © 2016 Zhicong Zang. All rights reserved.
//

import UIKit


class NoteTableViewTitle: UIControl {
    
    var openImageView: UIImageView!
    
    var countLabel: UILabel!
    
    var titleLabel: UILabel!
    
    var isOpen = false {
        didSet {
            if isOpen {
                UIView.animateWithDuration(0.2, animations: {
                    self.openImageView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI)/2)
                })
            } else {
                UIView.animateWithDuration(0.2, animations: {
                    self.openImageView.transform = CGAffineTransformIdentity
                })
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
        backgroundColor = UIColor.whiteColor()
        self.setupButtomDividingLine(lineWidth: 0.5, lineColor: UIColor(white: 0.6, alpha: 1).CGColor)
        let imageView = UIImageView(frame: CGRect(x: 16, y: (frame.height - 20) / 2, width: 20, height: 20))
        imageView.image = UIImage(named: "Notes")
        titleLabel = UILabel(frame: CGRect(x: 36 + 8, y: 8, width: frame.width - 90, height: 21))
        titleLabel.lineBreakMode=NSLineBreakMode.ByTruncatingTail
        titleLabel.text = ""
        titleLabel.font = UIFont.systemFontOfSize(CGFloat(17))
        openImageView = UIImageView(frame: CGRect(x: frame.width - 15 - 31, y: (frame.height - 15) / 2, width: 15, height: 15))
        openImageView.image = UIImage(named: "Go")
        countLabel = UILabel(frame: CGRect(x: 36 + 8, y: 29, width: 50, height: 12))
        countLabel.text = "x Notes"
        countLabel.font = UIFont.systemFontOfSize(CGFloat(10))
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(openImageView)
        addSubview(countLabel)
    }
    
}
