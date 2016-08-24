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
    @IBOutlet weak var buttonRightLC: NSLayoutConstraint!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var warningLabel: UILabel!
    
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
    
    dynamic var newCreatedNotebookName = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameTextFieldLeftLC.constant = screenWidth + 20
        buttonRightLC.constant = 20 - screenWidth
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    func showNameTextField() {
        nameTextField.becomeFirstResponder()
        imageViewLeftLC.constant -= screenWidth
        nameTextFieldLeftLC.constant -= screenWidth
        buttonRightLC.constant += screenWidth
        UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.layoutIfNeeded()
            }, completion: nil)
    }
    
    func dismissNameTextField() {
        nameTextField.resignFirstResponder()
        if !warningLabel.hidden {
            warningLabel.hidden = true
        }
        imageViewLeftLC.constant += screenWidth
        nameTextFieldLeftLC.constant += screenWidth
        buttonRightLC.constant -= screenWidth
        UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.layoutIfNeeded()
            }, completion: nil)
    }
    
    func createNewNotebook() {
        if let text = nameTextField.text?.removeHeadAndTailSpacePro where text != "" {
            if !Notebook.insertNewNotebook(name: text) {
                warningLabel.text = "Name must be unique."
                warningLabel.hidden = false
            } else {
                newCreatedNotebookName = text
                nameTextField.text = ""
                isActive = false
            }
        }
        warningLabel.text = "Name must contain at least 1 char."
        warningLabel.hidden = false
    }
    
    @IBAction func creatButtonPressed(sender: AnyObject) {
        createNewNotebook()
    }
    
    @IBAction func nameTextFieldDidEndOnExit(sender: AnyObject) {
        createNewNotebook()
    }
    
    
    @IBAction func nameTextFieldDidBeginEditing(sender: AnyObject) {
        if !warningLabel.hidden {
            warningLabel.hidden = true
        }
    }
    
}
