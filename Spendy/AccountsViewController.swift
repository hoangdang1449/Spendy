//
//  AccountsViewController.swift
//  Spendy
//
//  Created by Dave Vo on 9/17/15.
//  Copyright (c) 2015 Cheetah. All rights reserved.
//

import UIKit
import SCLAlertView

class AccountsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var addAccountButton: UIButton?
    
    var accounts = [String]() // Account object
    
    var isPreparedDelete = false
    var justTurnOffDelete = false
    var selectedDeleteCell: AccountCell?
    
    var moneyIcon: UIImageView?
    var initialIconCenter: CGPoint?
    var selectedDragCell: AccountCell?
    var previousCell: AccountCell?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
        accounts = ["Default Account", "Debit", "Saving"]
        tableView.reloadData()
        
        if (tableView.contentSize.height <= tableView.frame.size.height) {
            tableView.scrollEnabled = false
        }
        else {
            tableView.scrollEnabled = true
        }
        
        addBarButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Button
    
    func addBarButton() {
        
        addAccountButton = UIButton()
        Helper.sharedInstance.customizeBarButton(self, button: addAccountButton!, imageName: "AddAccount", isLeft: false)
        addAccountButton!.addTarget(self, action: "onAddAccountButton:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func onAddAccountButton(sender: UIButton!) {
        println("on Add account")
    }

    // MARK: Table View
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AccountCell", forIndexPath: indexPath) as! AccountCell
        
        cell.nameLabel.text = accounts[indexPath.row]
        
        var leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipe:"))
        leftSwipe.direction = .Left
        leftSwipe.delegate = self
        cell.addGestureRecognizer(leftSwipe)
        
        var rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipe:"))
        rightSwipe.direction = .Right
        rightSwipe.delegate = self
        cell.addGestureRecognizer(rightSwipe)
        
        var panGesture = UIPanGestureRecognizer(target: self, action: Selector("handlePanGesture:"))
        panGesture.delegate = self
        cell.addGestureRecognizer(panGesture)
        
        Helper.sharedInstance.setSeparatorFullWidth(cell)
        return cell
    }
    
    // MARK: Handle gestures
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func handleSwipe(sender:UISwipeGestureRecognizer) {
        
        if sender.direction == .Left {
            println("left")
            var selectedCell = sender.view as! AccountCell
            var indexPath = tableView.indexPathForCell(selectedCell)
            
            if !isPreparedDelete {
                if selectedCell.frame.origin.x == 0 {
                    isPreparedDelete = true
                    selectedDeleteCell = selectedCell
                    
                    var deleteLabel = UILabel(frame: CGRect(x: UIScreen.mainScreen().bounds.width, y: 0, width: 70, height: 55))
                    deleteLabel.text = "Delete"
                    deleteLabel.textColor = UIColor.whiteColor()
                    deleteLabel.backgroundColor = UIColor.redColor()
                    deleteLabel.textAlignment = NSTextAlignment.Center
                    deleteLabel.font = UIFont.systemFontOfSize(14)
                    
                    selectedCell.contentView.addSubview(deleteLabel)
                    
                    deleteLabel.userInteractionEnabled = true
                    var tapDelete = UITapGestureRecognizer(target: self, action: Selector("tapDelete:"))
                    tapDelete.numberOfTapsRequired = 1
                    tapDelete.delaysTouchesBegan = true
                    tapDelete.cancelsTouchesInView = true
                    tapDelete.delegate = self
                    deleteLabel.addGestureRecognizer(tapDelete)
                    
//                    selectedCell.contentView.addSubview(deleteLabel)
                    
//                    var deleteButton = UIButton(frame: CGRect(x: UIScreen.mainScreen().bounds.width, y: 0, width: 70, height: 55))
//                    deleteButton.setTitle("Delete", forState: .Normal)
//                    deleteButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
//                    deleteButton.backgroundColor = UIColor.redColor()
//                    deleteButton.titleLabel?.textAlignment = .Center
//                    deleteButton.titleLabel?.font = UIFont.systemFontOfSize(14)
//                    
//                    println("add target button")
////                    deleteButton.addTarget(self, action: Selector("tapDelete:"), forControlEvents: UIControlEvents.TouchUpInside)
//                    deleteButton.addTarget(self, action: "tapDeleteaa:", forControlEvents: UIControlEvents.TouchUpInside)
//                    selectedCell.contentView.addSubview(deleteButton)
                    
                    UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 2, options: nil, animations: { () -> Void in
                        selectedCell.center = CGPoint(x: selectedCell.center.x - 70, y: selectedCell.center.y)
                        }, completion: { (bool) -> Void in
                            println("animated: \(bool)")
                    })
                } else {
                    turnOffDelete(selectedCell)
                }
            } else {
                turnOffDelete(selectedDeleteCell!)
            }
        } else {
            println("right")
            if isPreparedDelete {
                turnOffDelete(selectedDeleteCell!)
            }
        }
    }
    
    func turnOffDelete(cell: AccountCell) {
        self.isPreparedDelete = false
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            cell.center = CGPoint(x: cell.center.x + 70, y: cell.center.y)
        })
    }
    
    func tapDelete(sender: UITapGestureRecognizer) {
        
        println("tap delete")
        var indexPath = tableView.indexPathForCell(selectedDeleteCell!)
        let alertView = SCLAlertView()
        alertView.addButton("Delete", action: { () -> Void in
            self.accounts.removeAtIndex(indexPath!.row)
            self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
            // TODO: Delete this account and its transactions
        })
        
        alertView.showWarning("Warning", subTitle: "Deleting Saving will cause to also delete its transactions.", closeButtonTitle: "Cancel", colorStyle: 0x55AEED, colorTextButton: 0xFFFFFF)
    }
    
    func handlePanGesture(sender: UIPanGestureRecognizer) {
        println("pan")
        var translation = sender.translationInView(tableView)
        var state = sender.state
        
        if isPreparedDelete {
            if state == UIGestureRecognizerState.Began {
                turnOffDelete(selectedDeleteCell!)
                justTurnOffDelete = true
                return
            }
        }
        
        selectedDragCell = sender.view as? AccountCell
        var indexPath = tableView.indexPathForCell(selectedDragCell!)
        
        if state == UIGestureRecognizerState.Began && !isPreparedDelete {
            println("began")
            selectedDragCell?.backgroundColor = UIColor(netHex: 0xCAE1FF)
            moneyIcon = UIImageView(image: UIImage(named: "MoneyBag"))
            moneyIcon!.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
            moneyIcon!.userInteractionEnabled = true
            
            tableView.addSubview(moneyIcon!)
            
            moneyIcon!.center = sender.locationInView(tableView)
            initialIconCenter = moneyIcon?.center
        }
        
        if state == UIGestureRecognizerState.Changed && !isPreparedDelete {
            println("change")
            
            // if just turn off delete in .Began, do nothing
            if !justTurnOffDelete {
                if let moneyIcon = moneyIcon {
                    moneyIcon.center.x = initialIconCenter!.x + translation.x
                    moneyIcon.center.y = initialIconCenter!.y + translation.y
                }
                
                // Highlight the destination cell
                var cell = getContainAccountCell(moneyIcon!.center)
                if cell != selectedDragCell {
                    if cell != previousCell {
                        previousCell?.backgroundColor = UIColor.clearColor()
                        if let cell = cell {
                            cell.backgroundColor = UIColor(netHex: 0x739AC5)
                        }
                        previousCell = cell
                    }
                } else {
                    if previousCell != selectedDragCell {
                        previousCell?.backgroundColor = UIColor.clearColor()
                    }
                    previousCell = cell
                }
            }
        }
        
        if state == UIGestureRecognizerState.Ended {
            
            moneyIcon?.removeFromSuperview()
            selectedDragCell?.backgroundColor = UIColor.clearColor()
            previousCell?.backgroundColor = UIColor.clearColor()
            
            // if just turn off delete in .Began, do nothing
            if !justTurnOffDelete {
                if previousCell != selectedDragCell && !isPreparedDelete {
                    
                    let fromAcc = selectedDragCell?.nameLabel.text ?? ""
                    let toAcc = previousCell?.nameLabel.text ?? ""
                    
                    if !fromAcc.isEmpty && !toAcc.isEmpty {
                        let alert = SCLAlertView()
                        let txt = alert.addAmoutField(title: "Enter the amount")
                        alert.addButton("Transfer") {
                            println("Amount value: \(txt.text)")
                        }
                        alert.showEdit("Transfer", subTitle: "Transfer from \(fromAcc) account to \(toAcc) account", closeButtonTitle: "Cancel", colorStyle: 0x55AEED, colorTextButton: 0xFFFFFF)
                    }
                }
            } else {
                justTurnOffDelete = false
            }
        }
    }
    
    func getContainAccountCell(point: CGPoint) -> AccountCell? {
        var indexPathSet = [NSIndexPath]()
        
        for index in 0..<accounts.count {
            indexPathSet.append(NSIndexPath(forRow: index, inSection: 0))
        }
        
        for indexPath in indexPathSet {
            var rect = tableView.rectForRowAtIndexPath(indexPath)
            if rect.contains(point) {
                return tableView.cellForRowAtIndexPath(indexPath) as? AccountCell
            }
        }
        
        return nil
    }
    
    

}
