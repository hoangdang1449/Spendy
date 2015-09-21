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
    
    func getCellAtGesture(gestureRecognizer: UIGestureRecognizer, tableView: UITableView) -> UITableViewCell? {
        var location = gestureRecognizer.locationInView(tableView)
        var indexPath = tableView.indexPathForRowAtPoint(location)
        if let indexPath = indexPath {
            return tableView.cellForRowAtIndexPath(indexPath)!
        } else {
            return nil
        }
    }
    
    func getCurrentWeek() -> (NSDate?, NSDate?) {
        
        var beginningOfWeek: NSDate?
        var endOfWeek: NSDate?
        
        let cal = NSCalendar.currentCalendar()
        
        let components = NSDateComponents()
        components.weekOfYear = 0
        
        if let date = cal.dateByAddingComponents(components, toDate: NSDate(), options: NSCalendarOptions(0)) {
            var weekDuration = NSTimeInterval()
            if cal.rangeOfUnit(.CalendarUnitWeekOfYear, startDate: &beginningOfWeek, interval: &weekDuration, forDate: date) {
                endOfWeek = beginningOfWeek?.dateByAddingTimeInterval(weekDuration)
            }
            
            beginningOfWeek = cal.dateByAddingUnit(NSCalendarUnit.DayCalendarUnit, value: 1, toDate: beginningOfWeek!, options: NSCalendarOptions(0))
            
        }
        
        return (beginningOfWeek!, endOfWeek!)
    }
}

extension String {
    
    subscript (r: Range<Int>) -> String {
        get {
            let startIndex = advance(self.startIndex, r.startIndex)
            let endIndex = advance(startIndex, r.endIndex - r.startIndex)
            return self[Range(start: startIndex, end: endIndex)]
        }
    }
    
    func replace(target: String, withString: String) -> String {
        return self.stringByReplacingOccurrencesOfString(target, withString: withString, options: NSStringCompareOptions.LiteralSearch, range: nil)
    }
}
