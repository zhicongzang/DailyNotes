//
//  MoveNoteViewController.swift
//  DailyNotes
//
//  Created by Zhicong Zang on 8/22/16.
//  Copyright © 2016 Zhicong Zang. All rights reserved.
//

import UIKit

class MoveNoteViewController: UIViewController {
    
    private var myContext: UInt8 = 3
    
    
    @IBOutlet weak var notebookTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    
    var allNotebooks = Notebook.getAllNoteBooks()
    var showNotebooks = Notebook.getAllNoteBooks()
    
    var selectedNotebook: Notebook!
    var block: ((Notebook) -> Void)!
    
    override func viewDidLoad() {
        setupSearchBar()
        setupTableView()
        let tapGestureForTableView = UITapGestureRecognizer(target: self, action: #selector(MoveNoteViewController.dismissKeyboard(_:)))
        let tapGestureForNavigationBar = UITapGestureRecognizer(target: self, action: #selector(MoveNoteViewController.dismissKeyboard(_:)))
        tapGestureForTableView.cancelsTouchesInView = false
        tapGestureForNavigationBar.cancelsTouchesInView = false
        notebookTableView.addGestureRecognizer(tapGestureForTableView)
        navigationBar.addGestureRecognizer(tapGestureForNavigationBar)
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
    
    func setupTableView() {
        notebookTableView.tableFooterView = UIView()
        let nib = UINib(nibName: "NotebookTableViewCell", bundle: nil)
        notebookTableView.registerNib(nib, forCellReuseIdentifier: "NotebookTableViewCell")
        let nib2 = UINib(nibName: "AddNewNotebookTableViewCell", bundle: nil)
        notebookTableView.registerNib(nib2, forCellReuseIdentifier: "AddNewNotebookTableViewCell")
        let cell = notebookTableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! AddNewNotebookTableViewCell
        cell.addObserver(self, forKeyPath: "newCreatedNotebookName", options: .New, context: &myContext)
    }
    
    override func dismissViewControllerAnimated(flag: Bool, completion: (() -> Void)?) {
        let cell = notebookTableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! AddNewNotebookTableViewCell
        if cell.isActive {
            cell.isActive = false
        }
        cell.removeObserver(self, forKeyPath: "newCreatedNotebookName")
        block(selectedNotebook)
        super.dismissViewControllerAnimated(flag, completion: completion)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if context == &myContext {
            let cell = notebookTableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! AddNewNotebookTableViewCell
            selectedNotebook = Notebook.getNoteBook(name: cell.newCreatedNotebookName)
            if allNotebooks.count == showNotebooks.count {
                allNotebooks = Notebook.getAllNoteBooks()
                showNotebooks = allNotebooks
            } else {
                allNotebooks = Notebook.getAllNoteBooks()
            }
            notebookTableView.reloadData()
            
        } else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
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
        self.showNotebooks = self.allNotebooks
        notebookTableView.reloadData()
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
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            self.showNotebooks = self.allNotebooks
        }
        else {
            self.showNotebooks = []
            for notebook in self.allNotebooks {
                if notebook.name!.lowercaseString.hasPrefix(searchText.lowercaseString) {
                    self.showNotebooks.append(notebook)
                }
            }
        }
        
        notebookTableView.reloadData()
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
            return showNotebooks.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("AddNewNotebookTableViewCell")!
            cell.selectionStyle = .None
            return cell
        } else {
            let notebook = showNotebooks[indexPath.row]
            let cell = tableView.dequeueReusableCellWithIdentifier("NotebookTableViewCell") as! NotebookTableViewCell
            let didSelected = (notebook.name == selectedNotebook.name)
            cell.setup(name: notebook.name ?? "", didSelected: didSelected)
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! AddNewNotebookTableViewCell
            if !cell.isActive {
                cell.isActive = true
            }
        } else if indexPath.section == 1 {
            selectedNotebook = showNotebooks[indexPath.row]
            tableView.reloadData()
            dismissViewControllerAnimated(true, completion: nil)
            
        }
    }
    
    
    
}













