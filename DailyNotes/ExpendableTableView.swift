//
//  ExpendableTableView.swift
//  DailyNotes
//
//  Created by Zhicong Zang on 8/25/16.
//  Copyright © 2016 Zhicong Zang. All rights reserved.
//

import UIKit

class ExpendableTableView: UITableView {
    var openedSections = [Int]()
    var sectionViews = [Int: UIView]()
    
    override func reloadData() {
        openedSections = []
        super.reloadData()
    }
    
    func openSection(section section: Int, completion: () -> Void) {
        openedSections.append(section)
        var indexPaths = [NSIndexPath]()
        for row in 0..<self.numberOfRowsInSection(section) {
            let indexPath = NSIndexPath(forRow: row, inSection: section)
            indexPaths.append(indexPath)
        }
        self.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: .Fade)
        completion()
        if let indexPath = indexPaths.first {
            self.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
        }
    }
    
    func closeSection(section section: Int, completion: () -> Void) {
        openedSections = openedSections.filter({$0 != section})
        var indexPaths = [NSIndexPath]()
        for row in 0..<self.numberOfRowsInSection(section) {
            let indexPath = NSIndexPath(forRow: row, inSection: section)
            indexPaths.append(indexPath)
        }
        self.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: .Fade)
        completion()
    }
    
    func tableViewTotalHeight(sectionHeight sectionHeight: CGFloat, rowHeight: CGFloat) -> CGFloat {
        var height = CGFloat(numberOfSections) * sectionHeight
        openedSections.forEach { (section) in
            height += (CGFloat(numberOfRowsInSection(section)) * rowHeight)
        }
        return height
    }
}
