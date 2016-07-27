//
//  Extensions.swift
//  DailyNotes
//
//  Created by Zhicong Zang on 7/26/16.
//  Copyright © 2016 Zhicong Zang. All rights reserved.
//

import UIKit


enum ChildViewControllerLayoutConstraints {
    case Constraints(top: CGFloat, buttom: CGFloat, left: CGFloat, right: CGFloat)
    case Equal
}

extension UIButton {
    convenience init(image: UIImage?) {
        self.init(frame: CGRectZero)
        self.setImage(image, forState: UIControlState.Normal)
    }
}

extension UIViewController {
    func configureChildViewController(childController childController: UIViewController, onView: UIView?, constraints: ChildViewControllerLayoutConstraints) {
        var holderView = self.view
        if let onView = onView {
            holderView = onView
        }
        addChildViewController(childController)
        holderView.addSubview(childController.view)
        switch constraints {
        case let .Constraints(top: top, buttom: buttom, left: left, right: right):
            constrainView(holderView: holderView, view: childController.view, toTop: top, toButtom: buttom, toLeft: left, toRight: right)
        case .Equal:
            constrainViewEqual(holderView, view: childController.view)
        }
        
        childController.didMoveToParentViewController(self)
    }
    
    func constrainViewEqual(holderView: UIView, view: UIView) {
        constrainView(holderView: holderView, view: view, toTop: nil, toButtom: nil, toLeft: nil, toRight: nil)
    }
    
    func constrainView(holderView holderView: UIView, view: UIView, toTop: CGFloat?, toButtom: CGFloat?, toLeft: CGFloat?, toRight: CGFloat?) {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let pinTop = NSLayoutConstraint(item: view, attribute: .Top, relatedBy: .Equal,
                                        toItem: holderView, attribute: .Top, multiplier: 1.0, constant: toTop ?? 0)
        let pinBottom = NSLayoutConstraint(item: view, attribute: .Bottom, relatedBy: .Equal,
                                           toItem: holderView, attribute: .Bottom, multiplier: 1.0, constant: -(toButtom ?? 0))
        let pinLeft = NSLayoutConstraint(item: view, attribute: .Left, relatedBy: .Equal,
                                         toItem: holderView, attribute: .Left, multiplier: 1.0, constant: toLeft ?? 0)
        let pinRight = NSLayoutConstraint(item: view, attribute: .Right, relatedBy: .Equal,
                                          toItem: holderView, attribute: .Right, multiplier: 1.0, constant: -(toRight ?? 0))
        
        holderView.addConstraints([pinTop, pinBottom, pinLeft, pinRight])
    }
}