//
//  NotebookTableViewCell.swift
//  DailyNotes
//
//  Created by Zhicong Zang on 8/22/16.
//  Copyright © 2016 Zhicong Zang. All rights reserved.
//

import UIKit

class NotebookTableViewCell: UITableViewCell {

    @IBOutlet weak var checkedImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup(name name: String, didSelected: Bool) {
        nameLabel.text = name
        if didSelected {
            checkedImageView.hidden = false
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
