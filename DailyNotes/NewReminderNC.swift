//
//  NewReminderNC.swift
//  DailyNotes
//
//  Created by Zhicong Zang on 7/27/16.
//  Copyright © 2016 Zhicong Zang. All rights reserved.
//

import UIKit

class NewReminderNC: UINavigationController {
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        navigationBar.hidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
