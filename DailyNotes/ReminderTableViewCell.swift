//
//  ReminderTableViewCell.swift
//  DailyNotes
//
//  Created by Zhicong Zang on 8/15/16.
//  Copyright © 2016 Zhicong Zang. All rights reserved.
//

import UIKit

class ReminderTableViewCell: UITableViewCell {
    
    private var myContext: UInt8 = 2

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var reminderButton: ReminderButton!
    
    var dateFormatter = NSDateFormatter()
    var index = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        dateFormatter.dateFormat = "MM/dd/yyyy"
        titleLabel.text = ""
        dateLabel.text = ""
        self.selectionStyle = .None
        reminderButton.addObserver(self, forKeyPath: "completed", options: .New, context: &myContext)
        self.selectedBackgroundView = UIView(frame: self.frame)
        self.selectedBackgroundView?.backgroundColor = UIColor.clearColor()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if context == &myContext {
            if reminderButton.completed {
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.changedCompletionOfReminderByIndex(index, completed: true)
            }
        } else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    
    func setup(title: String, date: NSDate?, index: Int, reminderCompleted: Bool) {
        reminderButton.completed = reminderCompleted
        self.index = index
        titleLabel.text = title
        if let d = date {
            dateLabel.text = dateFormatter.stringFromDate(d)
        }
    }
    
    deinit {
        reminderButton.removeObserver(self, forKeyPath: "completed")
    }
    
}
