//
//  AddNewNotebookTableViewCell.swift
//  DailyNotes
//
//  Created by Zhicong Zang on 8/22/16.
//  Copyright © 2016 Zhicong Zang. All rights reserved.
//

import UIKit

class AddNewNotebookTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewLeftLC: NSLayoutConstraint!
    @IBOutlet weak var nameTextFieldLeftLC: NSLayoutConstraint!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    var isActive = false {
        didSet {
            if isActive != oldValue {
                if isActive {
                    showNameTextField()
                } else {
                    dismissNameTextField()
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameTextFieldLeftLC.constant = screenWidth
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    func showNameTextField() {
        nameTextField.becomeFirstResponder()
        let constant = imageViewLeftLC.constant
        imageViewLeftLC.constant = constant - nameTextFieldLeftLC.constant
        nameTextFieldLeftLC.constant = constant
        UIView.animateWithDuration(0.3, animations: {
            self.layoutIfNeeded()
        })
    }
    
    func dismissNameTextField() {
        nameTextField.resignFirstResponder()
        imageViewLeftLC.constant = nameTextFieldLeftLC.constant
        nameTextFieldLeftLC.constant = screenWidth
        UIView.animateWithDuration(0.5, animations: {
            self.layoutIfNeeded()
        })
    }
    
    @IBAction func creatButtonPressed(sender: AnyObject) {
        isActive = false
    }
    
}
