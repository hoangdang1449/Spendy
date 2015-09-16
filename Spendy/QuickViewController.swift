//
//  QuickViewController.swift
//  Spendy
//
//  Created by Dave Vo on 9/16/15.
//  Copyright (c) 2015 Cheetah. All rights reserved.
//

import UIKit

class QuickViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
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
        
        addBarButton()

        
        configPopup()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Table view
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commonTracsations.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("QuickCell", forIndexPath: indexPath) as! QuickCell
        
        cell.categoryLabel.text = commonTracsations[indexPath.row]
        
        cell.amoutSegment.addTarget(self, action: "amountSegmentChanged:", forControlEvents: UIControlEvents.ValueChanged)

        var rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleRightSwipe:"))
        rightSwipe.direction = .Right
        cell.addGestureRecognizer(rightSwipe)
        
        
        
        Helper.sharedInstance.setSeparatorFullWidth(cell)
        
        return cell
    }
    
    func amountSegmentChanged(sender: UISegmentedControl) {
        
        println("touch")
        
        var segment = sender as! CustomSegmentedControl
        oldSelectedSegmentIndex = segment.oldValue
        
        if sender.selectedSegmentIndex == 3 {
            var selectedCell = sender.superview?.superview as! QuickCell
            var indexPath = tableView.indexPathForCell(selectedCell)
            selectedIndexPath = indexPath
            showPopup()
        }
    }
    
    func handleRightSwipe(sender:UISwipeGestureRecognizer) {
        
        var selectedCell = sender.view as! QuickCell
        var indexPath = tableView.indexPathForCell(selectedCell)
        commonTracsations.removeAtIndex(indexPath!.row)
        tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
        
        if commonTracsations.count == 0 {
            // TODO: same as onCancelButton
        }
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
    
//    func customizeBarButton(button: UIButton, imageName: String, isLeft: Bool) {
//        
//        var avatar = UIImageView(frame: CGRect(x: 0, y: 0, width: 22, height: 22))
//        avatar.image = UIImage(named: imageName)
//        
//        button.setImage(avatar.image, forState: .Normal)
//        button.frame = CGRectMake(0, 0, 22, 22)
//        
//        var item: UIBarButtonItem = UIBarButtonItem()
//        item.customView = button
////        item.customView?.layer.cornerRadius = 11
////        item.customView?.layer.masksToBounds = true
//        if isLeft {
//            self.navigationItem.leftBarButtonItem = item
//        } else {
//            self.navigationItem.rightBarButtonItem = item
//        }
//    }
    
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
        var cell = tableView.cellForRowAtIndexPath(selectedIndexPath!) as! QuickCell
        cell.amoutSegment.selectedSegmentIndex = oldSelectedSegmentIndex!
        closePopup()
    }
    
    @IBAction func onDonePopup(sender: UIButton) {
        
        if let selectedIndexPath = selectedIndexPath {
            var cell = tableView.cellForRowAtIndexPath(selectedIndexPath) as! QuickCell
            if !amountText.text.isEmpty {
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

extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}



