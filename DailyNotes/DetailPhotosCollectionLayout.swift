//
//  DetailPhotosCollectionLayout.swift
//  DailyNotes
//
//  Created by Zhicong Zang on 8/2/16.
//  Copyright © 2016 Zhicong Zang. All rights reserved.
//

import UIKit

class DetailPhotosCollectionLayoutAttributes: UICollectionViewLayoutAttributes {
    var ratio: CGFloat! {
        didSet {
            let scale = max(min(1.1, ratio), 0.0)
            let transformScale = CGAffineTransformMakeScale(scale, scale)
            if ratio > 1 {
                let translate: CGFloat
                if ratio >= 1.1 {
                    translate = -1.0 * (screenWidth / 2.0 + self.cardWidth / 2.0)
                } else {
                    let t = -1.0 * (ratio - floor(ratio)) * pageDistance * 10.0
                    translate = t != 0 ? t : -pageDistance
                }
                self.transform = CGAffineTransformTranslate(transformScale, translate, 0)
            } else {
                self.transform = transformScale
            }
        }
    }
    
    var pageDistance: CGFloat!
    var cardWidth: CGFloat!
    var cardHeight: CGFloat!
    
    override func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = super.copyWithZone(zone) as! DetailPhotosCollectionLayoutAttributes
        copy.pageDistance = self.pageDistance
        copy.cardWidth = self.cardWidth
        copy.cardHeight = self.cardHeight
        copy.ratio = self.ratio
        return copy
    }
    
    class func attribuatesForIndexPath(indexPath:NSIndexPath, pageDistance:CGFloat, cardWidth:CGFloat, cardHeight: CGFloat) -> DetailPhotosCollectionLayoutAttributes{
        let attributes = DetailPhotosCollectionLayoutAttributes(forCellWithIndexPath: indexPath)
        attributes.pageDistance = pageDistance
        attributes.cardWidth = cardWidth
        attributes.cardHeight = cardHeight
        return attributes
    }
}

class DetailPhotosCollectionLayout: UICollectionViewFlowLayout {
    let pageDistance = ceil(screenWidth * 1.1)
    let cardWidth = DetailCellWidth
    let cardHeight = DetailCellHeight
    private var attributesList : [UICollectionViewLayoutAttributes] = []
    private var targetOffsetX: CGFloat = 0.0
    override init() {
        super.init()
        self.scrollDirection = .Horizontal
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.scrollDirection = .Horizontal
    }
    
    override func collectionViewContentSize() -> CGSize {
        let numberOfItems = self.collectionView!.numberOfItemsInSection(0)
        return CGSizeMake(self.pageDistance * CGFloat(numberOfItems) + self.collectionView!.bounds.width, self.collectionView!.bounds.width)
    }
    
    override func prepareLayout() {
        super.prepareLayout()
        var array: [UICollectionViewLayoutAttributes] = []
        let numberOfItems = self.collectionView!.numberOfItemsInSection(0)
        let offsetX = self.collectionView!.contentOffset.x
        let centerX = self.collectionView!.bounds.width / 2.0 + offsetX
        let centerY = self.collectionView!.bounds.height / 2.0
        let center = CGPointMake(centerX, centerY)
        let bounds = CGRectMake(0.0, 0.0, self.cardWidth, self.cardHeight)
        for index in 0..<numberOfItems {
            let ratio = 1.0 - (CGFloat(index) * 0.2) + (offsetX / pageDistance) * 0.2
            let indexPath = NSIndexPath(forItem: index, inSection: 0)
            let attributes = DetailPhotosCollectionLayoutAttributes.attribuatesForIndexPath(indexPath, pageDistance: pageDistance, cardWidth: cardWidth, cardHeight: cardHeight)
            attributes.center = center
            attributes.bounds = bounds
            attributes.zIndex = 10000 - index
            attributes.ratio = ratio
            array.append(attributes)
        }
        self.attributesList = array
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return self.attributesList
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        return self.attributesList[indexPath.row]
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    override class func layoutAttributesClass() -> AnyClass {
        return DetailPhotosCollectionLayout.self
    }
    
    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        var targetContentOffset = proposedContentOffset
        if abs(self.collectionView!.contentOffset.x - proposedContentOffset.x) >= 30 {
            if velocity.x > 0 {
                self.targetOffsetX += self.pageDistance
            } else {
                self.targetOffsetX -= self.pageDistance
            }
            self.targetOffsetX = max(self.targetOffsetX, 0.0)
            self.targetOffsetX = min(self.collectionView!.contentSize.width - self.collectionView!.bounds.width, self.targetOffsetX)
        }
        targetContentOffset.x = self.targetOffsetX
        return targetContentOffset
    }
    
    
}












