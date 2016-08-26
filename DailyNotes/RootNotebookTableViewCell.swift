//
//  RootNotebookTableViewCell.swift
//  DailyNotes
//
//  Created by Zhicong Zang on 8/24/16.
//  Copyright © 2016 Zhicong Zang. All rights reserved.
//

import UIKit

class RootNotebookTableViewCell: UITableViewCell {
    
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var updateDateLabel: UILabel!
    
    var dateFormatter = NSDateFormatter()
    
    var note: Note!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .None
        dateFormatter.dateFormat = "MM/dd/yyyy"
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func setup(note note: Note) {
        self.note = note
        subjectLabel.text = note.subject
        if let d = note.updateDate {
            updateDateLabel.text = "Last update date: \(dateFormatter.stringFromDate(d))"
        }
    }
    
    
}


