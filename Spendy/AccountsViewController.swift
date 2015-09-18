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
        
        var rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleRightSwipe:"))
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
    
    func handleRightSwipe(sender:UISwipeGestureRecognizer) {
        
        var selectedCell = sender.view as! AccountCell
        var indexPath = tableView.indexPathForCell(selectedCell)
        
        
        let alertView = SCLAlertView()
        alertView.addButton("Delete", action: { () -> Void in
            self.accounts.removeAtIndex(indexPath!.row)
            self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
            // TODO: Delete this account and its transactions
        })
        
//        alertView.showWarning("Warning", subTitle: "Deleting Saving will cause to also delete its transactions.")
        alertView.showWarning("Warning", subTitle: "Deleting Saving will cause to also delete its transactions.", closeButtonTitle: "Cancel", colorStyle: 0x55AEED, colorTextButton: 0xFFFFFF)
    }
    
    func handlePanGesture(sender: UIPanGestureRecognizer) {
        
        selectedDragCell = sender.view as! AccountCell
        var indexPath = tableView.indexPathForCell(selectedDragCell!)
        
        selectedDragCell?.backgroundColor = UIColor(netHex: 0xCAE1FF)
        
        
        var translation = sender.translationInView(tableView)
        var state = sender.state
        if state == UIGestureRecognizerState.Began {
            
            moneyIcon = UIImageView(image: UIImage(named: "MoneyBag"))
            moneyIcon!.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
            moneyIcon!.userInteractionEnabled = true
            
            tableView.addSubview(moneyIcon!)
            
            moneyIcon!.center = sender.locationInView(tableView)
            initialIconCenter = moneyIcon?.center
        }
        
        if state == UIGestureRecognizerState.Changed {
            
            moneyIcon!.center.x = initialIconCenter!.x + translation.x
            moneyIcon!.center.y = initialIconCenter!.y + translation.y
            
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
        
        if state == UIGestureRecognizerState.Ended {
            
            moneyIcon?.removeFromSuperview()
            selectedDragCell?.backgroundColor = UIColor.clearColor()
            previousCell?.backgroundColor = UIColor.clearColor()
            
            if previousCell != selectedDragCell {
                
                let fromAcc = selectedDragCell?.nameLabel.text ?? ""
                let toAcc = previousCell?.nameLabel.text ?? ""
                
                let alert = SCLAlertView()
                let txt = alert.addAmoutField(title: "Enter the amount")
                alert.addButton("Transfer") {
                    println("Amount value: \(txt.text)")
                }
                alert.showEdit("Transfer", subTitle: "Transfer from \(fromAcc) account to \(toAcc) account", closeButtonTitle: "Cancel", colorStyle: 0x55AEED, colorTextButton: 0xFFFFFF)
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
