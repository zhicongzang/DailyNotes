//
//  NotePreviewViewController.swift
//  DailyNotes
//
//  Created by Zhicong Zang on 9/7/16.
//  Copyright © 2016 Zhicong Zang. All rights reserved.
//

import UIKit

class NotePreviewViewController: UIViewController {
    
    var note: Note!

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var notebookLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    override func viewWillAppear(animated: Bool) {
        let image = note.text!.createImage(imageWidth: screenWidth - 14)
        imageView.image = image
        subjectLabel.text = note.subject
        notebookLabel.text = note.notebook?.name
        locationLabel.text = note.locationName
        contentViewHeight.constant = 102 + image.size.height / image.size.width * (screenWidth - 14)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EditNote" {
            let vc = segue.destinationViewController as! NewNoteViewController
            vc.note = note
        }

    }
    

}
