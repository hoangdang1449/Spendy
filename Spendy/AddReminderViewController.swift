//
//  AddReminderViewController.swift
//  Spendy
//
//  Created by Dave Vo on 9/19/15.
//  Copyright (c) 2015 Cheetah. All rights reserved.
//

import UIKit

class AddReminderViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TimeCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var addButton: UIButton!
    var cancelButton: UIButton!
    
    var selectedRemider: String!
    
    var times = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBarButton()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
        if selectedRemider != nil {
            navigationItem.title = "Edit Reminder"
        }
        
        times = ["08:00 AM", "02:00 PM", "07:00 PM"]
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
        println("on Cancel")
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Table view
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        } else {
            return times.count + 1
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 30))
        headerView.backgroundColor = UIColor(netHex: 0xDCDCDC)
        
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 34
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("CategoryReminderCell", forIndexPath: indexPath) as! CategoryReminderCell
            
            if let selectedRemider = selectedRemider {
                cell.categoryLabel.text = selectedRemider
            }
            
            Helper.sharedInstance.setSeparatorFullWidth(cell)
            return cell
            
        } else {
            
            if indexPath.row < times.count {
                let cell = tableView.dequeueReusableCellWithIdentifier("TimeCell", forIndexPath: indexPath) as! TimeCell
                
                cell.delegate = self
                cell.timeLabel.text = times[indexPath.row]
                
                var leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipe:"))
                leftSwipe.direction = .Left
                cell.addGestureRecognizer(leftSwipe)
                
                Helper.sharedInstance.setSeparatorFullWidth(cell)
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("AddTimeCell", forIndexPath: indexPath) as! UITableViewCell
                
                Helper.sharedInstance.setSeparatorFullWidth(cell)
                return cell
            }
            
            
        }
    }
    
    func handleSwipe(sender: UISwipeGestureRecognizer) {
        
        if sender.direction == .Left {
            var selectedCell = sender.view as! TimeCell
            var indexPath = tableView.indexPathForCell(selectedCell)
            
            if let indexPath = indexPath {
                times.removeAtIndex(indexPath.row)
                tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: UITableViewRowAnimation.Automatic)
            }
        }
        
        
        
    }
    
    // MARK: Implement delegate
    
    func timeCell(timeCell: TimeCell, didChangeValue value: Bool) {
        
        let indexPath = tableView.indexPathForCell(timeCell)!
        println("switch time")
        // TODO: handle time switch
    }
    

}
