//
//  NewNoteViewController.swift
//  DailyNotes
//
//  Created by Zhicong Zang on 7/21/16.
//  Copyright © 2016 Zhicong Zang. All rights reserved.
//

import UIKit

class NewNoteViewController: UIViewController {

    @IBOutlet weak var keyboardButton: KeyboardButton!
    @IBOutlet weak var subjectTextField: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var toolBarView: UIView!
    @IBOutlet weak var subjectTextFieldView: UIView!
    
    @IBOutlet weak var toolBarLayoutConstraint: NSLayoutConstraint!
    
    let alignLeftButton = FontSettingButton(image: UIImage(named: "AlignLeft"), highlightedImage: UIImage(named: "AlignLeftHighlight"))
    let alignCenterButton = FontSettingButton(image: UIImage(named: "AlignCenter"), highlightedImage: UIImage(named: "AlignCenterHighlight"))
    let alignRightButton = FontSettingButton(image: UIImage(named: "AlignRight"), highlightedImage: UIImage(named: "AlignRightHighlight"))
    let textBackgroundColorButton = FontSettingButton(image: UIImage(named: "TextBackgroundColor"), highlightedImage: UIImage(named: "TextBackgroundColorHighlight"))
    let fontStrikethroughButton = FontSettingButton(image: UIImage(named: "FontStrikethrough"), highlightedImage: UIImage(named: "FontStrikethroughHighlight"))
    let fontUnderlineButton = FontSettingButton(image: UIImage(named: "FontUnderline"), highlightedImage: UIImage(named: "FontUnderlineHighlight"))
    let fontItalicButton = FontSettingButton(image: UIImage(named: "FontItalic"), highlightedImage: UIImage(named: "FontItalicHighlight"))
    let fontBoldButton = FontSettingButton(image: UIImage(named: "FontBold"), highlightedImage: UIImage(named: "FontBoldHighlight"))
    
    let bulletedListButton = FontSettingButton(image: UIImage(named: "BulletedList"), highlightedImage: UIImage(named: "BulletedListHighlight"))
    let todoListButton = FontSettingButton(image: UIImage(named: "TodoList"), highlightedImage: UIImage(named: "TodoListHighlight"))
    let numberedListButton = FontSettingButton(image: UIImage(named: "NumberedList"), highlightedImage: UIImage(named: "NumberedListHighlight"))
    
    
    var fontSettingButtons: [UIButton] {
        get {
            return [alignLeftButton, alignCenterButton, alignRightButton, textBackgroundColorButton, fontStrikethroughButton, fontUnderlineButton, fontItalicButton, fontBoldButton]
        }
    }
    
    var listSettingButtons: [UIButton] {
        get {
            return [bulletedListButton, numberedListButton, todoListButton]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        subjectTextFieldView.setupButtomDividingLine(lineWidth: 0.5, lineColor: UIColor(white: 0.6, alpha: 1).CGColor)
        toolBarView.setupButtomDividingLine(lineWidth: 0.5, lineColor: UIColor(white: 0.6, alpha: 1).CGColor)
        toolBarView.setupTopDividingLine(lineWidth: 0.5, lineColor: UIColor(white: 0.6, alpha: 1).CGColor)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NewNoteViewController.keyboardWillChangeFrame(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NewNoteViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NewNoteViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func keyboardWillChangeFrame(notification: NSNotification) {
        if let userInfo = notification.userInfo,
            value = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue,
            duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double,
            curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? UInt {
            
            let frame = value.CGRectValue()
            let intersection = CGRectIntersection(frame, self.view.frame)
            
            
            self.toolBarLayoutConstraint.constant = CGRectGetHeight(intersection)
            
            UIView.animateWithDuration(duration, delay: 0.0,
                                       options: UIViewAnimationOptions(rawValue: curve), animations: {
                                        _ in
                                        self.view.layoutIfNeeded()
                }, completion: nil)
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        keyboardButton.isTyping = true
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        keyboardButton.isTyping = false
    }
    
    @IBAction func keyboardButtonPressed(sender: KeyboardButton) {
        if sender.isTyping {
            subjectTextField.resignFirstResponder()
            textView.resignFirstResponder()
        } else {
            textView.becomeFirstResponder()
        }
    }
    
    @IBAction func textFieldDoneEditing(sender: AnyObject) {
        if let control = sender as? UIControl {
            control.resignFirstResponder()
        }
    }

    @IBAction func cancelButtonPressed(sender: AnyObject) {
        subjectTextField.resignFirstResponder()
        textView.resignFirstResponder()
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let actionDeleteDraft = UIAlertAction(title: "Delete Draft", style: UIAlertActionStyle.Destructive) { (_) in
            self.dismissViewControllerAnimated(true, completion: {
                NSNotificationCenter.defaultCenter().removeObserver(self)
            })
        }
        let actionSaveDraft = UIAlertAction(title: "Save Draft", style: UIAlertActionStyle.Default) { (_) in
            NSNotificationCenter.defaultCenter().removeObserver(self)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (_) in
            return
        }
        alert.addAction(actionDeleteDraft)
        alert.addAction(actionSaveDraft)
        alert.addAction(actionCancel)
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func saveButtonPressed(sender: AnyObject) {
        subjectTextField.resignFirstResponder()
        textView.resignFirstResponder()
        NSNotificationCenter.defaultCenter().removeObserver(self)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func fontButtonPressed(sender: AnyObject) {
        let popOver = ZZPopOver(sender: sender as! UIButton, holder: self, paddingFromSender: 5, style: ZZPopOverSpecialStyle.AlignHorizontalCenter(padding: 10, fromTop: false, height: self.view.frame.width / 10))
        popOver.showPopOver(animated: true, contents: fontSettingButtons, contentsStyle: ZZPopOverContentsStyle.ResizeToSameSize)
       
    }
    
    @IBAction func listButtonPressed(sender: AnyObject) {
        let popOver = ZZPopOver(sender: sender as! UIButton, holder: self, size: CGSize(width: (self.view.frame.width / 17) * 7, height: self.view.frame.width / 10), direction: ZZPopOverDirection.FromButtom(padding: 5), triangleAlignStyle: ZZPopOverTriangleAlignStyle.AlignCustom(factor: 0.3))
        popOver.showPopOver(animated: true, contents: listSettingButtons, contentsStyle: ZZPopOverContentsStyle.ResizeToSameSize)
    }

}
