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

enum ZZPopOverTriangleAlignStyle {
    case AlignCenter
    case AlignUpOrLeft
    case AlignDownOrRight
    case AlignCustom(factor: CGFloat)
}

enum ZZPopOverSpecialStyle {
    case AlignHorizontalCenter(padding: CGFloat, fromTop: Bool, height: CGFloat)
    case AlignVerticalCenter(padding: CGFloat, fromLeft: Bool, width: CGFloat)
}

enum ZZPopOverContentsStyle {
    case None
    case ResizeToSameSize
}

class ZZPopOver: UIView {
    
    static let DefaultTriangleHeight: CGFloat = 8.0
    static let DefaultTriangleWidth: CGFloat = 10.0
    static let DefaultPopOverCornerRadius: CGFloat = 5.0
    static let DefaultPopOverShowAnimationDuration = 0.3
    static let DefaultPopOverDismissAnimationDuration = 0.3
    
    let popOverLayer: CAShapeLayer = CAShapeLayer()
    let contentView: UIView = UIView()
    
    var triangleHeight: CGFloat = DefaultTriangleHeight
    var triangleWidth: CGFloat = DefaultTriangleWidth
    var popOverCornerRadius: CGFloat = DefaultPopOverCornerRadius
    var direction: ZZPopOverDirection = .FromTop(padding: 10)
    var vertexOfTriangle: CGFloat = 0.0
    var popOverLayerBackgroundColor: UIColor = UIColor.grayColor() {
        didSet {
            if popOverLayerBackgroundColor != oldValue {
                popOverLayer.fillColor = popOverLayerBackgroundColor.CGColor
            }
        }
    }
    var contentLayerFrame: CGRect {
        get {
            switch self.direction {
            case .FromTop(_):
                return CGRect(x: 0, y: triangleHeight, width: contentView.frame.width, height: contentView.frame.height)
            case .FromButtom(_):
                return CGRect(x: 0, y: 0, width: contentView.frame.width, height: contentView.frame.height - triangleHeight)
            case .FromLeft(_):
                return CGRect(x: triangleHeight, y: 0, width: contentView.frame.width, height: contentView.frame.height)
            case .FromRight(_):
                return CGRect(x: 0, y: 0, width: contentView.frame.width - triangleHeight, height: contentView.frame.height)
            }
        }
        
    }
    
    init(holder: UIViewController, frame: CGRect, direction: ZZPopOverDirection, vertexOfTriangle: CGFloat) {
        super.init(frame: holder.view.frame)
        contentView.frame = frame
        self.addSubview(contentView)
        self.vertexOfTriangle = vertexOfTriangle
        self.direction = direction
        self.backgroundColor = UIColor.clearColor()
        holder.view.addSubview(self)
    }
    
    convenience init(sender: UIView, holder: UIViewController, size: CGSize, direction: ZZPopOverDirection, triangleAlignStyle: ZZPopOverTriangleAlignStyle) {
        let vertexOfTriangleFactor: CGFloat
        switch triangleAlignStyle {
        case .AlignCenter:
            vertexOfTriangleFactor = 0.5
        case .AlignUpOrLeft:
            vertexOfTriangleFactor = 0.25
        case .AlignDownOrRight:
            vertexOfTriangleFactor = 0.75
        case let .AlignCustom(factor):
            vertexOfTriangleFactor = min(max(factor, 0), 1)
        }
        let frame: CGRect
        let vertexOfTriangle: CGFloat
        let senderFrame = sender.superview!.convertRect(sender.frame, toView: holder.view)
        switch direction {
        case let .FromTop(padding):
            vertexOfTriangle = size.width * vertexOfTriangleFactor
            frame = CGRect(x: senderFrame.origin.x + senderFrame.width / 2 - vertexOfTriangle , y: senderFrame.maxY - holder.view.frame.minY + padding, width: size.width, height: size.height)
        case let .FromButtom(padding):
            vertexOfTriangle = size.width * vertexOfTriangleFactor
            frame = CGRect(x: senderFrame.origin.x + senderFrame.width  / 2 - vertexOfTriangle , y: senderFrame.minY - holder.view.frame.minY - padding - size.height, width: size.width, height: size.height)
        case let .FromLeft(padding):
            vertexOfTriangle = size.height * vertexOfTriangleFactor
            frame = CGRect(x: senderFrame.maxX - holder.view.frame.minX + padding, y: senderFrame.origin.y + senderFrame.height / 2 - vertexOfTriangle , width: size.width, height: size.height)
        case let .FromRight(padding):
            vertexOfTriangle = size.height * vertexOfTriangleFactor
            frame = CGRect(x: senderFrame.minX - holder.view.frame.minX - padding - size.width, y: senderFrame.origin.y + senderFrame.height / 2 - vertexOfTriangle , width: size.width, height: size.height)
        }
        self.init(holder: holder, frame: frame, direction: direction, vertexOfTriangle: vertexOfTriangle)
        
    }
    
