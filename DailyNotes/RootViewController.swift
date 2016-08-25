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
    @IBOutlet weak var notebookTableView: UITableView!
    
    @IBOutlet var buttonPaddings: [NSLayoutConstraint]!
    @IBOutlet weak var buttonsToTopLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var reminderTableViewToTopLC: NSLayoutConstraint!
    @IBOutlet weak var reminderTableViewHeightLC: NSLayoutConstraint!
    @IBOutlet weak var notebookTableViewToReminderTableViewLC: NSLayoutConstraint!
    @IBOutlet weak var notebookTableViewHeightLC: NSLayoutConstraint!
    
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var reminderTableViewTitle: RootTableViewTitle!
    var notebookTableViewTitle: RootTableViewTitle!
    
    var notebookTableViewCells = [NSIndexPath: RootNotebookTableViewCell]()
    
    var notebooks: [Notebook]! {
        didSet {
            dispatch_async(dispatch_get_main_queue(), {
                if self.notebookTableViewTitle.isOpen {
                    self.notebookTableViewHeightLC.constant = min(RootTableViewCellHeight * 9, max(self.calculateNotebookTableViewHeight(), CGFloat(self.notebooks.count + 1) * RootTableViewCellHeight))
                } else {
                    self.notebookTableViewHeightLC.constant = min(RootTableViewCellHeight * 4, max(self.calculateNotebookTableViewHeight(), CGFloat(self.notebooks.count + 1) * RootTableViewCellHeight))
                }
                UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: {
                    self.view.layoutIfNeeded()
                    }, completion: {(completed) in
                        if completed {
                            self.notebookTableView.reloadData()
                        }
                })
            })
        }
    }
    
    var openedNotebooTableViewCellIndexPath = [NSIndexPath]()
    
    override func viewWillAppear(animated: Bool) {
        notebooks = Notebook.getAllNoteBooks()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButtons()
        setupReminderTableView()
        setupNotebookTableView()
        appDelegate.addObserver(self, forKeyPath: "uncompletedReminders", options: .New, context: &myContext)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if context == &myContext {
            dispatch_async(dispatch_get_main_queue(), {
                if self.reminderTableViewTitle.isOpen {
                    self.reminderTableViewHeightLC.constant = RootTableViewCellHeight * min(CGFloat(self.appDelegate.uncompletedReminders.count + 1), 9)
                } else {
                    self.reminderTableViewHeightLC.constant = RootTableViewCellHeight * min(CGFloat(self.appDelegate.uncompletedReminders.count + 1), 4)
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
        reminderTableViewTitle = RootTableViewTitle(frame: CGRect(x: 0, y: 0, width: screenWidth - 40, height: RootTableViewCellHeight), title: "Reminder", imageName: "Reminder")
        reminderTableViewTitle.addTarget(self, action: #selector(RootViewController.reminderTableViewTitlePressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        reminderTableViewToTopLC.constant = rootButtonWidth * 2
        reminderTableView.layer.masksToBounds = true
        reminderTableView.layer.cornerRadius = 10.0
        reminderTableView.layer.borderColor = UIColor(white: 0.6, alpha: 1).CGColor
        reminderTableView.layer.borderWidth = 0.5
        reminderTableView.separatorColor = UIColor(white: 0.6, alpha: 1)
        reminderTableView.bounces = false
        let nib = UINib(nibName: "ReminderTableViewCell", bundle: nil)
        reminderTableView.registerNib(nib, forCellReuseIdentifier: "ReminderTableViewCell")
    }
    
    func setupNotebookTableView() {
        notebookTableViewTitle = RootTableViewTitle(frame: CGRect(x: 0, y: 0, width: screenWidth - 40, height: RootTableViewCellHeight), title: "Notebook", imageName: "Notebook")
        notebookTableViewTitle.addTarget(self, action: #selector(RootViewController.notebookTableViewTitlePressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        notebookTableViewToReminderTableViewLC.constant = rootButtonWidth / 2
        notebookTableView.layer.masksToBounds = true
        notebookTableView.layer.cornerRadius = 10.0
        notebookTableView.layer.borderColor = UIColor(white: 0.6, alpha: 1).CGColor
        notebookTableView.layer.borderWidth = 0.5
        notebookTableView.separatorColor = UIColor(white: 0.6, alpha: 1)
        notebookTableView.bounces = false
        let nib = UINib(nibName: "RootNotebookTableViewCell", bundle: nil)
        notebookTableView.registerNib(nib, forCellReuseIdentifier: "RootNotebookTableViewCell")
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
    
    func touchBack(sender: AnyObject) {
        if reminderTableViewTitle.isOpen {
            reminderTableViewToTopLC.constant = rootButtonWidth * 2
            reminderTableViewHeightLC.constant = CGFloat(min(appDelegate.uncompletedReminders.count + 1, 4)) * RootTableViewCellHeight
            notebookTableViewToReminderTableViewLC.constant = rootButtonWidth / 2
            UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: {
                self.view.layoutIfNeeded()
                }, completion: {(complete) in
                    if complete {
                        self.removeTarget()
                    }
            })
            reminderTableViewTitle.isOpen = !reminderTableViewTitle.isOpen
        } else if notebookTableViewTitle.isOpen {
            reminderTableViewHeightLC.constant = CGFloat(min(appDelegate.uncompletedReminders.count + 1, 4)) * RootTableViewCellHeight
            notebookTableViewHeightLC.constant = min(RootTableViewCellHeight * 4, max(self.calculateNotebookTableViewHeight(), CGFloat(self.notebooks.count + 1) * RootTableViewCellHeight))
            notebookTableViewToReminderTableViewLC.constant = rootButtonWidth / 2
            UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: {
                self.reminderTableView.alpha = 1.0
                self.view.layoutIfNeeded()
                }, completion: {(complete) in
                    if complete {
                        self.removeTarget()
                    }
            })
            notebookTableViewTitle.isOpen = !notebookTableViewTitle.isOpen
            
        }
        
    }
    
    func addTarget() {
        let control = self.view as! UIControl
        control.addTarget(self, action: #selector(RootViewController.touchBack(_:)), forControlEvents: UIControlEvents.TouchDown)
    }
    
    func removeTarget() {
        let control = self.view as! UIControl
        control.removeTarget(self, action: #selector(RootViewController.touchBack(_:)), forControlEvents: UIControlEvents.TouchDown)
    }
    
    
}

extension RootViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView.tag == 0 {
            return RootTableViewCellHeight
        }
        if tableView.tag == 1 {
            return RootTableViewCellHeight
        }
        return 0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView.tag == 0 {
            reminderTableViewTitle.countLabel.text = "All \(appDelegate.uncompletedReminders.count)"
            return reminderTableViewTitle
        }
        if tableView.tag == 1 {
            notebookTableViewTitle.countLabel.text = "All \(notebooks.count)"
            return notebookTableViewTitle
        }
        return nil
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if tableView.tag == 0 {
            return 1
        }
        if tableView.tag == 1 {
            return 1
        }
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 0 {
            return appDelegate.uncompletedReminders.count
        }
        if tableView.tag == 1 {
            return notebooks.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if tableView.tag == 0 {
            return RootTableViewCellHeight
        }
        if tableView.tag == 1 {
            if let cell = notebookTableViewCells[indexPath] {
                return cell.height
            }
            return RootTableViewCellHeight
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView.tag == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("ReminderTableViewCell") as! ReminderTableViewCell
            if indexPath.row < appDelegate.uncompletedReminders.count {
                let reminder = appDelegate.uncompletedReminders[indexPath.row]
                cell.setup(reminder.title, date: reminder.dueDateComponents?.date, index: indexPath.row, reminderCompleted: reminder.completed)
            }
            return cell
        }
        if tableView.tag == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("RootNotebookTableViewCell") as! RootNotebookTableViewCell
            if indexPath.row < notebooks.count {
                let notebook = notebooks[indexPath.row]
                cell.setup(notebook: notebook, updateTableViewBlock: {() in
                    if self.notebookTableViewTitle.isOpen {
                        self.notebookTableViewHeightLC.constant = min(RootTableViewCellHeight * 9, max(self.calculateNotebookTableViewHeight(), CGFloat(self.notebooks.count + 1) * RootTableViewCellHeight))
                    } else {
                        self.notebookTableViewHeightLC.constant = min(RootTableViewCellHeight * 4, max(self.calculateNotebookTableViewHeight(), CGFloat(self.notebooks.count + 1) * RootTableViewCellHeight))
                    }
                    UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: {
                        self.view.layoutIfNeeded()
                        }, completion: {(completed) in
                            if completed {
                                tableView.reloadData()
                            }
                    })
                })
            }
            notebookTableViewCells[indexPath] = cell
            return cell
        }
        return UITableViewCell()
    }
    
    @objc
    func reminderTableViewTitlePressed(sender: AnyObject) {
        if reminderTableViewTitle.isOpen {
            reminderTableViewToTopLC.constant = rootButtonWidth * 2
            reminderTableViewHeightLC.constant = CGFloat(min(appDelegate.uncompletedReminders.count + 1, 4)) * RootTableViewCellHeight
            notebookTableViewToReminderTableViewLC.constant = rootButtonWidth / 2
            UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: {
                self.view.layoutIfNeeded()
                }, completion: {(complete) in
                    if complete {
                        self.removeTarget()
                    }
                })
        } else {
            reminderTableViewToTopLC.constant = rootButtonWidth / 2
            reminderTableViewHeightLC.constant = CGFloat(min(appDelegate.uncompletedReminders.count + 1, 9)) * RootTableViewCellHeight
            notebookTableViewToReminderTableViewLC.constant = screenHeight - reminderTableViewHeightLC.constant
            UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: {
                self.view.layoutIfNeeded()
                }, completion: {(complete) in
                    if complete {
                        self.addTarget()
                    }
            })
        }
        reminderTableViewTitle.isOpen = !reminderTableViewTitle.isOpen
    }
    
    @objc
    func notebookTableViewTitlePressed(sender: AnyObject) {
        if notebookTableViewTitle.isOpen {
            reminderTableViewHeightLC.constant = CGFloat(min(appDelegate.uncompletedReminders.count + 1, 4)) * RootTableViewCellHeight
            notebookTableViewHeightLC.constant = min(RootTableViewCellHeight * 4, self.calculateNotebookTableViewHeight())
            notebookTableViewToReminderTableViewLC.constant = rootButtonWidth / 2
            UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: {
                self.view.layoutIfNeeded()
                }, completion: {(complete) in
                    if complete {
                        self.removeTarget()
                    }
            })
        } else {
            reminderTableViewHeightLC.constant = 0
            notebookTableViewHeightLC.constant = min(RootTableViewCellHeight * 9, self.calculateNotebookTableViewHeight())
            notebookTableViewToReminderTableViewLC.constant = -3 / 2 * rootButtonWidth
            UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: {
                self.view.layoutIfNeeded()
                }, completion: {(complete) in
                    if complete {
                        self.addTarget()
                    }
            })
        }
        notebookTableViewTitle.isOpen = !notebookTableViewTitle.isOpen
    }
}

extension RootViewController {
    func calculateNotebookTableViewHeight() -> CGFloat {
        var height: CGFloat = RootTableViewCellHeight
        for i in 0..<notebooks.count {
            if let cell = notebookTableView.cellForRowAtIndexPath(NSIndexPath(forRow: i, inSection: 0)) as? RootNotebookTableViewCell {
                height += cell.height
            }
        }
        return height
    }
}



