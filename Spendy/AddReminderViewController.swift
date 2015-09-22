//
//  AddReminderViewController.swift
//  Spendy
//
//  Created by Dave Vo on 9/19/15.
//  Copyright (c) 2015 Cheetah. All rights reserved.
//

import UIKit

class AddReminderViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, TimeCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var addButton: UIButton!
    var backButton: UIButton!
    
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
        
        addGestures()
        
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
        
        backButton = UIButton()
        Helper.sharedInstance.customizeBarButton(self, button: backButton!, imageName: "Back", isLeft: true)
        backButton!.addTarget(self, action: "onBackButton:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func onAddButton(sender: UIButton!) {
        println("on Add")
    }
    
    func onBackButton(sender: UIButton!) {
        println("on Back")
        navigationController?.popViewControllerAnimated(true)
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
            
            var tapSelectCategory = UITapGestureRecognizer(target: self, action: Selector("tapSelectCategory:"))
            tapSelectCategory.delegate = self
            cell.addGestureRecognizer(tapSelectCategory)
            
            Helper.sharedInstance.setSeparatorFullWidth(cell)
            return cell
            
        } else {
            
            if indexPath.row < times.count {
                let cell = tableView.dequeueReusableCellWithIdentifier("TimeCell", forIndexPath: indexPath) as! TimeCell
                
                cell.delegate = self
                cell.timeLabel.text = times[indexPath.row]
                
                var tapAddTime = UITapGestureRecognizer(target: self, action: Selector("tapEditTime:"))
                cell.addGestureRecognizer(tapAddTime)
                
                Helper.sharedInstance.setSeparatorFullWidth(cell)
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("AddTimeCell", forIndexPath: indexPath) as! UITableViewCell
                
                var tapAddTime = UITapGestureRecognizer(target: self, action: Selector("tapAddTime"))
                cell.addGestureRecognizer(tapAddTime)
                
                Helper.sharedInstance.setSeparatorFullWidth(cell)
                return cell
            }
        }
    }
    
    // MARK: Handle gestures
    
    func addGestures() {
        
        var downSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipe:"))
        downSwipe.direction = .Down
        downSwipe.delegate = self
        tableView.addGestureRecognizer(downSwipe)
        
        var leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipe:"))
        leftSwipe.direction = .Left
        leftSwipe.delegate = self
        tableView.addGestureRecognizer(leftSwipe)
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func handleSwipe(sender: UISwipeGestureRecognizer) {
        
        switch sender.direction {
        case UISwipeGestureRecognizerDirection.Down:
            tapAddTime()
            break
            
        case UISwipeGestureRecognizerDirection.Left:
            var selectedCell = Helper.sharedInstance.getCellAtGesture(sender, tableView: tableView) as! TimeCell
            var indexPath = tableView.indexPathForCell(selectedCell)
            
            if let indexPath = indexPath {
                times.removeAtIndex(indexPath.row)
                tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: UITableViewRowAnimation.Automatic)
            }
            break
            
        default:
            break
        }
    }
    
    func tapAddTime() {
        
        DatePickerDialog().show(title: "Choose Time", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", minDate: nil, datePickerMode: .Time) {
            (time) -> Void in
            println(time)
            
            var formatter = NSDateFormatter()
            formatter.dateFormat = "hh:mm a"
            var timeString = formatter.stringFromDate(time)
            println("formated: \(timeString)")
            self.times.append(timeString)
            
            self.tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    func tapEditTime(sender: UITapGestureRecognizer) {
        
        let selectedCell = Helper.sharedInstance.getCellAtGesture(sender, tableView: tableView) as! TimeCell
        let indexPath = tableView.indexPathForCell(selectedCell)
        
        var timeString = selectedCell.timeLabel.text
        var defaultHour: Int? = timeString![0...1].toInt()
        var defaultMin: Int? = timeString![3...4].toInt()
        
        var formatter = NSDateFormatter()
        formatter.dateFormat = "hh:mm a"
        
        var defaultDate = formatter.dateFromString(timeString!)
        
        DatePickerDialog().show(title: "Choose Time", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", defaultDate: defaultDate!, minDate: nil, datePickerMode: .Time) {
            (time) -> Void in
            println(time)
            
            var timeString = formatter.stringFromDate(time)
            println("formated: \(timeString)")
            self.times[indexPath!.row] = timeString
            
            self.tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    func tapSelectCategory(sender: UITapGestureRecognizer) {
        
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        var selectCategoryVC = storyboard.instantiateViewControllerWithIdentifier("SelectAccountOrCategoryVC") as! SelectAccountOrCategoryViewController
        
        selectCategoryVC.itemClass = "Category"
        
        navigationController?.pushViewController(selectCategoryVC, animated: true)
        
    }
    
    // MARK: Implement delegate
    
    func timeCell(timeCell: TimeCell, didChangeValue value: Bool) {
        
        let indexPath = tableView.indexPathForCell(timeCell)!
        println("switch time")
        // TODO: handle time switch
    }
    
}
