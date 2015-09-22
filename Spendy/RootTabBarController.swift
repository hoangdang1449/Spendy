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
        let storyboard = UIStoryboard(name: "Settings", bundle: nil)
        let settingsController = storyboard.instantiateInitialViewController() as UIViewController!

        if var tabControllers = self.viewControllers {
            assert(tabControllers[2] is SettingsViewController, "Expecting the 3rd tab is SettingsController")
            tabControllers[2] = settingsController
            self.setViewControllers(tabControllers, animated: true)
        } else {
            print("Error hooking up Settings tab", terminator: "")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        if item.title == "Add" {
            tabBar.hidden = true
        }
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
