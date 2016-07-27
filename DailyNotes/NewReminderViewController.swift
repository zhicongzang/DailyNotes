//
//  NewReminderViewController.swift
//  DailyNotes
//
//  Created by Zhicong Zang on 7/27/16.
//  Copyright © 2016 Zhicong Zang. All rights reserved.
//

import UIKit

class NewReminderViewController: UIViewController {
    
    @IBOutlet weak var boundView: UIView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setup()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setup() {
        boundView.backgroundColor = UIColor(white: 0.8, alpha: 0.3)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    


    
    
}
