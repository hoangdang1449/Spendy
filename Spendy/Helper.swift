//
//  Helper.swift
//  Spendy
//
//  Created by Dave Vo on 9/16/15.
//  Copyright (c) 2015 Cheetah. All rights reserved.
//

import UIKit

class Helper: NSObject {
    
    static let sharedInstance = Helper()
   
    func customizeBarButton(viewController: UIViewController, button: UIButton, imageName: String, isLeft: Bool) {
        
        let avatar = UIImageView(frame: CGRect(x: 0, y: 0, width: 22, height: 22))
        avatar.image = UIImage(named: imageName)
        
        button.setImage(avatar.image, forState: .Normal)
        button.frame = CGRectMake(0, 0, 22, 22)
        
        let item: UIBarButtonItem = UIBarButtonItem()
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
    
    func getCellAtGesture(gestureRecognizer: UIGestureRecognizer, tableView: UITableView) -> UITableViewCell? {
        let location = gestureRecognizer.locationInView(tableView)
        let indexPath = tableView.indexPathForRowAtPoint(location)
        if let indexPath = indexPath {
            return tableView.cellForRowAtIndexPath(indexPath)!
        } else {
            return nil
        }
    }
    
    func getWeek(weekOfYear: Int) -> (NSDate?, NSDate?) {
        
        var beginningOfWeek: NSDate?
        var endOfWeek: NSDate?
        
        let cal = NSCalendar.currentCalendar()
        
        let components = NSDateComponents()
        components.weekOfYear = weekOfYear
        
        if let date = cal.dateByAddingComponents(components, toDate: NSDate(), options: NSCalendarOptions(rawValue: 0)) {
            var weekDuration = NSTimeInterval()
            if cal.rangeOfUnit(NSCalendarUnit.NSWeekOfYearCalendarUnit, startDate: &beginningOfWeek, interval: &weekDuration, forDate: date) {
                endOfWeek = beginningOfWeek?.dateByAddingTimeInterval(weekDuration)
            }
            
            beginningOfWeek = cal.dateByAddingUnit(NSCalendarUnit.NSDayCalendarUnit, value: 1, toDate: beginningOfWeek!, options: NSCalendarOptions(rawValue: 0))
            
        }
        
        return (beginningOfWeek!, endOfWeek!)
    }
    
    func showActionSheet(viewController: UIViewController, imagePicker: UIImagePickerController) {
        
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let takePhotoAction = UIAlertAction(title: "Take a Photo", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Take a Photo", terminator: "\n")
            
            imagePicker.allowsEditing = false
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureMode.Photo
            imagePicker.modalPresentationStyle = .FullScreen
            viewController.presentViewController(imagePicker, animated: true, completion: nil)
        })
        
        let photoLibraryAction = UIAlertAction(title: "Photo from Library", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Photo from Library", terminator: "\n")
            
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .PhotoLibrary
            viewController.presentViewController(imagePicker, animated: true, completion: nil)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled", terminator: "\n")
        })
        
        optionMenu.addAction(takePhotoAction)
        optionMenu.addAction(photoLibraryAction)
        optionMenu.addAction(cancelAction)
        
        viewController.presentViewController(optionMenu, animated: true, completion: nil)
    }
}

extension String {
    
    subscript (r: Range<Int>) -> String {
        get {
            let startIndex = self.startIndex.advancedBy(r.startIndex)
            let endIndex = startIndex.advancedBy(r.endIndex - r.startIndex)
            return self[Range(start: startIndex, end: endIndex)]
        }
    }
    
    func replace(target: String, withString: String) -> String {
        return self.stringByReplacingOccurrencesOfString(target, withString: withString, options: NSStringCompareOptions.LiteralSearch, range: nil)
    }
}

enum ViewMode: Int {
    case Weekly = 0,
    Monthly,
    Yearly,
    Custom
}
