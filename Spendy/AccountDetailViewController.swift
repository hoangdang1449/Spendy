//
//  AccountDetailViewController.swift
//  Spendy
//
//  Created by Dave Vo on 9/18/15.
//  Copyright (c) 2015 Cheetah. All rights reserved.
//

import UIKit

class AccountDetailViewController: UIViewController {
    
    
    var addButton: UIButton?
    var cancelButton: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()

        
        addBarButton()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Button
    
    func addBarButton() {
        
        addButton = UIButton()
        Helper.sharedInstance.customizeBarButton(self, button: addButton!, imageName: "Tick", isLeft: false)
        addButton!.addTarget(self, action: "onAddButton:", forControlEvents: UIControlEvents.TouchUpInside)
        
        cancelButton = UIButton()
        Helper.sharedInstance.customizeBarButton(self, button: cancelButton!, imageName: "Cancel", isLeft: true)
        cancelButton!.addTarget(self, action: "onCancelButton:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func onAddButton(sender: UIButton!) {
        println("on Add")
    }
    
    func onCancelButton(sender: UIButton!) {
        dismissViewControllerAnimated(true, completion: nil)
        
    }

    

}
