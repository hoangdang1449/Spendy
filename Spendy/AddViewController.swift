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
    
    
    var addButton: UIButton?
    var cancelButton: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarController?.tabBar.hidden = true
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
        
        
        
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
        headerView.backgroundColor = UIColor.grayColor()
        if section == 0 {
            
        } else {
            
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
                let cell = tableView.dequeueReusableCellWithIdentifier("PayeeCell", forIndexPath: indexPath) as! PayeeCell
                Helper.sharedInstance.setSeparatorFullWidth(cell)
                return cell
            case 1:
                let cell = tableView.dequeueReusableCellWithIdentifier("AmountCell", forIndexPath: indexPath) as! AmountCell
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
                Helper.sharedInstance.setSeparatorFullWidth(cell)
                return cell
            case 1:
                let cell = tableView.dequeueReusableCellWithIdentifier("SelectCategoryCell", forIndexPath: indexPath) as! SelectCategoryCell
                Helper.sharedInstance.setSeparatorFullWidth(cell)
                return cell
            case 2:
                let cell = tableView.dequeueReusableCellWithIdentifier("DateCell", forIndexPath: indexPath) as! DateCell
                Helper.sharedInstance.setSeparatorFullWidth(cell)
                return cell
            default:
                break
            }
            
            
            return dummyCell
        }
    }

}
