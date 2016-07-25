//
//  ZZPopOver.swift
//  DailyNotes
//
//  Created by Zhicong Zang on 7/21/16.
//  Copyright © 2016 Zhicong Zang. All rights reserved.
//

import UIKit

enum ZZPopOverDirection {
    case FromTop(padding: CGFloat)
    case FromButtom(padding: CGFloat)
    case FromLeft(padding: CGFloat)
    case FromRight(padding: CGFloat)
}

class ZZPopOver: UIView {
    
    let DefaultTriangleHeight: CGFloat = 8.0
    let DefaultTriangleWidth: CGFloat = 10.0
    let DefaultPopOverCornerRadius: CGFloat = 5.0
    
    let popOverLayer: CAShapeLayer = CAShapeLayer()
    
    var direction: ZZPopOverDirection = .FromTop(padding: 10)
    var vertexOfTriangle: CGFloat = 0.0
    var popOverLayerBackgroundColor: UIColor = UIColor.grayColor() {
        didSet {
            if popOverLayerBackgroundColor != oldValue {
                popOverLayer.fillColor = popOverLayerBackgroundColor.CGColor
            }
        }
    }
    
    
    override init(frame: CGRect) {
        vertexOfTriangle = frame.width / 2
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        setupPopLayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(sender: UIView, size: CGSize, direction: ZZPopOverDirection) {
        
        let frame: CGRect
        switch direction {
        case let .FromTop(padding):
            frame = CGRect(x: sender.frame.origin.x + (sender.frame.width - size.width) / 2, y: sender.frame.maxY + padding, width: size.width, height: size.height)
        case let .FromButtom(padding):
            frame = CGRect(x: sender.frame.origin.x + (sender.frame.width - size.width) / 2, y: sender.frame.minY - padding - size.height, width: size.width, height: size.height)
        case let .FromLeft(padding):
            frame = CGRect(x: sender.frame.maxX + padding, y: sender.frame.origin.y + (sender.frame.height - size.height) / 2, width: size.width, height: size.height)
        case let .FromRight(padding):
            frame = CGRect(x: sender.frame.minX - padding - size.width, y: sender.frame.origin.y + (sender.frame.height - size.height) / 2, width: size.width, height: size.height)
        }
        super.init(frame: frame)
        self.vertexOfTriangle = frame.width / 2
        self.direction = direction
        self.backgroundColor = UIColor.clearColor()
        setupPopLayer()
        sender.superview?.addSubview(self)
    }
    
//    func setupPopLayer() {
//        let point0 = CGPoint(x: vertexOfTriangle, y: 0)
//        let point1 = CGPoint(x: vertexOfTriangle - 0.5 * DefaultTriangleWidth, y: DefaultTriangleHeight)
//        let point2 = CGPoint(x: DefaultPopOverCornerRadius, y: DefaultTriangleHeight)
//        let point2_center = CGPoint(x: DefaultPopOverCornerRadius, y: DefaultTriangleHeight + DefaultPopOverCornerRadius)
//        let point3 = CGPoint(x: 0, y: frame.height - DefaultPopOverCornerRadius)
//        let point3_center = CGPoint(x: DefaultPopOverCornerRadius, y: frame.height - DefaultPopOverCornerRadius)
//        let point4 = CGPoint(x: frame.width - DefaultPopOverCornerRadius, y: frame.height)
//        let point4_center = CGPoint(x: frame.width - DefaultPopOverCornerRadius, y: frame.height - DefaultPopOverCornerRadius)
//        let point5 = CGPoint(x: frame.width, y: DefaultTriangleHeight + DefaultPopOverCornerRadius)
//        let point5_center = CGPoint(x: frame.width - DefaultPopOverCornerRadius, y: DefaultTriangleHeight + DefaultPopOverCornerRadius)
//        let point6 = CGPoint(x: vertexOfTriangle + 0.5 * DefaultTriangleWidth, y: DefaultTriangleHeight)
//        
//        let path = UIBezierPath()
//        path.moveToPoint(point0)
//        path.addLineToPoint(point1)
//        path.addLineToPoint(point2)
//        path.addArcWithCenter(point2_center, radius: DefaultPopOverCornerRadius, startAngle: 3 * CGFloat(M_PI_2), endAngle: CGFloat(M_PI), clockwise: false)
//        path.addLineToPoint(point3)
//        path.addArcWithCenter(point3_center, radius: DefaultPopOverCornerRadius, startAngle: CGFloat(M_PI), endAngle: CGFloat(M_PI_2), clockwise: false)
//        path.addLineToPoint(point4)
//        path.addArcWithCenter(point4_center, radius: DefaultPopOverCornerRadius, startAngle: CGFloat(M_PI_2), endAngle: 0, clockwise: false)
//        path.addLineToPoint(point5)
//        path.addArcWithCenter(point5_center, radius: DefaultPopOverCornerRadius, startAngle: 0, endAngle: 3 * CGFloat(M_PI_2), clockwise: false)
//        path.addLineToPoint(point6)
//        
//        popOverLayer.path = path.CGPath
//        popOverLayer.fillColor = popOverLayerBackgroundColor.CGColor
//        
//        self.layer.addSublayer(popOverLayer)
//    }
    
    func setupPopLayer() {
        let path: UIBezierPath
        switch direction {
        case .FromTop(_):
            path = UIBezierPath(roundedRect: CGRect(x: 0, y: DefaultTriangleHeight, width: frame.width, height: frame.height), cornerRadius: DefaultPopOverCornerRadius)
        case .FromButtom(_):
            path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0 , width: frame.width, height: frame.height - DefaultTriangleHeight), cornerRadius: DefaultPopOverCornerRadius)
        case .FromLeft(_):
            path = UIBezierPath(roundedRect: CGRect(x: DefaultTriangleHeight, y: 0, width: frame.width, height: frame.height), cornerRadius: DefaultPopOverCornerRadius)
        case .FromRight(_):
            path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: frame.width - DefaultTriangleHeight, height: frame.height), cornerRadius: DefaultPopOverCornerRadius)
        }
        popOverLayer.path = path.CGPath
        popOverLayer.fillColor = popOverLayerBackgroundColor.CGColor
        
        self.layer.addSublayer(popOverLayer)
    }

    
    
    
    
    

}





























