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
    @IBOutlet weak var notebookTableView: ExpendableTableView!
    
    
    @IBOutlet var buttonPaddings: [NSLayoutConstraint]!
    @IBOutlet weak var buttonsToTopLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var reminderTableViewToTopLC: NSLayoutConstraint!
    @IBOutlet weak var reminderTableViewHeightLC: NSLayoutConstraint!
    @IBOutlet weak var notebookTableViewToReminderTableViewLC: NSLayoutConstraint!
    @IBOutlet weak var notebookTableViewHeightLC: NSLayoutConstraint!
    
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var reminderTableViewTitle: RootTableViewTitle!
    @IBOutlet weak var notebookTableViewTitle: RootTableViewTitle!
    @IBOutlet weak var combinedView: UIView!
    
    var notebooks: [Notebook]! {
        didSet {
            notebookTableViewTitle.countLabel.text = "All \(notebooks.count)"
            dispatch_async(dispatch_get_main_queue(), {
                self.notebookTableView.reloadData()
                if self.notebookTableViewTitle.isOpen {
                    self.notebookTableViewHeightLC.constant = min(RootTableViewCellHeight * 9, self.notebookTableView.tableViewTotalHeight(sectionHeight: RootTableViewCellHeight, rowHeight: RootTableViewCellHeight) + RootTableViewCellHeight)
                } else {
                    self.notebookTableViewHeightLC.constant = min(RootTableViewCellHeight * 4, self.notebookTableView.tableViewTotalHeight(sectionHeight: RootTableViewCellHeight, rowHeight: RootTableViewCellHeight) + RootTableViewCellHeight)
                }
                UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: {
                    self.view.layoutIfNeeded()
                    }, completion: nil)
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(RootViewController.reminderTableViewTitlePressed(_:)))
        reminderTableViewTitle.addGestureRecognizer(tapGesture)
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
        notebookTableViewTitle.setup("Notebook", imageName: "Notebook")
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(RootViewController.notebookTableViewTitlePressed(_:)))
        notebookTableViewTitle.addGestureRecognizer(tapGesture)
        notebookTableViewToReminderTableViewLC.constant = rootButtonWidth / 2
        combinedView.layer.masksToBounds = true
        combinedView.layer.cornerRadius = 10.0
        combinedView.layer.borderColor = UIColor(white: 0.6, alpha: 1).CGColor
        combinedView.layer.borderWidth = 0.5
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
            notebookTableViewHeightLC.constant = min(RootTableViewCellHeight * 4, self.notebookTableView.tableViewTotalHeight(sectionHeight: RootTableViewCellHeight, rowHeight: RootTableViewCellHeight) + RootTableViewCellHeight)
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "OldNote" {
            if let sender = sender as? RootNotebookTableViewCell {
                let vc = segue.destinationViewController as! NewNoteViewController
                vc.note = sender.note
            }
            
        }
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
            if let tableView = tableView as? ExpendableTableView {
                if let view = tableView.sectionViews[section] as? NotebookSectionTitle {
                    view.resetNotebook(notebooks[section])
                    return view
                }
                let notebook = notebooks[section]
                let view = NotebookSectionTitle(frame: CGRect(x: 0, y: 0, width: screenWidth - 40, height: RootTableViewCellHeight), notebook: notebook, section: section)
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(RootViewController.noteSectionPressed(_:)))
                view.addGestureRecognizer(tapGesture)
                tableView.sectionViews[section] = view
                return view
            }
            
        }
        
        return nil
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if tableView.tag == 0 {
            return 1
        }
        if tableView.tag == 1 {
            return notebooks.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 0 {
            return appDelegate.uncompletedReminders.count
        }
        if tableView.tag == 1 {
            let notebook = notebooks[section]
            return notebook.note?.count ?? 0
        }
        return 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if tableView.tag == 0 {
            return RootTableViewCellHeight
        }
        if tableView.tag == 1 {
            if let tb = tableView as? ExpendableTableView {
                if tb.openedSections.contains(indexPath.section) {
                    return RootTableViewCellHeight
                }
                return 0
            }
            
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
            let notebook = notebooks[indexPath.section]
            if let notes = notebook.note, let note = notes[indexPath.row] as? Note {
                cell.setup(note: note)
                return cell
            }
        
            
        }
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView.tag == 1 {
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! RootNotebookTableViewCell
            dispatch_async(dispatch_get_main_queue(), { 
                self.performSegueWithIdentifier("OldNote", sender: cell)
            })
            
        }
        
    }
    
    
    
    @objc
    func reminderTableViewTitlePressed(recognizer: UIGestureRecognizer) {
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
    func notebookTableViewTitlePressed(recognizer: UIGestureRecognizer) {
        if notebookTableViewTitle.isOpen {
            reminderTableViewHeightLC.constant = CGFloat(min(appDelegate.uncompletedReminders.count + 1, 4)) * RootTableViewCellHeight
            notebookTableViewHeightLC.constant = min(RootTableViewCellHeight * 4, self.notebookTableView.tableViewTotalHeight(sectionHeight: RootTableViewCellHeight, rowHeight: RootTableViewCellHeight) + RootTableViewCellHeight)
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
            notebookTableViewHeightLC.constant = min(RootTableViewCellHeight * 9, self.notebookTableView.tableViewTotalHeight(sectionHeight: RootTableViewCellHeight, rowHeight: RootTableViewCellHeight) + RootTableViewCellHeight)
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
    
    @objc
    func noteSectionPressed(recognizer: UIGestureRecognizer) {
        if let view = recognizer.view as? NotebookSectionTitle {
            let completion = {() in
                if self.notebookTableViewTitle.isOpen {
                    self.notebookTableViewHeightLC.constant = min(RootTableViewCellHeight * 9, self.notebookTableView.tableViewTotalHeight(sectionHeight: RootTableViewCellHeight, rowHeight: RootTableViewCellHeight) + RootTableViewCellHeight)
                } else {
                    self.notebookTableViewHeightLC.constant = min(RootTableViewCellHeight * 4, self.notebookTableView.tableViewTotalHeight(sectionHeight: RootTableViewCellHeight, rowHeight: RootTableViewCellHeight) + RootTableViewCellHeight)
                }
                UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: {
                    self.view.layoutIfNeeded()
                    }, completion: nil)
                }
            if view.isOpen {
                notebookTableView.closeSection(section: view.section, completion: completion)
            } else {
                notebookTableView.openSection(section: view.section, completion: completion)
            }
            view.isOpen = !view.isOpen
        }
    }
}




