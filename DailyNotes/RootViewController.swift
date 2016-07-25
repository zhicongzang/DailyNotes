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
    
    @IBOutlet weak var testLabel: UILabel!
    
    @IBOutlet var buttonPaddings: [NSLayoutConstraint]!
    @IBOutlet weak var buttonsToTopLayoutConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
        let p1 = ZZPopOver(sender: testLabel, size: CGSize(width: 100, height: 100), direction: ZZPopOverDirection.FromTop(padding: 10))
        let p2 = ZZPopOver(sender: testLabel, size: CGSize(width: 100, height: 100), direction: ZZPopOverDirection.FromButtom(padding: 10))
        let p3 = ZZPopOver(sender: testLabel, size: CGSize(width: 100, height: 100), direction: ZZPopOverDirection.FromLeft(padding: 10))
        let p4 = ZZPopOver(sender: testLabel, size: CGSize(width: 100, height: 100), direction: ZZPopOverDirection.FromRight(padding: 10))
        
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
    
    
}
