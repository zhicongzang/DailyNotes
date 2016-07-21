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
    
    @IBOutlet weak var toolBarLayoutConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        let actionSaveDraft = UIAlertAction(title: "Save Draft", style: UIAlertActionStyle.Default) { (_) in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        let actionCancel = UIAlertAction(title: "Cancel Draft", style: UIAlertActionStyle.Cancel) { (_) in
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
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    

}
