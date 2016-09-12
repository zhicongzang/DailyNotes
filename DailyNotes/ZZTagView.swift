//
//  ZZTagView.swift
//  DailyNotes
//
//  Created by Zhicong Zang on 9/8/16.
//  Copyright © 2016 Zhicong Zang. All rights reserved.
//

import UIKit

class ZZTagView: UIView {
    
    static let XPadding: CGFloat = 6.0
    static let YPadding: CGFloat = 1.0
    
    private let textLabel = UILabel()
    
    var displayText: String = "" {
        didSet {
            updateLabelText()
            setNeedsDisplay()
        }
    }
    
    var font: UIFont? {
        didSet {
            textLabel.font = font
            setNeedsDisplay()
        }
    }
    
    var tagColor: UIColor! {
        didSet {
            updateContent(animated: false)
        }
    }
    
    var selectedColor: UIColor? {
        didSet {
            updateContent(animated: false)
        }
    }
    
    var textColor: UIColor? {
        didSet {
            updateContent(animated: false)
        }
    }
    
    var selectedTextColor: UIColor? {
        didSet {
            updateContent(animated: false)
        }
    }
    
    var onDidRequestDelete: ((tagView: ZZTagView, replacementText: String?) -> ())?
    var onDidRequestSelection: ((tagView: ZZTagView) -> ())?
    
    var selected: Bool = false {
        didSet {
            if selected && !isFirstResponder() {
                becomeFirstResponder()
            } else if !selected && isFirstResponder() {
                resignFirstResponder()
            }
            updateContent(animated: true)
        }
    }
    
    
    
    init(tag: ZZTag) {
        super.init(frame: CGRect.zero)
        backgroundColor = tagColor
        self.layer.cornerRadius = 3.0
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.blackColor().CGColor
        self.layer.borderWidth = 0.5
        
        
        textColor = .whiteColor()
        selectedColor = .grayColor()
        selectedTextColor = .blackColor()
        
        textLabel.frame = CGRect(x: ZZTagView.XPadding, y: ZZTagView.YPadding, width: 0, height: 0)
        textLabel.font = font
        textLabel.textColor = self.textColor
        textLabel.backgroundColor = .clearColor()
        self.addSubview(textLabel)
        
        self.displayText = tag.text
        updateLabelText()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureRecognizer))
        addGestureRecognizer(tapRecognizer)
        setNeedsLayout()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func updateContent(animated animated: Bool) {
        if animated {
            if selected {
                backgroundColor = selectedColor
                textLabel.textColor = selectedTextColor
            }
            UIView.animateWithDuration(
                0.03,
                animations: {
                    self.backgroundColor = self.selected ? self.selectedColor : self.tagColor
                    self.textLabel.textColor = self.selected ? self.selectedTextColor : self.textColor
                },
                completion: { finished in
                    if !self.selected {
                        self.backgroundColor = self.tagColor
                        self.textLabel.textColor = self.textColor
                    }
                }
            )
        } else {
            backgroundColor = selected ? selectedColor : self.tagColor
            textLabel.textColor = selected ? selectedTextColor : textColor
        }
    }
    
    override func intrinsicContentSize() -> CGSize {
        let labelIntrinsicSize = textLabel.intrinsicContentSize()
        return CGSize(width: labelIntrinsicSize.width + 2 * ZZTagView.XPadding, height: labelIntrinsicSize.height + 2 * ZZTagView.YPadding)
    }
    
    override func sizeThatFits(size: CGSize) -> CGSize {
        let fittingSize = CGSize(width: size.width - 2.0 * ZZTagView.XPadding, height: size.height - 2.0 * ZZTagView.YPadding)
        let labelSize = textLabel.sizeThatFits(fittingSize)
        return CGSize(width: labelSize.width + 2.0 * ZZTagView.YPadding, height: labelSize.height + 2.0 * ZZTagView.YPadding)
    }
    
    func sizeToFit(size: CGSize) -> CGSize {
        if self.frame.size.width > size.width {
            return CGSize(width: size.width, height: self.frame.size.height)
        }
        return self.frame.size
    }
    
    private func updateLabelText() {
        textLabel.text = displayText
        let intrinsicSize = intrinsicContentSize()
        self.frame = CGRect(x: 0, y: 0, width: intrinsicSize.width, height: intrinsicSize.height)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel.frame = CGRectInset(bounds, ZZTagView.XPadding, ZZTagView.YPadding)
        if frame.width == 0 || frame.height == 0 {
            frame.size = self.intrinsicContentSize()
        }
    }
    
    func handleTapGestureRecognizer(sender: UITapGestureRecognizer) {
        if let didRequestSelectionEvent = onDidRequestSelection {
            didRequestSelectionEvent(tagView: self)
        }
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func becomeFirstResponder() -> Bool {
        let didBecomeFirstResponder = super.becomeFirstResponder()
        selected = true
        return didBecomeFirstResponder
    }
    
    override func resignFirstResponder() -> Bool {
        let didResignFirstResponder = super.resignFirstResponder()
        selected = false
        return didResignFirstResponder
    }
    
}

extension ZZTagView: UIKeyInput {
    
    func hasText() -> Bool {
        return true
    }
    
    func insertText(text: String) {
        if let didRequestDeleteEvent = onDidRequestDelete {
            didRequestDeleteEvent(tagView: self, replacementText: text)
        }
    }
    
    func deleteBackward() {
        if let didRequestDeleteEvent = onDidRequestDelete {
            didRequestDeleteEvent(tagView: self, replacementText: nil)
        }
    }
}























