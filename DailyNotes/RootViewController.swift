//
//  RootViewController.swift
//  DailyNotes
//
//  Created by Zhicong Zang on 7/20/16.
//  Copyright © 2016 Zhicong Zang. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
    
    @IBOutlet weak var noteButton: RootButton!
    @IBOutlet weak var photoButton: RootButton!
    @IBOutlet weak var reminderButton: RootButton!
    @IBOutlet weak var listButton: RootButton!
    @IBOutlet weak var audioButton: RootButton!
    
    @IBOutlet weak var searchingButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    
    @IBOutlet var buttonPaddings: [NSLayoutConstraint]!
    @IBOutlet weak var buttonsToTopLayoutConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
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
        let baseView = UIView(frame: CGRect(x: 0, y: -44, width: self.view.frame.width, height: self.view.frame.height))
        baseView.backgroundColor = UIColor(white: 0.6, alpha: 0.3)
        self.view.addSubview(baseView)
        let width = view.frame.width
        let height = view.frame.height
        let newReminderNC = storyboard?.instantiateViewControllerWithIdentifier("NewReminderNC") as! NewReminderNC
        self.configureChildViewController(childController: newReminderNC, onView: baseView, constraints: .Constraints(top: height / 3, buttom: height / 3, left: width / 8, right: width / 8))
    }
    
}



