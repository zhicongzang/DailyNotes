//
//  ZZTagsField.swift
//  TestZZTagsField
//
//  Created by ZZC on 9/8/16.
//  Copyright © 2016 Zhicong Zang. All rights reserved.
//

import UIKit

class ZZTagsField: UIView {

    private let textField = BackspaceDetectingTextField()
    
    var views:[String: AnyObject] = [:]
    var viewsLayoutH = [NSLayoutConstraint]()
    var viewsLayoutV = [String: [NSLayoutConstraint]]()
    
    @IBInspectable var tagColor: UIColor! {
        didSet {
            tagViews.forEach() { item in
                item.tagColor = self.tagColor
            }
        }
    }
    
    @IBInspectable var textColor: UIColor? {
        didSet {
            tagViews.forEach() { item in
                item.textColor = self.textColor
            }
        }
    }
    
    @IBInspectable var selectedColor: UIColor? {
        didSet {
            tagViews.forEach() { item in
                item.selectedColor = self.selectedColor
            }
        }
    }
    
    @IBInspectable var selectedTextColor: UIColor? {
        didSet {
            tagViews.forEach() { item in
                item.selectedTextColor = self.selectedTextColor
            }
        }
    }
    
    @IBInspectable var fieldTextColor: UIColor? {
        didSet {
            textField.textColor = textColor
        }
    }
    
    @IBInspectable var placeholder: String = "Tags" {
        didSet {
            updatePlaceholderTextVisibility()
        }
    }
    
    @IBInspectable var fontSize: CGFloat = 17.0 {
        didSet {
            font = UIFont(name: fontFamily, size: fontSize)
        }
    }
    
    @IBInspectable var fontFamily: String = UIFont.systemFontOfSize(17).familyName {
        didSet {
            font = UIFont(name: fontFamily, size: fontSize)
        }
    }
    
    var font: UIFont? {
        didSet {
            textField.font = font
            tagViews.forEach() { item in
                item.font = self.font
            }
        }
    }
    
    @IBInspectable var readOnly: Bool = false {
        didSet {
            unselectAllTagViews()
            textField.enabled = !readOnly
            repositionViews()
        }
    }
    
    @IBInspectable var spaceBetweenTags: CGFloat = 2.0 {
        didSet {
            repositionViews()
        }
    }
    
    @IBInspectable var keyboardType: UIKeyboardType {
        get {
            return textField.keyboardType
        }
        
        set {
            textField.keyboardType = newValue
        }
    }
    
    @IBInspectable var textFieldWidth: CGFloat = 10.0 {
        didSet {
            textField.width = textFieldWidth
            repositionViews()
        }
    }
    
    private(set) var tags = [ZZTag]()
    private var tagViews = [ZZTagView]()
    
    var onDidEndEditing: ((ZZTagsField) -> Void)?
    
    var onDidBeginEditing: ((ZZTagsField) -> Void)?
    
    var onShouldReturn: ((ZZTagsField) -> Bool)?
    
    var onDidChangeText: ((ZZTagsField, text: String?) -> Void)?
    
    var onDidAddTag: ((ZZTagsField, tag: ZZTag) -> Void)?
    
    var onDidRemoveTag: ((ZZTagsField, tag: ZZTag) -> Void)?
    
    var onVerifyTag: ((ZZTagsField, text: String) -> Bool)?
    
    var onDidChangeHeightTo: ((ZZTagsField, height: CGFloat) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        textColor = .whiteColor()
        selectedColor = .grayColor()
        selectedTextColor = .blackColor()
        
        textField.autocorrectionType = UITextAutocorrectionType.No
        textField.autocapitalizationType = UITextAutocapitalizationType.None
        textField.delegate = self
        textField.font = font
        textField.textColor = fieldTextColor
        textField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textField)
        
        textField.onDeleteBackwards = {
            if self.readOnly {
                return
            }
            if self.textField.text?.isEmpty ?? true, let tagView = self.tagViews.last {
                self.selectTagView(tagView, animated: true)
                self.textField.resignFirstResponder()
            }
        }
        
