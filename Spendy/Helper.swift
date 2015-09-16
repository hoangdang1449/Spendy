//
//  Helper.swift
//  Spendy
//
//  Created by Dave Vo on 9/16/15.
//  Copyright (c) 2015 Cheetah. All rights reserved.
//

import UIKit

class Helper: NSObject {
   
    class var sharedInstance: Helper {
        struct Static {
            static let instance = Helper()
        }
        
        return Static.instance
    }
    
    func customizeBarButton(viewController: UIViewController, button: UIButton, imageName: String, isLeft: Bool) {
        
        var avatar = UIImageView(frame: CGRect(x: 0, y: 0, width: 22, height: 22))
        avatar.image = UIImage(named: imageName)
        
        button.setImage(avatar.image, forState: .Normal)
        button.frame = CGRectMake(0, 0, 22, 22)
        
        var item: UIBarButtonItem = UIBarButtonItem()
        item.customView = button
        //        item.customView?.layer.cornerRadius = 11
        //        item.customView?.layer.masksToBounds = true
        if isLeft {
            viewController.navigationItem.leftBarButtonItem = item
        } else {
            viewController.navigationItem.rightBarButtonItem = item
        }
    }
    
    func setSeparatorFullWidth(cell: UITableViewCell) {
        // Set full width for the separator
        cell.layoutMargins = UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsetsZero
    }
    
}
