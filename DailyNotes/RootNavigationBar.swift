//
//  RootNavigationBar.swift
//  DailyNotes
//
//  Created by Zhicong Zang on 7/20/16.
//  Copyright © 2016 Zhicong Zang. All rights reserved.
//

import UIKit

class RootNavigationBar: UINavigationBar {
    
    let logoImageWidth: CGFloat = 20
    let logoImageHeight: CGFloat = 20
    let logoImageAlpha: CGFloat = 0.3

    var logoImageView = UIImageView()
    
    var hideLogo = false {
        didSet {
            logoImageView.hidden = hideLogo
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        logoImageView.frame = CGRect(x: (screenWidth - logoImageWidth) / 2, y: (self.frame.height - logoImageHeight) / 2, width: logoImageWidth, height: logoImageHeight)
        logoImageView.image = UIImage(named: "Logo")
        logoImageView.alpha = logoImageAlpha
        self.addSubview(logoImageView)
        translucent = false
        
    }
    
    

}
