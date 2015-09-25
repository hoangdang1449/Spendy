//
//  QuickViewController.swift
//  Spendy
//
//  Created by Dave Vo on 9/16/15.
//  Copyright (c) 2015 Cheetah. All rights reserved.
//

import UIKit

class QuickViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var popupSuperView: UIView!
    
    @IBOutlet weak var popupView: UIView!
    
    @IBOutlet weak var popupTitleLabel: UILabel!
    
    @IBOutlet weak var amountText: UITextField!
    
    var addButton: UIButton?
    var cancelButton: UIButton?
    
    var commonTracsations = [String]() // transaction object
    var selectedIndexPath: NSIndexPath?
    var oldSelectedSegmentIndex: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load common transactions
        commonTracsations = ["Meal", "Drink", "Transport"]

        tableView.dataSource = self
        tableView.delegate = self
        
        
        tableView.tableFooterView = UIView()
        
        // Swipe up to close Quick mode
        let swipeUp = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipe:"))
        swipeUp.direction = .Up
        swipeUp.delegate = self
        tableView.addGestureRecognizer(swipeUp)
        
        addBarButton()

        
        configPopup()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Button
    
    func addBarButton() {
        
        addButton = UIButton()
        Helper.sharedInstance.customizeBarButton(self, button: addButton!, imageName: "Bar-Tick", isLeft: false)
        addButton!.addTarget(self, action: "onAddButton:", forControlEvents: UIControlEvents.TouchUpInside)
        
        cancelButton = UIButton()
        Helper.sharedInstance.customizeBarButton(self, button: cancelButton!, imageName: "Bar-Cancel", isLeft: true)
        cancelButton!.addTarget(self, action: "onCancelButton:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func onAddButton(sender: UIButton!) {
        print("on Add", terminator: "\n")
        // TODO: transfer to default account's detail
    }
    
    func onCancelButton(sender: UIButton!) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Popup
    
    func configPopup() {
        
        popupSuperView.hidden = true
        popupSuperView.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.5)
        
        popupView.layer.cornerRadius = 5
        popupView.layer.masksToBounds = true
        
        amountText.keyboardType = UIKeyboardType.DecimalPad
        
        popupTitleLabel.backgroundColor = UIColor(netHex: 0x4682B4)
        popupTitleLabel.textColor = UIColor.whiteColor()
        
    }
    
    @IBAction func onCancelPopup(sender: UIButton) {
        
        amountText.text = ""
        
        // TODO: set selected segment depending on object's value
        let cell = tableView.cellForRowAtIndexPath(selectedIndexPath!) as! QuickCell
        cell.amoutSegment.selectedSegmentIndex = oldSelectedSegmentIndex!
        closePopup()
    }
    
    @IBAction func onDonePopup(sender: UIButton) {
        
        if let selectedIndexPath = selectedIndexPath {
            let cell = tableView.cellForRowAtIndexPath(selectedIndexPath) as! QuickCell
            if !amountText.text!.isEmpty {
                cell.amoutSegment.setTitle(amountText.text, forSegmentAtIndex: 3)
                amountText.text = ""
                oldSelectedSegmentIndex = 3
            } else {
                if cell.amoutSegment.titleForSegmentAtIndex(3) == "Other" {
                    // TODO: set selected segment depending on object's value
                    cell.amoutSegment.selectedSegmentIndex = oldSelectedSegmentIndex!
                } else {
                    oldSelectedSegmentIndex = 3
                }
            }
        }
        
        closePopup()
    }
    
    func showPopup() {
        
        popupSuperView.hidden = false
        popupView.transform = CGAffineTransformMakeScale(1.3, 1.3)
        popupView.alpha = 0.0;
        UIView.animateWithDuration(0.25, animations: {
            self.popupView.alpha = 1.0
            self.popupView.transform = CGAffineTransformMakeScale(1.0, 1.0)
        });
        
        amountText.becomeFirstResponder()
        
        // Disable bar button
        addButton?.enabled = false
        cancelButton?.enabled = false
    }
    
    func closePopup() {
        
        UIView.animateWithDuration(0.25, animations: {
            self.popupView.transform = CGAffineTransformMakeScale(1.3, 1.3)
            self.popupView.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished) {
                self.popupSuperView.hidden = true
                self.amountText.resignFirstResponder()
                
                // enable bar button
                self.addButton?.enabled = true
                self.cancelButton?.enabled = true
            }
        });
    }

}

// MARK: Table view

extension QuickViewController: UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commonTracsations.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("QuickCell", forIndexPath: indexPath) as! QuickCell
        
        cell.categoryLabel.text = commonTracsations[indexPath.row]
        
        cell.amoutSegment.addTarget(self, action: "amountSegmentChanged:", forControlEvents: UIControlEvents.ValueChanged)
        
        // Swipe left to delete this row
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipe:"))
        leftSwipe.direction = .Left
        cell.addGestureRecognizer(leftSwipe)
        
        
        Helper.sharedInstance.setSeparatorFullWidth(cell)
        
        return cell
    }
    
    func amountSegmentChanged(sender: UISegmentedControl) {
        
        print("touch", terminator: "\n")
        
        let segment = sender as! CustomSegmentedControl
        oldSelectedSegmentIndex = segment.oldValue
        
        if sender.selectedSegmentIndex == 3 {
            let selectedCell = sender.superview?.superview as! QuickCell
            let indexPath = tableView.indexPathForCell(selectedCell)
            selectedIndexPath = indexPath
            showPopup()
        }
    }
    
    // MARK: Handle gestures
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func handleSwipe(sender:UISwipeGestureRecognizer) {
        
        switch sender.direction {
        case UISwipeGestureRecognizerDirection.Left:
            let selectedCell = sender.view as! QuickCell
            let indexPath = tableView.indexPathForCell(selectedCell)
            commonTracsations.removeAtIndex(indexPath!.row)
            tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
            
            if commonTracsations.count == 0 {
                dismissViewControllerAnimated(true, completion: nil)
            }
            break
            
        case UISwipeGestureRecognizerDirection.Up:
            dismissViewControllerAnimated(true, completion: nil)
            break
            
        default:
            break
        }
        
        
    }
}



