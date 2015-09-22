//
//  AccountDetailViewController.swift
//  Spendy
//
//  Created by Dave Vo on 9/18/15.
//  Copyright (c) 2015 Cheetah. All rights reserved.
//

import UIKit

class AccountDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var addButton: UIButton?
    var cancelButton: UIButton?
    
    var sampleTransactions: [[Transaction]]!
    
    var selectedAccount: Account!
    var selectedCategory: Category!

    var transaction: Transaction!

    override func viewDidLoad() {
        super.viewDidLoad()

        selectedCategory = Category.all()!.first
        transaction = Transaction(kind: Transaction.expenseKind, note: "", amount: 0, category: selectedCategory, account: selectedAccount, date: NSDate())


        let dateFormatter = Transaction.dateFormatter
        dateFormatter.dateFormat = "YYYY-MM-dd"

        // TODO: this is temporary. need to wait for Category and Account to load first
        Transaction.loadAll()

        // create a few sample transactions
        reloadTransactions()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()

        addBarButton()
        
        let downSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleDownSwipe:"))
        downSwipe.direction = .Down
        downSwipe.delegate = self
        tableView.addGestureRecognizer(downSwipe)
        
        if let selectedAccount = selectedAccount {
            navigationItem.title = selectedAccount.name
        }
    }

    func reloadTransactions() {
        sampleTransactions = Transaction.listGroupedByMonth(Transaction.all()!)
    }

    // reload data after we navigate back from pushed cell
    override func viewWillAppear(animated: Bool) {
        print("viewWillAppear", terminator: "\n")
        reloadTransactions()
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Button
    
    func addBarButton() {
        
        addButton = UIButton()
        Helper.sharedInstance.customizeBarButton(self, button: addButton!, imageName: "Add", isLeft: false)
        addButton!.addTarget(self, action: "onAddButton:", forControlEvents: UIControlEvents.TouchUpInside)
        
        cancelButton = UIButton()
        Helper.sharedInstance.customizeBarButton(self, button: cancelButton!, imageName: "Cancel", isLeft: true)
        cancelButton!.addTarget(self, action: "onCancelButton:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func onAddButton(sender: UIButton!) {
        print("on Add", terminator: "\n")
        let dvc = self.storyboard?.instantiateViewControllerWithIdentifier("AddVC") as! AddTransactionViewController
        let nc = UINavigationController(rootViewController: dvc)
        self.presentViewController(nc, animated: true, completion: nil)
    }
    
    func onCancelButton(sender: UIButton!) {
//        dismissViewControllerAnimated(true, completion: nil)
        navigationController?.popViewControllerAnimated(true)
    }

    // MARK: Table view
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sampleTransactions.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sampleTransactions[section].count
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 30))
        headerView.backgroundColor = UIColor(netHex: 0xDCDCDC)
        
        let monthLabel = UILabel(frame: CGRect(x: 8, y: 2, width: UIScreen.mainScreen().bounds.width - 16, height: 30))
        monthLabel.font = UIFont.systemFontOfSize(14)
        
        
        monthLabel.text = sampleTransactions[section][0].monthHeader()
        
        // TODO: get date from transaction
//        let date = NSDate()
//        var formatter = NSDateFormatter()
//        formatter.dateFormat = "MMMM, yyyy"
//        monthLabel.text = formatter.stringFromDate(date)
        
        headerView.addSubview(monthLabel)
        
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 34
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TransactionCell", forIndexPath: indexPath) as! TransactionCell
        
//        cell.noteLabel.text = sampleTransactions[indexPath.section][indexPath.row].note
        cell.transaction = sampleTransactions[indexPath.section][indexPath.row]

        let rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipe:"))
        rightSwipe.direction = .Right
        cell.addGestureRecognizer(rightSwipe)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipe:"))
        leftSwipe.direction = .Left
        cell.addGestureRecognizer(leftSwipe)
        
        Helper.sharedInstance.setSeparatorFullWidth(cell)
        return cell
    }
    
    // MARK: Handle gestures
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func handleSwipe(sender: UISwipeGestureRecognizer) {
        
        let selectedCell = sender.view as! TransactionCell
        let indexPath = tableView.indexPathForCell(selectedCell)
        
        if let indexPath = indexPath {
            switch sender.direction {
            case UISwipeGestureRecognizerDirection.Left:
                // Delete transaction
                
                sampleTransactions[indexPath.section].removeAtIndex(indexPath.row)
                tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: UITableViewRowAnimation.Automatic)
                
                if sampleTransactions[indexPath.section].count == 0 {
                    sampleTransactions.removeAtIndex(indexPath.section)
                    tableView.reloadData()
                }
                break
                
            case UISwipeGestureRecognizerDirection.Right:
                // Duplicate transaction to today
//                var newTransaction = selectedCell.noteLabel.text
                // TODO: duplicate transaction here
//                sampleTransactions[0].insert(newTransaction!, atIndex: 0)
                tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
                
                break
                
            default:
                break
            }
        }
    }
    
    func handleDownSwipe(sender: UISwipeGestureRecognizer) {
        
        if sender.direction == .Down {
            let dvc = self.storyboard?.instantiateViewControllerWithIdentifier("QuickVC") as! QuickViewController
            let nc = UINavigationController(rootViewController: dvc)
            self.presentViewController(nc, animated: true, completion: nil)
        }
    }
    
    // MARK: Transfer between 2 views
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        let navigationController = segue.destinationViewController as! UINavigationController
//        
//        if navigationController.topViewController is AddTransactionViewController {
//            let addViewController = navigationController.topViewController as! AddTransactionViewController
//            
//            var indexPath: AnyObject!
//            indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
//            
////            addViewController.selectedTransaction = sampleTransactions[indexPath.section][indexPath.row]
//        }
        
        
        let vc = segue.destinationViewController 
        
        if vc is AddTransactionViewController {
            let addTransactionViewController = vc as! AddTransactionViewController
            
            var indexPath: AnyObject!
            indexPath = tableView.indexPathForCell(sender as! UITableViewCell)

            addTransactionViewController.selectedTransaction = sampleTransactions[indexPath.section][indexPath.row]
            print("pass selectedTransaction to AddTransactionView: \(addTransactionViewController.selectedTransaction))", terminator: "\n")
        }
    }
}
