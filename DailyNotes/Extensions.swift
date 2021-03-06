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
    
    func setBorder() {
        self.layer.borderColor = UIColor.blackColor().CGColor
        self.layer.borderWidth = 2
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = true
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

extension UIView {
    func setupButtomDividingLine(lineWidth lineWidth: CGFloat, lineColor: CGColor) {
        let dividingLineLayer = CAShapeLayer()
        dividingLineLayer.frame = CGRect(x: 0, y: self.frame.height - lineWidth, width: self.frame.width, height: lineWidth)
        dividingLineLayer.backgroundColor = lineColor
        self.layer.addSublayer(dividingLineLayer)
    }
    
    func setupTopDividingLine(lineWidth lineWidth: CGFloat, lineColor: CGColor) {
        let dividingLineLayer = CAShapeLayer()
        dividingLineLayer.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: lineWidth)
        dividingLineLayer.backgroundColor = lineColor
        self.layer.addSublayer(dividingLineLayer)
    }
    
    func setupRightDividingLine(lineWidth lineWidth: CGFloat, lineColor: CGColor) {
        let dividingLineLayer = CAShapeLayer()
        dividingLineLayer.frame = CGRect(x: self.frame.width - lineWidth, y: 0, width: lineWidth, height: self.frame.height)
        dividingLineLayer.backgroundColor = lineColor
        self.layer.addSublayer(dividingLineLayer)
    }
    
    func setupLeftDividingLine(lineWidth lineWidth: CGFloat, lineColor: CGColor) {
        let dividingLineLayer = CAShapeLayer()
        dividingLineLayer.frame = CGRect(x: 0, y: 0, width: lineWidth, height: self.frame.height)
        dividingLineLayer.backgroundColor = lineColor
        self.layer.addSublayer(dividingLineLayer)
    }
}

extension NSDate {
    func toReminderDateString() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyy  hh:mm"
        return dateFormatter.stringFromDate(self)
    }
    
    func toReminderDateStringNoTime() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyy"
        return dateFormatter.stringFromDate(self)
    }
    
    func stringDaysToNow() -> String {
        let calendar : NSCalendar = NSCalendar.currentCalendar()
        let daysComponents = calendar.components([.Day], fromDate:  self, toDate: NSDate(), options: [] )
        let days = daysComponents.day
        if days == 0 {
            return "Today"
        }
        if days == 1 {
            return "\(days) day age"
        }
        return "\(days) days age"
        
    }
    
    func dateComponent()-> NSDateComponents{
        let calendarUnit: NSCalendarUnit = [.Minute, .Hour, .Day, .Month, .Year]
        let dateComponents = NSCalendar.currentCalendar().components(calendarUnit, fromDate: self)
        return dateComponents
    }
    
}

extension String {

    var removeHeadAndTailSpace:String {
        let whitespace = NSCharacterSet.whitespaceCharacterSet()
        return self.stringByTrimmingCharactersInSet(whitespace)
    }
    
    var removeHeadAndTailSpacePro:String {
        let whitespace = NSCharacterSet.whitespaceAndNewlineCharacterSet()
        return self.stringByTrimmingCharactersInSet(whitespace)
    }
    
    var removeAllSapce:String {
        return self.stringByReplacingOccurrencesOfString(" ", withString: "", options: .LiteralSearch, range: nil)
    }
    
    func beginSpaceNum(num: Int) -> String {
        var beginSpace = ""
        for _ in 0..<num {
            beginSpace += " "
        }
        return beginSpace + self.removeHeadAndTailSpacePro
    }
    
}

extension NSAttributedString {
    
    func heightWithConstrainedWidth(width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.max)
        let boundingBox = self.boundingRectWithSize(constraintRect, options: NSStringDrawingOptions.UsesLineFragmentOrigin, context: nil)
        return ceil(boundingBox.height)
    }
    
    func createImage(imageWidth width: CGFloat) -> UIImage {
        let size = CGSize(width: width, height: self.heightWithConstrainedWidth(width))
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        self.drawInRect(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
}













