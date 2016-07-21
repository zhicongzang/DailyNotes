//
//  RootViewController.swift
//  DailyNotes
//
//  Created by Zhicong Zang on 7/20/16.
//  Copyright © 2016 Zhicong Zang. All rights reserved.
//

import UIKit


class RootViewController: UIViewController {
    
    var rootButtonY: CGFloat = 0
    
    @IBOutlet weak var searchingButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    var noteButton = RootButton(image: UIImage(named: "Note"))
    var photoButton = RootButton(image: UIImage(named: "Photo"))
    var reminderButton = RootButton(image: UIImage(named: "Reminder"))
    var listButton = RootButton(image: UIImage(named: "List"))
    var audioButton = RootButton(image: UIImage(named: "Audio"))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupButtons() {
        noteButton.frame = CGRect(x: rootButtonSize, y: rootButtonY + rootButtonSize / 2, width: rootButtonSize, height: rootButtonSize)
        photoButton.frame = CGRect(x: rootButtonSize * 3, y: rootButtonY + rootButtonSize / 2, width: rootButtonSize, height: rootButtonSize)
        reminderButton.frame = CGRect(x: rootButtonSize * 5, y: rootButtonY + rootButtonSize / 2, width: rootButtonSize, height: rootButtonSize)
        listButton.frame = CGRect(x: rootButtonSize * 7, y: rootButtonY + rootButtonSize / 2, width: rootButtonSize, height: rootButtonSize)
        audioButton.frame = CGRect(x: rootButtonSize * 9, y: rootButtonY + rootButtonSize / 2, width: rootButtonSize, height: rootButtonSize)
        self.view.addSubview(noteButton)
        self.view.addSubview(photoButton)
        self.view.addSubview(reminderButton)
        self.view.addSubview(listButton)
        self.view.addSubview(audioButton)
        searchingButton.frame.size = CGSize(width: rootButtonSize / 2, height: rootButtonSize / 2)
        settingsButton.frame.size = CGSize(width: rootButtonSize / 2, height: rootButtonSize / 2)
    }
    
    
}
