//
//  RootViewController.swift
//  DailyNotes
//
//  Created by Zhicong Zang on 7/20/16.
//  Copyright © 2016 Zhicong Zang. All rights reserved.
//

import UIKit
import Photos

class RootViewController: UIViewController {
    
    private var myContext: UInt8 = 1
    
    @IBOutlet weak var noteButton: RootButton!
    @IBOutlet weak var photoButton: RootButton!
    @IBOutlet weak var reminderButton: RootButton!
    @IBOutlet weak var listButton: RootButton!
    @IBOutlet weak var audioButton: RootButton!
    
    @IBOutlet weak var searchingButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    @IBOutlet weak var reminderTableView: UITableView!
    
    @IBOutlet var buttonPaddings: [NSLayoutConstraint]!
    @IBOutlet weak var buttonsToTopLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var reminderTableViewToTopLC: NSLayoutConstraint!
    @IBOutlet weak var reminderTabelViewHeightLC: NSLayoutConstraint!
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var reminderTableViewTitle: RemindTableViewTitle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
        setupReminderTableView()
        appDelegate.addObserver(self, forKeyPath: "uncompletedReminders", options: .New, context: &myContext)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if context == &myContext {
            dispatch_async(dispatch_get_main_queue(), {
                if self.reminderTableViewTitle.isOpen {
                    self.reminderTabelViewHeightLC.constant = ReminderTableViewCellHeight * min(CGFloat(self.appDelegate.uncompletedReminders.count + 1), 9)
                } else {
                    self.reminderTabelViewHeightLC.constant = ReminderTableViewCellHeight * min(CGFloat(self.appDelegate.uncompletedReminders.count + 1), 4)
                }
                UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: {
                    self.view.layoutIfNeeded()
                    }, completion: {(completed) in
                        if completed {
                            self.reminderTableView.reloadData()
                        }
                })
            })
        } else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    
    func setupButtons() {
        buttonsToTopLayoutConstraint.constant = rootButtonWidth / 2
        buttonPaddings.forEach { (buttonPadding) in
            buttonPadding.constant = rootButtonWidth
        }
        searchingButton.frame.size = CGSize(width: rootButtonWidth / 2, height: rootButtonWidth / 2)
        settingsButton.frame.size = CGSize(width: rootButtonWidth / 2, height: rootButtonWidth / 2)
    }
    
    func setupReminderTableView() {
        reminderTableViewTitle = RemindTableViewTitle(frame: CGRect(x: 0, y: 0, width: screenWidth - 40, height: ReminderTableViewCellHeight))
        reminderTableViewTitle.addTarget(self, action: #selector(RootViewController.reminderTableViewTitlePressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        reminderTableViewToTopLC.constant = rootButtonWidth * 2
        reminderTableView.layer.masksToBounds = true
        reminderTableView.layer.cornerRadius = 10.0
        reminderTableView.layer.borderColor = UIColor(white: 0.6, alpha: 1).CGColor
        reminderTableView.layer.borderWidth = 0.5
        reminderTableView.separatorColor = UIColor(white: 0.6, alpha: 1)
        reminderTableView.scrollEnabled = false
        reminderTableView.bounces = false
        let nib = UINib(nibName: "ReminderTableViewCell", bundle: nil)
        reminderTableView.registerNib(nib, forCellReuseIdentifier: "ReminderTableViewCell")
        
    }
    
    @IBAction func reminderButtonPressed(sender: AnyObject) {
        let newReminderNC = storyboard?.instantiateViewControllerWithIdentifier("NewReminder") as! NewReminderViewController
        self.configureChildViewController(childController: newReminderNC, onView: self.view, constraints: .Constraints(top: 0, buttom: 0, left: 0, right: 0))
    }
    
    @IBAction func photoButtonPressed(sender: AnyObject) {
        let newPhotoVC = storyboard?.instantiateViewControllerWithIdentifier("NewPhoto") as! NewPhotoViewController
        self.presentViewController(newPhotoVC, animated: true, completion: nil)
    }
    
    deinit {
        appDelegate.removeObserver(self, forKeyPath: "uncompletedReminders")
    }
    
    
}

extension RootViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return ReminderTableViewCellHeight
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        reminderTableViewTitle.countLabel.text = "All \(appDelegate.uncompletedReminders.count)"
        return reminderTableViewTitle
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.uncompletedReminders.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return ReminderTableViewCellHeight
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ReminderTableViewCell") as! ReminderTableViewCell
        if indexPath.row < appDelegate.uncompletedReminders.count {
            let reminder = appDelegate.uncompletedReminders[indexPath.row]
            cell.setup(reminder.title, date: reminder.dueDateComponents?.date, index: indexPath.row, reminderCompleted: reminder.completed)
        }
        return cell
    }
    
    func reminderTableViewTitlePressed(sender: AnyObject) {
        if reminderTableViewTitle.isOpen {
            reminderTableViewToTopLC.constant = rootButtonWidth * 2
            reminderTabelViewHeightLC.constant = CGFloat(min(appDelegate.uncompletedReminders.count + 1, 4)) * ReminderTableViewCellHeight
            UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: {
                self.view.layoutIfNeeded()
                }, completion: nil )
        } else {
            reminderTableViewToTopLC.constant = rootButtonWidth / 2
            reminderTabelViewHeightLC.constant = CGFloat(min(appDelegate.uncompletedReminders.count + 1, 9)) * ReminderTableViewCellHeight
            UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: {
                self.view.layoutIfNeeded()
                }, completion: nil )
        }
        reminderTableViewTitle.isOpen = !reminderTableViewTitle.isOpen
        reminderTableView.scrollEnabled = reminderTableViewTitle.isOpen
    }
}