    convenience init(sender: UIView, holder:UIViewController, paddingFromSender: CGFloat, style: ZZPopOverSpecialStyle) {
        switch style {
        case let .AlignHorizontalCenter(padding: padding, fromTop: fromTop, height: height):
            let size = CGSize(width: holder.view.frame.width - 2 * padding, height: height)
            let senderFrame = sender.superview!.convertRect(sender.frame, toView: holder.view)
            let vertexOfTriangleFactor: CGFloat = (senderFrame.origin.x + senderFrame.width / 2 - padding) / size.width
            if fromTop {
                self.init(sender: sender, holder: holder, size: size, direction: ZZPopOverDirection.FromTop(padding: paddingFromSender), triangleAlignStyle: ZZPopOverTriangleAlignStyle.AlignCustom(factor: vertexOfTriangleFactor))
            } else {
                self.init(sender: sender, holder: holder, size: size, direction: ZZPopOverDirection.FromButtom(padding: paddingFromSender), triangleAlignStyle: ZZPopOverTriangleAlignStyle.AlignCustom(factor: vertexOfTriangleFactor))
            }
        case let .AlignVerticalCenter(padding: padding, fromLeft: fromLeft, width: width):
            let size = CGSize(width: width, height: holder.view.frame.height - 2 * padding)
            let vertexOfTriangleFactor: CGFloat = (sender.frame.origin.y + sender.frame.height / 2 - padding) / size.height
            if fromLeft {
                self.init(sender: sender, holder: holder, size: size, direction: ZZPopOverDirection.FromLeft(padding: paddingFromSender), triangleAlignStyle: ZZPopOverTriangleAlignStyle.AlignCustom(factor: vertexOfTriangleFactor))
            } else {
                self.init(sender: sender, holder: holder, size: size, direction: ZZPopOverDirection.FromRight(padding: paddingFromSender), triangleAlignStyle: ZZPopOverTriangleAlignStyle.AlignCustom(factor: vertexOfTriangleFactor))
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupPopLayer() {
        let path: UIBezierPath
        switch direction {
        case .FromTop(_):
            path = UIBezierPath(roundedRect: contentLayerFrame, cornerRadius: popOverCornerRadius)
            let pathTriangle = UIBezierPath()
            let point0 = CGPoint(x: vertexOfTriangle - triangleWidth / 2, y: triangleHeight)
            let point1 = CGPoint(x: vertexOfTriangle, y: 0)
            let point2 = CGPoint(x: vertexOfTriangle + triangleWidth / 2, y: triangleHeight)
            pathTriangle.moveToPoint(point0)
            pathTriangle.addLineToPoint(point1)
            pathTriangle.addLineToPoint(point2)
            path.appendPath(pathTriangle)
        case .FromButtom(_):
            path = UIBezierPath(roundedRect: contentLayerFrame, cornerRadius: popOverCornerRadius)
            let pathTriangle = UIBezierPath()
            let point0 = CGPoint(x: vertexOfTriangle - triangleWidth / 2, y: contentView.frame.height - triangleHeight)
            let point1 = CGPoint(x: vertexOfTriangle, y: contentView.frame.height)
            let point2 = CGPoint(x: vertexOfTriangle + triangleWidth / 2, y: contentView.frame.height - triangleHeight)
            pathTriangle.moveToPoint(point0)
            pathTriangle.addLineToPoint(point1)
            pathTriangle.addLineToPoint(point2)
            path.appendPath(pathTriangle)
        case .FromLeft(_):
            path = UIBezierPath(roundedRect: contentLayerFrame, cornerRadius: popOverCornerRadius)
            let pathTriangle = UIBezierPath()
            let point0 = CGPoint(x: triangleHeight, y: vertexOfTriangle - triangleWidth / 2)
            let point1 = CGPoint(x: 0, y: vertexOfTriangle)
            let point2 = CGPoint(x: triangleHeight, y: vertexOfTriangle + triangleWidth / 2)
            pathTriangle.moveToPoint(point0)
            pathTriangle.addLineToPoint(point1)
            pathTriangle.addLineToPoint(point2)
            path.appendPath(pathTriangle)
        case .FromRight(_):
            path = UIBezierPath(roundedRect: contentLayerFrame, cornerRadius: popOverCornerRadius)
            let pathTriangle = UIBezierPath()
            let point0 = CGPoint(x: contentView.frame.width - triangleHeight, y: vertexOfTriangle - triangleWidth / 2)
            let point1 = CGPoint(x: contentView.frame.width, y: vertexOfTriangle)
            let point2 = CGPoint(x: contentView.frame.width - triangleHeight, y: vertexOfTriangle + triangleWidth / 2)
            pathTriangle.moveToPoint(point0)
            pathTriangle.addLineToPoint(point1)
            pathTriangle.addLineToPoint(point2)
            path.appendPath(pathTriangle)
        }
        popOverLayer.path = path.CGPath
        popOverLayer.fillColor = popOverLayerBackgroundColor.CGColor
        popOverLayer.strokeColor = popOverLayerBackgroundColor.CGColor
        self.contentView.layer.addSublayer(popOverLayer)
    }
    
    func showPopOver(animated animated: Bool, contents: [UIView]?, contentsStyle: ZZPopOverContentsStyle?) {
        setupPopLayer()
        setContents(contents, contentsStyle: contentsStyle)
        if animated {
            self.contentView.transform = CGAffineTransformMakeScale(1.1, 1.1)
            
            self.contentView.alpha = 0
            UIView.animateWithDuration(ZZPopOver.DefaultPopOverDismissAnimationDuration, delay: 0, options: .BeginFromCurrentState, animations: {
                self.contentView.transform = CGAffineTransformIdentity
                self.contentView.alpha = 1
                }, completion: nil)
        }
    }
    
    func dismiss() {
        UIView.animateWithDuration(ZZPopOver.DefaultPopOverDismissAnimationDuration, delay: 0, options: .BeginFromCurrentState, animations: {
            self.contentView.transform = CGAffineTransformMakeScale(0.9, 0.9)
            self.contentView.alpha = 0
            }, completion: { (finished) in
                self.removeFromSuperview()
        })
    }
    
    func setContents(contents: [UIView]?, contentsStyle: ZZPopOverContentsStyle?) {
        let style: ZZPopOverContentsStyle = contentsStyle ?? .None
        if let contents = contents where contents.count > 0{
            switch style {
            case .ResizeToSameSize:
                let frames = contentLayerFrame.splitToEqualSquaresByRow(count: contents.count, yGap: popOverCornerRadius / 2)
                (0..<contents.count).forEach({ (i) in
                    contents[i].frame = frames[i]
                })
            default:
                break
            }
            contents.forEach({ (content) in
                contentView.addSubview(content)
            })
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        touches.forEach { (touch) in
            let point = touch.locationInView(self)
            if !CGRectContainsPoint(contentView.frame, point) {
                dismiss()
            }
        }
        
    }
    

}


extension CGRect {
    func splitToEqualSquaresByRow(count count: Int, yGap: CGFloat) -> [CGRect] {
        let squareWidth = min(self.height - 2 * yGap, self.width/CGFloat(count * 2 + 1))
        var frames = [CGRect]()
        let y = (self.height - squareWidth) / 2
        let xGap = (self.width - CGFloat(count) * squareWidth) / CGFloat(count + 1)
        (0..<count).forEach { (i) in
            let frame = CGRect(x: self.origin.x + xGap * (CGFloat(i) + 1) + CGFloat(i) * squareWidth, y: self.origin.y + y, width: squareWidth, height: squareWidth)
            frames.append(frame)
        }
        return frames
    }
}



