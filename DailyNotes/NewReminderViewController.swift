//
//  NewReminderViewController.swift
//  DailyNotes
//
//  Created by Zhicong Zang on 7/27/16.
//  Copyright © 2016 Zhicong Zang. All rights reserved.
//

import UIKit
import EventKit

class NewReminderViewController: UIViewController {
    
    @IBOutlet weak var contentViewToTopLC: NSLayoutConstraint!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var reminderLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var textView: ZZPlaceholderTextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    lazy var eventStore: EKEventStore = {
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return delegate.eventStore
    }()
    
    var date: NSDate? {
        didSet {
            if date != nil {
                if !saveButton.enabled {
                    saveButton.enabled = true
                }
                reminderLabel.text = date?.toReminderDateString()
                deleteButton.hidden = false
            } else {
                if saveButton.enabled {
                    saveButton.enabled = false
                }
                reminderLabel.text = "Notify me"
                deleteButton.hidden = true
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setup()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NewReminderViewController.keyboardWillChangeFrame(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NewReminderViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setup() {
        self.view.backgroundColor = UIColor(white: 0.8, alpha: 0.6)
        contentViewToTopLC.constant = (view.frame.height - contentView.frame.height) / 2
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        datePicker.hidden = true
        buttonView.setupTopDividingLine(lineWidth: 0.5, lineColor: UIColor(white: 0.6, alpha: 1).CGColor)
        saveButton.enabled = false
    }
    
    
    override func didMoveToParentViewController(parent: UIViewController?) {
        contentView.transform = CGAffineTransformMakeScale(1.1, 1.1)
        view.alpha = 0
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveLinear, animations: {
            self.contentView.transform = CGAffineTransformIdentity
            self.view.alpha = 1
            }, completion: nil)
    }
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        viewControllerDismiss()
        
    }
    
    @IBAction func saveButtonPressed(sender: AnyObject) {
        let reminder = EKReminder(eventStore: eventStore)
        reminder.title = textView.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) != "" ? textView.text : "Reminder at \(reminderLabel.text!)"
        reminder.calendar = eventStore.defaultCalendarForNewReminders()
        let dueDateComponents = date!.dateComponent()
        reminder.dueDateComponents = dueDateComponents
        let alerm = EKAlarm(absoluteDate: date!)
        reminder.addAlarm(alerm)
        do {
            try eventStore.saveReminder(reminder, commit: true)
            (UIApplication.sharedApplication().delegate as! AppDelegate).getAllReminders()
        } catch {}
        viewControllerDismiss()
    }
    
    
    @objc func keyboardWillChangeFrame(notification: NSNotification) {
        if let userInfo = notification.userInfo,
            value = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue,
            duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double,
            curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? UInt {
            
            let frame = value.CGRectValue()
            let intersection = CGRectIntersection(frame, self.view.frame)
            
            
            self.contentViewToTopLC.constant = (view.frame.height - contentView.frame.height - CGRectGetHeight(intersection)) / 2
            UIView.animateWithDuration(duration, delay: 0.0,
                                       options: UIViewAnimationOptions(rawValue: curve), animations: {
                                        _ in
                                        self.view.layoutIfNeeded()
                }, completion: nil)
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if !datePicker.hidden {
            datePicker.hidden = true
        }
    }
    
    @IBAction func backgroundTap(sender: AnyObject) {
        textView.resignFirstResponder()
        if !datePicker.hidden {
            dismissDatePickerWithAnimation()
        }
    }
    
    @IBAction func pickDateButtonPressed(sender: AnyObject) {
        textView.resignFirstResponder()
        
        if datePicker.hidden {
            if date == nil {
                date = datePicker.date
            }
            showDatePickerWithAnimation()
        }
        else {
            dismissDatePickerWithAnimation()
        }
        
    }
    
    func viewControllerDismiss() {
        textView.resignFirstResponder()
        UIView.animateWithDuration(0.3, delay: 0, options: .BeginFromCurrentState, animations: {
            self.contentView.transform = CGAffineTransformMakeScale(0.9, 0.9)
            self.view.alpha = 0
        }) { (finished) in
            NSNotificationCenter.defaultCenter().removeObserver(self)
            self.removeFromParentViewController()
            self.view.removeFromSuperview()
            
        }
    }
    
    @IBAction func datePickerValueChanged(sender: UIDatePicker) {
        date = sender.date
    }
    
    @IBAction func deleteButtonPressed(sender: AnyObject) {
        date = nil
        datePicker.setDate(NSDate(), animated: true)
    }
    
    
    func showDatePickerWithAnimation() {
        datePicker.hidden = false
        datePicker.alpha = 0
        self.contentViewToTopLC.constant = (view.frame.height - contentView.frame.height - datePicker.frame.height) / 2
        UIView.animateWithDuration(0.3, delay: 0.0,
                                   options: UIViewAnimationOptions.BeginFromCurrentState, animations: {
                                    _ in
                                    self.datePicker.alpha = 1
                                    self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    func dismissDatePickerWithAnimation() {
        self.contentViewToTopLC.constant = (view.frame.height - contentView.frame.height) / 2
        UIView.animateWithDuration(0.3, delay: 0.0,
                                   options: UIViewAnimationOptions.BeginFromCurrentState, animations: {
                                    _ in
                                    self.datePicker.alpha = 0
                                    self.view.layoutIfNeeded()
        }){ (finished) in
            self.datePicker.hidden = true
        }
    }
}


