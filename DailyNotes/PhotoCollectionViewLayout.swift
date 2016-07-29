//
//  File.swift
//  DailyNotes
//
//  Created by Zhicong Zang on 7/28/16.
//  Copyright © 2016 Zhicong Zang. All rights reserved.
//

import UIKit

class PhotoCollectionViewLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        self.scrollDirection = .Horizontal
        self.minimumInteritemSpacing = 5
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.scrollDirection = .Horizontal
        self.minimumInteritemSpacing = 5
        
    }
    
    override func prepareLayout() {
        let photosCollectionView = collectionView!
        itemSize = CGSize(width: (photosCollectionView.frame.height - 10) / 4 * 3, height: photosCollectionView.frame.height - 10)
        sectionInset = UIEdgeInsetsMake(5, 5, 5, 5)
    }
    
    
}
