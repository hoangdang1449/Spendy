//
//  RootTabBarController.swift
//  Spendy
//
//  Created by Harley Trung on 9/17/15.
//  Copyright (c) 2015 Cheetah. All rights reserved.
//

import UIKit

class RootTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        // Load Settings storyboard's initial controller
        // Replace the Settings placeholder controller
        var storyboard = UIStoryboard(name: "Settings", bundle: nil)
        var settingsController = storyboard.instantiateInitialViewController() as! UIViewController

        if var tabControllers = self.viewControllers {
            assert(tabControllers[2] is SettingsViewController, "Expecting the 3rd tab is SettingsController")
            tabControllers[2] = settingsController
            self.setViewControllers(tabControllers, animated: true)
        } else {
            print("Error hooking up Settings tab")
        }
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

}
