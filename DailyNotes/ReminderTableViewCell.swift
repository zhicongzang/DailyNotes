//
//  ReminderTableViewCell.swift
//  DailyNotes
//
//  Created by Zhicong Zang on 8/15/16.
//  Copyright © 2016 Zhicong Zang. All rights reserved.
//

import UIKit

class ReminderTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectedButton: UIButton!
    
    var dateFormatter = NSDateFormatter()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        dateFormatter.dateFormat = "MM/dd/yyyy"
        titleLabel.text = ""
        dateLabel.text = ""
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(title: String, date: NSDate?) {
        titleLabel.text = title
        if let d = date {
            dateLabel.text = dateFormatter.stringFromDate(d)
        }
        
    }
    
}
