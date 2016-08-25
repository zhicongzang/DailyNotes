//
//  RootNotebookTableViewCell.swift
//  DailyNotes
//
//  Created by Zhicong Zang on 8/24/16.
//  Copyright © 2016 Zhicong Zang. All rights reserved.
//

import UIKit

class RootNotebookTableViewCell: UITableViewCell {
    
    @IBOutlet weak var noteTableView: UITableView!
    
    var notebook: Notebook!
    var noteTableViewTitle: NoteTableViewTitle!
    var height = RootTableViewCellHeight
    
    var updateTableViewBlock: (() -> Void)!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .None
        noteTableView.delegate = self
        noteTableView.dataSource = self
        noteTableView.bounces = false
        noteTableView.scrollEnabled = false
        noteTableView.separatorColor = UIColor(white: 0.6, alpha: 1)
        noteTableViewTitle = NoteTableViewTitle(frame: CGRect(x: 0, y: 0, width: screenWidth - 40, height: RootTableViewCellHeight))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(RootNotebookTableViewCell.noteTableViewTitlePressed(_:)))
        noteTableViewTitle.addGestureRecognizer(tapGesture)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func setup(notebook notebook: Notebook, updateTableViewBlock: () -> Void) {
        self.notebook = notebook
        self.updateTableViewBlock = updateTableViewBlock
        noteTableViewTitle.isOpen = noteTableViewTitle.isOpen
        noteTableViewTitle.titleLabel.text = notebook.name 
        noteTableViewTitle.countLabel.text = "\(notebook.note?.count ?? 0) notes"
        noteTableView.reloadData()
    }
    
    @objc
    func noteTableViewTitlePressed(recognizer: UIGestureRecognizer) {
        if noteTableViewTitle.isOpen {
            height = RootTableViewCellHeight
        } else {
            height = CGFloat(min(4, 1 + (notebook.note?.count  ?? 1))) * RootTableViewCellHeight
        }
        noteTableViewTitle.isOpen = !noteTableViewTitle.isOpen
        noteTableView.scrollEnabled = noteTableViewTitle.isOpen
        updateTableViewBlock()
    }
    
}

extension RootNotebookTableViewCell: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return noteTableViewTitle
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return noteTableViewTitle.frame.height
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notebook.note?.count ?? 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return RootTableViewCellHeight
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if let note = notebook.note![indexPath.row] as? Note {
            cell.textLabel?.text = note.subject
        }
        return cell
    }
}
