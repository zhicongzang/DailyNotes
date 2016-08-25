//
//  RemindTableViewTitle.swift
//  DailyNotes
//
//  Created by Zhicong Zang on 8/16/16.
//  Copyright © 2016 Zhicong Zang. All rights reserved.
//

import UIKit


class RootTableViewTitle: UIControl {
    
    var openImageView: UIImageView!
    
    var countLabel: UILabel!
    
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
        setup("", imageName: "")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup("", imageName: "")
    }
    
    init(frame: CGRect, title: String, imageName: String) {
        super.init(frame: frame)
        setup(title, imageName: imageName)
    }
    
    func setup(title: String, imageName: String) {
        backgroundColor = UIColor.whiteColor()
        self.setupButtomDividingLine(lineWidth: 0.5, lineColor: UIColor(white: 0.6, alpha: 1).CGColor)
        let imageView = UIImageView(frame: CGRect(x: 10, y: (frame.height - 20) / 2, width: 20, height: 20))
        imageView.image = UIImage(named: imageName)
        let label = UILabel(frame: CGRect(x: 30 + 8, y: 0, width: frame.width / 2, height: frame.height))
        label.text = title
        label.font = UIFont.systemFontOfSize(CGFloat(22))
        openImageView = UIImageView(frame: CGRect(x: frame.width - 15 - 10, y: (frame.height - 15) / 2, width: 15, height: 15))
        openImageView.image = UIImage(named: "Go")
        countLabel = UILabel(frame: CGRect(x: frame.width - 25 - 5 - 50, y: 0, width: 50, height: frame.height))
        countLabel.text = "All xxx"
        countLabel.textAlignment = .Right
        countLabel.font = UIFont.systemFontOfSize(CGFloat(13))
        addSubview(imageView)
        addSubview(label)
        addSubview(openImageView)
        addSubview(countLabel)
    }

}
