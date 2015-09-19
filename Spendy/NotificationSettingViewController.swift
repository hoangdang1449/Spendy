//
//  NotificationSettingViewController.swift
//  Spendy
//
//  Created by Dave Vo on 9/19/15.
//  Copyright (c) 2015 Cheetah. All rights reserved.
//

import UIKit
//import SevenSwitch

//@objc protocol SwitchCellDelegate {
//    optional func switchCell(switchCell: SwitchCell, didChangeValue value: Bool)
//}

class NotificationSettingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, ReminderCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!

    var addButton: UIButton!
    var backButton: UIButton!
    
    var remiders = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
        remiders = ["Meal", "Drink", "Transport"]
        
        addBarButton()
        
        var downSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleDownSwipe:"))
        downSwipe.direction = .Down
        downSwipe.delegate = self
        tableView.addGestureRecognizer(downSwipe)
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
        
        backButton = UIButton()
        Helper.sharedInstance.customizeBarButton(self, button: backButton!, imageName: "Back", isLeft: true)
        backButton!.addTarget(self, action: "onBackButton:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func onAddButton(sender: UIButton!) {
        println("on Add")
        // TODO: Save changes
    }
    
    func onBackButton(sender: UIButton!) {
        println("on Back")
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Table view
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return remiders.count + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row != remiders.count {
            let cell = tableView.dequeueReusableCellWithIdentifier("ReminderCell", forIndexPath: indexPath) as! ReminderCell
            
            cell.categoryLabel.text = remiders[indexPath.row]
            
            cell.delegate = self
            
            Helper.sharedInstance.setSeparatorFullWidth(cell)
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("AddReminderCell", forIndexPath: indexPath) as! UITableViewCell
            
            Helper.sharedInstance.setSeparatorFullWidth(cell)
            return cell
        }
    }
    
    // MARK: Handle gesture
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func handleDownSwipe(sender: UISwipeGestureRecognizer) {
        
        if sender.direction == .Down {
            var vc = self.storyboard?.instantiateViewControllerWithIdentifier("AddReminderVC") as! AddReminderViewController
            var nc = UINavigationController(rootViewController: vc)
            self.presentViewController(nc, animated: true, completion: nil)
        }
    }
    
    // MARK: Implement delegate
    
    func reminderCell(reminderCell: ReminderCell, didChangeValue value: Bool) {
        
        let indexPath = tableView.indexPathForCell(reminderCell)!
        println("switch cell")
        //TODO: handle switch change
    }
    
    // MARK: Transfer between 2 views
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let navigationController = segue.destinationViewController as! UINavigationController
        
        if navigationController.topViewController is AddReminderViewController {
            let addViewController = navigationController.topViewController as! AddReminderViewController
            
            var indexPath: AnyObject!
            indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
            
            // If select 1 remider
            if indexPath.row < remiders.count {
                addViewController.selectedRemider = remiders[indexPath.row]
            }
        }
    }
    

}
