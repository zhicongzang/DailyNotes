//
//  DetailCollectionViewCell.swift
//  DailyNotes
//
//  Created by Zhicong Zang on 8/3/16.
//  Copyright © 2016 Zhicong Zang. All rights reserved.
//

import UIKit

@objc protocol DetailCollectionViewCellDelegate {
    func moveBegin(cell: DetailCollectionViewCell)
    func cell(cell: DetailCollectionViewCell, completedWithRemove remove: Bool)
    func cell(cell: DetailCollectionViewCell, translated translation: CGPoint)
}

class DetailCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topLC: NSLayoutConstraint!
    @IBOutlet weak var leftLC: NSLayoutConstraint!
    
    weak var delegate: DetailCollectionViewCellDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(DetailCollectionViewCell.onPanGesture(_:)))
        panGesture.delegate = self
        self.contentView.addGestureRecognizer(panGesture)
    }
    
    func setImage(image: UIImage) {
        imageView.contentMode = .ScaleAspectFit
        imageView.image = image
    }

}

extension DetailCollectionViewCell: UIGestureRecognizerDelegate {
    @objc func onPanGesture(gesture:UIPanGestureRecognizer){
        func _angleForTranslate(translate:CGPoint) -> CGFloat {
            var angle : CGFloat = 0.0
            if translate.y < 0 {
                angle = 0.1 * abs(translate.y)
                angle = min(angle, 10.0)
                angle = max(angle, 0.0)
            }
            let radian = angle * CGFloat(M_PI) / 180.0
            return radian
        }
        if gesture.state == .Began {
            self.delegate?.moveBegin(self)
        } else if gesture.state == .Ended || gesture.state == .Cancelled {
            let translate = gesture.translationInView(self.contentView)
            if translate.y > -0.3 * self.bounds.size.height {
                UIView.animateWithDuration(0.3, animations: {
                    self.transform = CGAffineTransformIdentity
                    }, completion: { (finished) in
                        if finished {
                            self.delegate?.cell(self, completedWithRemove: false)
                        }
                })
            } else {
                UIView.animateWithDuration(0.3, animations: {
                    let targetOffsetX : CGFloat = translate.x > 0 ? self.bounds.size.width : -1 * self.bounds.size.width
                    let targetOffsetY : CGFloat = -1 * self.bounds.size.height
                    let translate_transform = CGAffineTransformMakeTranslation(targetOffsetX, targetOffsetY)
                    let radian : CGFloat = _angleForTranslate(translate) * 2.0
                    self.transform = CGAffineTransformRotate(translate_transform, radian)
                    self.alpha = 0.0
                    }, completion: { (finished) in
                        if finished {
                            self.delegate?.cell(self, completedWithRemove: true)
                        }
                })
            }
        } else if gesture.state == .Changed {
            let translate = gesture.translationInView(self.contentView)
            let translateTransform = CGAffineTransformMakeTranslation(translate.x, translate.y)
            let radian = _angleForTranslate(translate)
            self.transform = CGAffineTransformRotate(translateTransform, radian)
            self.delegate?.cell(self, translated: translate)
        }
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let panGesture = gestureRecognizer as? UIPanGestureRecognizer else {
            return true
        }
        let translate = panGesture.translationInView(self.contentView)
        return abs(translate.y) > abs(translate.x)
    }
}
