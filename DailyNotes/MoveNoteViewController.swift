//
//  MoveNoteViewController.swift
//  DailyNotes
//
//  Created by Zhicong Zang on 8/22/16.
//  Copyright © 2016 Zhicong Zang. All rights reserved.
//

import UIKit

class MoveNoteViewController: UIViewController {
    
    
    @IBOutlet weak var notebookTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    
    
    var notebooks = Notebook.getAllNoteBooks()
    
    override func viewDidLoad() {
        setupSearchBar()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(MoveNoteViewController.dismissKeyboard(_:)))
        tapGesture.cancelsTouchesInView = false
        notebookTableView.addGestureRecognizer(tapGesture)
        notebookTableView.tableFooterView = UIView()
        let nib = UINib(nibName: "NotebookTableViewCell", bundle: nil)
        notebookTableView.registerNib(nib, forCellReuseIdentifier: "NotebookTableViewCell")
        let nib2 = UINib(nibName: "AddNewNotebookTableViewCell", bundle: nil)
        notebookTableView.registerNib(nib2, forCellReuseIdentifier: "AddNewNotebookTableViewCell")
    }
    
    override func didReceiveMemoryWarning() {
    }
    
    func setupSearchBar() {
        for object: UIView in ((searchBar.subviews[0] )).subviews {
            if let textField = object as? UITextField {
                textField.addTarget(self, action: #selector(MoveNoteViewController.dismissSearchBarKeyboard(_:)), forControlEvents: UIControlEvents.EditingDidEndOnExit)
            }
        }
    }
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        let cell = notebookTableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! AddNewNotebookTableViewCell
        if cell.isActive {
            cell.isActive = false
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @objc func dismissKeyboard(recognizer: UIGestureRecognizer) {
        if searchBar.showsCancelButton {
            searchBar.resignFirstResponder()
            searchBar.setShowsCancelButton(false, animated: true)
        }
        let location = recognizer.locationInView(notebookTableView)
        if !notebookTableView.cellForRowAtIndexPath(NSIndexPath(forItem: 0, inSection: 0))!.pointInside(location, withEvent: nil) {
            if let cell = notebookTableView.cellForRowAtIndexPath(NSIndexPath(forItem: 0, inSection: 0)) as? AddNewNotebookTableViewCell where cell.isActive {
                cell.isActive = false
            }
        }
    }
    
    @objc func dismissSearchBarKeyboard(sender: AnyObject) {
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
}

extension MoveNoteViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        if let cell = notebookTableView.cellForRowAtIndexPath(NSIndexPath(forItem: 0, inSection: 0)) as? AddNewNotebookTableViewCell where cell.isActive {
            cell.isActive = false
        }
        searchBar.setShowsCancelButton(true, animated: true)
        for object: UIView in ((searchBar.subviews[0] )).subviews {
            if let cancelButton = object as? UIButton {
                cancelButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
            }
        }
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}

extension MoveNoteViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return " "
        }
        return nil
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 5
        }
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return notebooks.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("AddNewNotebookTableViewCell")!
            cell.selectionStyle = .None
            return cell
        } else {
            let notebook = notebooks[indexPath.row]
            let cell = tableView.dequeueReusableCellWithIdentifier("NotebookTableViewCell") as! NotebookTableViewCell
            cell.setup(name: notebook.name ?? "", didSelected: true)
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! AddNewNotebookTableViewCell
            if !cell.isActive {
                cell.isActive = true
            }
        }
    }
    
    
}













