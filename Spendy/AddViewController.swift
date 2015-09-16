//
//  AddViewController.swift
//  Spendy
//
//  Created by Dave Vo on 9/16/15.
//  Copyright (c) 2015 Cheetah. All rights reserved.
//

import UIKit

class AddViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    
    var addButton: UIButton?
    var cancelButton: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarController?.tabBar.hidden = true
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
        
        datePicker.alpha = 0
        datePicker.backgroundColor = UIColor.whiteColor()
        
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
        println("on Cancel")
    }

    // MARK: Table View
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else {
            return 3
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 30))
        headerView.backgroundColor = UIColor(netHex: 0xDCDCDC)
        
        if section == 0 {
            var todayLabel = UILabel(frame: CGRect(x: 8, y: 2, width: UIScreen.mainScreen().bounds.width - 16, height: 30))
            todayLabel.font = UIFont.systemFontOfSize(14)
            
            let today = NSDate()
            var formatter = NSDateFormatter()
            formatter.dateStyle = NSDateFormatterStyle.FullStyle
            todayLabel.text = formatter.stringFromDate(today)
            
            headerView.addSubview(todayLabel)
        }
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 34
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let dummyCell = UITableViewCell()
        
        if indexPath.section == 0 {
            
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCellWithIdentifier("NoteCell", forIndexPath: indexPath) as! NoteCell
                
                var tapCell = UITapGestureRecognizer(target: self, action: "tapNoteCell:")
                cell.addGestureRecognizer(tapCell)
                
                Helper.sharedInstance.setSeparatorFullWidth(cell)
                return cell
            case 1:
                let cell = tableView.dequeueReusableCellWithIdentifier("AmountCell", forIndexPath: indexPath) as! AmountCell
                
                var tapCell = UITapGestureRecognizer(target: self, action: "tapAmoutCell:")
                cell.addGestureRecognizer(tapCell)
                
                cell.typeSegment.addTarget(self, action: "typeSegmentChanged:", forControlEvents: UIControlEvents.ValueChanged)
                
                cell.amountText.keyboardType = UIKeyboardType.DecimalPad
                Helper.sharedInstance.setSeparatorFullWidth(cell)
                return cell
            default:
                break
            }
            
            return dummyCell
            
        } else {
            
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCellWithIdentifier("SelectCategoryCell", forIndexPath: indexPath) as! SelectCategoryCell
                
                cell.titleLabel.text = "Category"
                cell.typeLabel.text = "Other"
                
                Helper.sharedInstance.setSeparatorFullWidth(cell)
                return cell
            case 1:
                let cell = tableView.dequeueReusableCellWithIdentifier("SelectCategoryCell", forIndexPath: indexPath) as! SelectCategoryCell
                
                cell.titleLabel.text = "Account"
                cell.typeLabel.text = "Cash"
                
                Helper.sharedInstance.setSeparatorFullWidth(cell)
                return cell
            case 2:
                let cell = tableView.dequeueReusableCellWithIdentifier("DateCell", forIndexPath: indexPath) as! DateCell
                
                var tapCell = UITapGestureRecognizer(target: self, action: "tapDateCell:")
                cell.addGestureRecognizer(tapCell)
                
                Helper.sharedInstance.setSeparatorFullWidth(cell)
                return cell
            default:
                break
            }
            
            
            return dummyCell
        }
    }
    
    func tapNoteCell(sender: UITapGestureRecognizer) {
        var noteCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! NoteCell
        noteCell.noteText.becomeFirstResponder()
    }
    
    func tapAmoutCell(sender: UITapGestureRecognizer) {
        var amountCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0)) as! AmountCell
        amountCell.amountText.becomeFirstResponder()
    }
    
    func tapDateCell(sender: UITapGestureRecognizer) {
        var noteCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! NoteCell
        noteCell.noteText.resignFirstResponder()
        
        var amountCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0)) as! AmountCell
        amountCell.amountText.resignFirstResponder()
        
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.datePicker.alpha = 1.0
            }, completion: nil)
    
    }

    func typeSegmentChanged(sender: UISegmentedControl) {
        
        var fromCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 1)) as! SelectCategoryCell
        var toCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 1)) as! SelectCategoryCell
        
        if sender.selectedSegmentIndex == 2 {
            
            fromCell.titleLabel.text = "From Account"
            fromCell.typeLabel.text = "None"
            toCell.titleLabel.text = "To Account"
            toCell.typeLabel.text = "None"
            
        } else {
            
            fromCell.titleLabel.text = "Category"
            fromCell.typeLabel.text = "Other"
            toCell.titleLabel.text = "Account"
            toCell.typeLabel.text = "Cash"
        }
    }
    
    @IBAction func onDatePicker(sender: AnyObject) {
    
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "E, MMM dd, yyyy"
        var strDate = dateFormatter.stringFromDate(datePicker.date)
        
        var cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 2, inSection: 1)) as! DateCell
        
        cell.dateLabel.text = strDate
    }
}