        views["textField"] = textField
        let textFieldLCV = NSLayoutConstraint.constraintsWithVisualFormat("V:|-\(spaceBetweenTags)-[textField]-\(spaceBetweenTags)-|", options: [], metrics: nil, views: views)
        viewsLayoutV["textField"] = textFieldLCV
        
        textField.addTarget(self, action: #selector(onTextFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        updatePlaceholderTextVisibility()
        repositionViews()
    }
    
    override func intrinsicContentSize() -> CGSize {
        if tagViews.count > 0 {
            var width: CGFloat = 0
            tagViews.forEach({ (view) in
                width += view.intrinsicContentSize().width
            })
            return CGSize(width: width + CGFloat(tagViews.count + 2) * spaceBetweenTags + textField.intrinsicContentSize().width, height: tagViews.first!.intrinsicContentSize().height + 2 * spaceBetweenTags)
        }
        let tagView = ZZTagView(tag: ZZTag(text: "Z"))
        tagView.font = self.font
        let tagViewSize = tagView.intrinsicContentSize()
        return CGSize(width: tagViewSize.width + 3 * spaceBetweenTags + textField.intrinsicContentSize().width, height: tagViewSize.height + 2 * spaceBetweenTags)
        
    }

    

    
    func repositionViews() {
        NSLayoutConstraint.deactivateConstraints(viewsLayoutH)
        NSLayoutConstraint.deactivateConstraints(viewsLayoutV.values.flatMap{$0})
        var vfl = "H:|"
        for i in 0..<tags.count {
            vfl += "-\(spaceBetweenTags)-[Z\(tags[i].text)]"
        }
        vfl += "-\(spaceBetweenTags)-[textField]-\(spaceBetweenTags)-|"
        viewsLayoutH = NSLayoutConstraint.constraintsWithVisualFormat(vfl, options: [], metrics: nil, views: views)
        NSLayoutConstraint.activateConstraints(viewsLayoutH)
        NSLayoutConstraint.activateConstraints(viewsLayoutV.values.flatMap{$0})
    }
    
