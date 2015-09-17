//
//  AccountsViewController.swift
//  Spendy
//
//  Created by Dave Vo on 9/17/15.
//  Copyright (c) 2015 Cheetah. All rights reserved.
//

import UIKit

class AccountsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var accounts = [String]() // Account object

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
        accounts = ["Default Account", "Debit", "Saving"]
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        cell.addGestureRecognizer(rightSwipe)
        
        Helper.sharedInstance.setSeparatorFullWidth(cell)
        return cell
    }
    
    
    func handleRightSwipe(sender:UISwipeGestureRecognizer) {
        
        var selectedCell = sender.view as! AccountCell
        var indexPath = tableView.indexPathForCell(selectedCell)
        accounts.removeAtIndex(indexPath!.row)
        tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
        
        
    }

}
