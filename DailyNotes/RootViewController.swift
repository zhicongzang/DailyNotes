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
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
        reminderTableView.layer.masksToBounds = true
        reminderTableView.layer.cornerRadius = 10.0
        reminderTableView.layer.borderColor = UIColor(white: 0.6, alpha: 1).CGColor
        reminderTableView.layer.borderWidth = 0.5
        reminderTableView.separatorColor = UIColor(white: 0.6, alpha: 1)
        reminderTableView.allowsSelection = false
        reminderTableView.scrollEnabled = false
        let nib = UINib(nibName: "ReminderTableViewCell", bundle: nil)
        reminderTableView.registerNib(nib, forCellReuseIdentifier: "ReminderTableViewCell")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupButtons() {
        buttonsToTopLayoutConstraint.constant = rootButtonWidth / 2
        buttonPaddings.forEach { (buttonPadding) in
            buttonPadding.constant = rootButtonWidth
        }
        searchingButton.frame.size = CGSize(width: rootButtonWidth / 2, height: rootButtonWidth / 2)
        settingsButton.frame.size = CGSize(width: rootButtonWidth / 2, height: rootButtonWidth / 2)
    }
    
    @IBAction func reminderButtonPressed(sender: AnyObject) {
        let newReminderNC = storyboard?.instantiateViewControllerWithIdentifier("NewReminder") as! NewReminderViewController
        self.configureChildViewController(childController: newReminderNC, onView: self.view, constraints: .Constraints(top: 0, buttom: 0, left: 0, right: 0))
    }
    
    @IBAction func photoButtonPressed(sender: AnyObject) {
        let newPhotoVC = storyboard?.instantiateViewControllerWithIdentifier("NewPhoto") as! NewPhotoViewController
        self.presentViewController(newPhotoVC, animated: true, completion: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        reminderTableView.reloadData()
    }
    
}

extension RootViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        view.backgroundColor = UIColor.whiteColor()
        view.setupButtomDividingLine(lineWidth: 0.5, lineColor: UIColor(white: 0.6, alpha: 1).CGColor)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.width / 2, height: 50))
        label.textAlignment = .Center
        label.text = "Reminder"
        view.addSubview(label)
        return view
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.uncompletedReminders.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ReminderTableViewCell") as! ReminderTableViewCell
        if indexPath.row < appDelegate.uncompletedReminders.count {
            let reminder = appDelegate.uncompletedReminders[indexPath.row]
            cell.setup(reminder.title, date: reminder.dueDateComponents?.date)
        }
        return cell
    }
}