    private func updatePlaceholderTextVisibility() {
        if tags.count > 0 {
            textField.placeholder = nil
        }
        else {
            textField.placeholder = self.placeholder
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tagViews.forEach {
            $0.setNeedsLayout()
        }
        repositionViews()
    }
    
    func acceptCurrentTextAsTag() {
        if let currentText = tokenizeTextFieldText() where (self.textField.text?.isEmpty ?? true) == false {
            self.addTag(currentText)
        }
    }
    
    var isEditing: Bool {
        return self.textField.editing
    }
    
    func beginEditing() {
        self.textField.becomeFirstResponder()
        self.unselectAllTagViews()
    }
    
    func endEditing() {
        self.textField.resignFirstResponder()
    }
    
    func addTags(tags: [String]) {
        tags.forEach() { addTag($0) }
    }
    
    func addTags(tags: [ZZTag]) {
        tags.forEach() { addTag($0) }
    }
    
    func addTag(tag: String) {
        addTag(ZZTag(text: tag))
    }
    
    func addTag(tag: ZZTag) {
        if self.tags.contains(tag) {
            return
        }
        self.tags.append(tag)
        
        let tagView = ZZTagView(tag: tag)
        tagView.font = self.font
        tagView.tagColor = self.tagColor
        tagView.textColor = self.textColor
        tagView.selectedColor = self.selectedColor
        tagView.selectedTextColor = self.selectedTextColor
        
        tagView.onDidRequestSelection = { tagView in
            self.selectTagView(tagView, animated: true)
        }
        
        tagView.onDidRequestDelete  = { tagView, replacementText in
            self.textField.becomeFirstResponder()
            if !(replacementText?.isEmpty ?? true) {
                self.textField.text = replacementText
            }
            if let index = self.tagViews.indexOf(tagView) {
                self.removeTagAtIndex(index)
            }
        }
        tagView.translatesAutoresizingMaskIntoConstraints = false
        
        self.tagViews.append(tagView)
        addSubview(tagView)
        
        self.textField.text = ""
        if let didAddTagEvent = onDidAddTag {
            didAddTagEvent(self, tag: tag)
        }
        
        views["Z" + tag.text] = tagView
        viewsLayoutV["Z" + tag.text] = NSLayoutConstraint.constraintsWithVisualFormat("V:|-\(spaceBetweenTags)-[Z\(tag.text)]-\(spaceBetweenTags)-|", options: [], metrics: nil, views: views)
        
        onTextFieldDidChange(self.textField)
        repositionViews()
        updatePlaceholderTextVisibility()
    }
    
    func removeTag(tag: String) {
        removeTag(ZZTag(text: tag))
    }
    
    func removeTag(tag: ZZTag) {
        if let index = self.tags.indexOf(tag) {
            removeTagAtIndex(index)
        }
    }
    
    func removeTagAtIndex(index: Int) {
        if index >= 0 && index < self.tagViews.count {
            let tagView = self.tagViews[index]
            tagView.removeFromSuperview()
            self.tagViews.removeAtIndex(index)
            let removedTag = self.tags[index]
            self.tags.removeAtIndex(index)
            if let didRemoveTagEvent = onDidRemoveTag {
                didRemoveTagEvent(self, tag: removedTag)
            }
            views["Z" + removedTag.text] = nil
            viewsLayoutV["Z" + removedTag.text] = nil
            
            updatePlaceholderTextVisibility()
            repositionViews()
        }
    }
    
    func removeTags() {
        self.tags.enumerate().reverse().forEach { (index, _) in
            removeTagAtIndex(index)
        }
    }
    
    func onTextFieldDidChange(sender: AnyObject) {
        if let didChangeTextEvent = onDidChangeText {
            didChangeTextEvent(self, text: textField.text)
        }
    }
    
    func tokenizeTextFieldText() -> ZZTag? {
        let text = self.textField.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) ?? ""
        if !text.isEmpty && (onVerifyTag?(self, text: text) ?? true) {
            let tag = ZZTag(text: text)
            addTag(tag)
            self.textField.text = ""
            onTextFieldDidChange(self.textField)
            return tag
        }
        return nil
    }
    
    func selectTagView(tagView: ZZTagView, animated: Bool = false) {
        if readOnly {
            return
        }
        tagView.selected = true
        tagViews.forEach { (view) in
            if view != tagView {
                view.selected = false
            }
        }
    }
    
    func unselectAllTagViews(animated animated: Bool = false) {
        tagViews.forEach() { item in
            item.selected = false
        }
    }
    
    override func resignFirstResponder() -> Bool {
        tagViews.forEach { (view) in
            view.resignFirstResponder()
        }
        textField.resignFirstResponder()
        return true
    }
    

}

extension ZZTagsField: UITextFieldDelegate {
    func textFieldDidBeginEditing(textField: UITextField) {
        if let didBeginEditingEvent = onDidBeginEditing {
            didBeginEditingEvent(self)
        }
        unselectAllTagViews()
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if let didEndEditingEvent = onDidEndEditing {
            didEndEditingEvent(self)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        tokenizeTextFieldText()
        var shouldDoDefaultBehavior = false
        if let shouldReturnEvent = onShouldReturn {
            shouldDoDefaultBehavior = shouldReturnEvent(self)
        }
        return shouldDoDefaultBehavior
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}

private class BackspaceDetectingTextField: UITextField {
    
    var width: CGFloat = 10.0
    
    var onDeleteBackwards: (() -> ())?
    
    init() {
        super.init(frame: CGRectZero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func deleteBackward() {
        if let deleteBackwardsEvent = onDeleteBackwards {
            deleteBackwardsEvent()
        }
        super.deleteBackward()
    }
    
    private override func intrinsicContentSize() -> CGSize {
        return CGSize(width: width, height: super.intrinsicContentSize().height)
    }
    
    
}
