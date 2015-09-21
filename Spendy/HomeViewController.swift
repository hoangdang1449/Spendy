//
//  HomeViewController.swift
//  Spendy
//
//  Created by Dave Vo on 9/16/15.
//  Copyright (c) 2015 Cheetah. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var statusBarView: UIView!
    
    @IBOutlet weak var currentBarView: UIView!
    
    @IBOutlet weak var currentBarWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var todayLabel: UILabel!
    
    
    
    @IBOutlet weak var popupDateSuperView: UIView!
    
    let dayCountInMonth = 30
    
    var incomes = [String]()
    var expenses = [String]()
    
    var isCollapedIncome = true
    var isCollapedExpense = true
    
    var viewMode: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingStatusBar()
        
        viewMode = "Month"
        
        navigationItem.title = getTodayString("MMMM")
        var tapTitle = UITapGestureRecognizer(target: self, action: Selector("chooseMode:"))
        navigationController?.navigationBar.addGestureRecognizer(tapTitle)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
        incomes = ["Salary", "Bonus"]
        expenses = ["Meal", "Drink", "Transport"]
        
        
        
        popupDateSuperView.hidden = true
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: View mode
    
    func settingStatusBar() {
        currentBarView.layer.cornerRadius = 6
        currentBarView.layer.masksToBounds = true
        
        statusBarView.layer.cornerRadius = 6
        statusBarView.layer.masksToBounds = true
        
        todayLabel.text = getTodayString("MMMM dd, yyyy")
        
        var day = NSCalendar.currentCalendar().component(NSCalendarUnit.DayCalendarUnit, fromDate: NSDate())
        var ratio = CGFloat(day) / CGFloat(dayCountInMonth)
        ratio = ratio > 1 ? 1 : ratio
        currentBarWidthConstraint.constant = ratio * statusBarView.frame.width
    }
    
    func chooseMode(sender: UITapGestureRecognizer) {
        println("tap title")
    }
    
    func getCurrentWeekText() -> String {
        var result = "Weekly"
        var (beginWeek, endWeek) = Helper.sharedInstance.getCurrentWeek()
        if beginWeek != nil && endWeek != nil {
            var formatter = NSDateFormatter()
            formatter.dateFormat = "dd MMM"
            result = formatter.stringFromDate(beginWeek!) + " - " + formatter.stringFromDate(endWeek!)
        }
        return result
    }
    
    func getTodayString(dateFormat: String) -> String {
        var formatter = NSDateFormatter()
        formatter.dateFormat = dateFormat
        return formatter.stringFromDate(NSDate())
    }
    
    // Table view
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return isCollapedIncome ? 1 : incomes.count + 1
        case 1:
            return isCollapedExpense ? 1 : expenses.count + 1
        case 2:
            return 1
        default:
            break
        }
        return 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 35
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let dummyCell = UITableViewCell()
        
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier("MenuCell", forIndexPath: indexPath) as! MenuCell
                
                cell.menuLabel.textColor = UIColor(netHex: 0x3D8B37)
                cell.amountLabel.textColor = UIColor(netHex: 0x3D8B37)
                cell.menuLabel.text = "Income"
                
                if isCollapedIncome {
                    cell.iconView.image = UIImage(named: "Expand")
                } else {
                    cell.iconView.image = UIImage(named: "Collapse")
                }
                
                var tapGesture = UITapGestureRecognizer(target: self, action: Selector("tapIncome:"))
                cell.addGestureRecognizer(tapGesture)
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("SubMenuCell", forIndexPath: indexPath) as! SubMenuCell
                
                cell.categoryLabel.text = incomes[indexPath.row - 1]
                
                return cell
            }
            
        case 1:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier("MenuCell", forIndexPath: indexPath) as! MenuCell
                
                cell.menuLabel.textColor = UIColor.redColor()
                cell.amountLabel.textColor = UIColor.redColor()
                cell.menuLabel.text = "Expense"
                
                if isCollapedExpense {
                    cell.iconView.image = UIImage(named: "Expand")
                } else {
                    cell.iconView.image = UIImage(named: "Collapse")
                }
                
                var tapGesture = UITapGestureRecognizer(target: self, action: Selector("tapExpense:"))
                cell.addGestureRecognizer(tapGesture)
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("SubMenuCell", forIndexPath: indexPath) as! SubMenuCell
                
                cell.categoryLabel.text = expenses[indexPath.row - 1]
                
                return cell
            }
            
        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier("BalanceCell", forIndexPath: indexPath) as! BalanceCell
            
            return cell
            
        default:
            break
        }
        
        return dummyCell
    }

    // MARK: Handle gesture
    
    func tapIncome(sender: UITapGestureRecognizer) {
        if isCollapedIncome {
            isCollapedIncome = false
        } else {
            isCollapedIncome = true
        }
        tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    
    func tapExpense(sender: UITapGestureRecognizer) {
        if isCollapedExpense {
            isCollapedExpense = false
        } else {
            isCollapedExpense = true
        }
        tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    

}
