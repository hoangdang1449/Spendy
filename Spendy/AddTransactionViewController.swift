//
//  AddViewController.swift
//  Spendy
//
//  Created by Dave Vo on 9/16/15.
//  Copyright (c) 2015 Cheetah. All rights reserved.
//

import UIKit

class AddTransactionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var addButton: UIButton?
    var cancelButton: UIButton?
    
    var isCollaped = true
    var isShowDatePicker = false
    
    var noteCell: NoteCell?
    var amountCell: AmountCell?
    var categoryCell: SelectAccountOrCategoryCell?
    var accountCell: SelectAccountOrCategoryCell?
    var dateCell: DateCell?
    var photoCell: PhotoCell?
    
    var selectedTransaction: Transaction?
    var isNewTemp: Bool = false // temporary

    override func viewDidLoad() {
        super.viewDidLoad()

        if Transaction.all() == nil {
            Transaction.loadAll()
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()

        isCollaped = true
        
        addBarButton()

        if selectedTransaction != nil {
            navigationItem.title = "Edit Transaction"
            isNewTemp = false
        } else {
            isNewTemp = true
            selectedTransaction = Transaction(kind: Transaction.expenseKind,
                note: "I paid for something", amount: 0,
                category: Category.defaultCategory(), account: Account.defaultAccount(),
                date: NSDate())
        }

        tableView.reloadData()
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
        // update fields
        selectedTransaction!.note = noteCell?.noteText.text

        // TODO: parse amount and date
//        selectedTransaction!.amount = NSDecimalNumber(string: amountCell?.amountText.text)
//        selectedTransaction!.date = dateCell?.datePicker.date ?? NSDate()


        print("[onAddButton] transaction: \(selectedTransaction!)", appendNewline: true)
//        if selectedTransaction!.isNew() { // currently not saving transaction yet
        if isNewTemp {
            print("added transaction", appendNewline: true)
            Transaction.add(selectedTransaction!)
        }

        if presentingViewController != nil {
            dismissViewControllerAnimated(true, completion: nil)

            // unhide the tabBar because we hid it for the Add tab
            self.tabBarController?.tabBar.hidden = false
            let rootVC = parentViewController?.parentViewController as? RootTabBarController
            rootVC?.selectedIndex = 0
        } else if navigationController != nil {
            navigationController?.popViewControllerAnimated(true)
        } else {
            print("Error closing view on onAddButton: \(self)", appendNewline: true)
        }
    }

    func onCancelButton(sender: UIButton!) {
        print("onCancelButton", appendNewline: true)
        
        if presentingViewController != nil {
            // exit modal
            dismissViewControllerAnimated(true, completion: nil)

            // unhide the tabBar because we hid it for the Add tab
            self.tabBarController?.tabBar.hidden = false
            let rootVC = parentViewController?.parentViewController as? RootTabBarController
            rootVC?.selectedIndex = 0
        } else if navigationController != nil {
            // exit push
            navigationController!.popViewControllerAnimated(true)
        } else {
            print("Error closing view on onAddButton: \(self)", appendNewline: true)
        }
    }

    // MARK: Table View
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if isCollaped {
            return 2
        } else {
            return 3
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 3
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return ((indexPath.section == 1 && indexPath.row == 2 && isShowDatePicker) ? 182 : tableView.rowHeight)
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 30))
        headerView.backgroundColor = UIColor(netHex: 0xDCDCDC)
        
        if section == 0 {
            let todayLabel = UILabel(frame: CGRect(x: 8, y: 2, width: UIScreen.mainScreen().bounds.width - 16, height: 30))
            todayLabel.font = UIFont.systemFontOfSize(14)
            
            let today = NSDate()
            let formatter = NSDateFormatter()
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
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCellWithIdentifier("NoteCell", forIndexPath: indexPath) as! NoteCell

                cell.noteText.text = selectedTransaction?.note
                
                let tapCell = UITapGestureRecognizer(target: self, action: "tapNoteCell:")
                cell.addGestureRecognizer(tapCell)
                
                Helper.sharedInstance.setSeparatorFullWidth(cell)
                if noteCell == nil {
                    noteCell = cell
                }
                return cell
                
            case 1:
                let cell = tableView.dequeueReusableCellWithIdentifier("AmountCell", forIndexPath: indexPath) as! AmountCell

                cell.amountText.text = selectedTransaction?.formattedAmount()

                let tapCell = UITapGestureRecognizer(target: self, action: "tapAmoutCell:")
                cell.addGestureRecognizer(tapCell)
                
                cell.typeSegment.addTarget(self, action: "typeSegmentChanged:", forControlEvents: UIControlEvents.ValueChanged)
                
                cell.amountText.keyboardType = UIKeyboardType.DecimalPad
                Helper.sharedInstance.setSeparatorFullWidth(cell)
                if amountCell == nil {
                    amountCell = cell
                }
                return cell
                
            default:
                break
            }
            
            break
            
        case 1:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCellWithIdentifier("SelectAccountOrCategoryCell", forIndexPath: indexPath) as! SelectAccountOrCategoryCell

                cell.itemClass = "Category"
                cell.titleLabel.text = "Category"
                print("selectedTransaction: \(selectedTransaction)", appendNewline: true)

                // this got rendered too soon!

                let category = selectedTransaction?.category()
                cell.typeLabel.text = category!.name // TODO: replace with default category
                
                Helper.sharedInstance.setSeparatorFullWidth(cell)

                if categoryCell == nil {
                    categoryCell = cell
                }
                return cell
                
            case 1:
                let cell = tableView.dequeueReusableCellWithIdentifier("SelectAccountOrCategoryCell", forIndexPath: indexPath) as! SelectAccountOrCategoryCell
                
                cell.itemClass = "Account"
                cell.titleLabel.text = "Account"

                let account = selectedTransaction?.account()
                cell.typeLabel.text = account?.name
                
                Helper.sharedInstance.setSeparatorFullWidth(cell)
                if accountCell == nil {
                    accountCell = cell
                }
                return cell
                
            case 2:
                if isCollaped {
                    let cell = tableView.dequeueReusableCellWithIdentifier("ViewMoreCell", forIndexPath: indexPath)
                    
                    let tapCell = UITapGestureRecognizer(target: self, action: "tapMoreCell:")
                    cell.addGestureRecognizer(tapCell)
                    
                    Helper.sharedInstance.setSeparatorFullWidth(cell)
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCellWithIdentifier("DateCell", forIndexPath: indexPath) as! DateCell
                    
                    let tapCell = UITapGestureRecognizer(target: self, action: "tapDateCell:")
                    cell.addGestureRecognizer(tapCell)
                    
                    if isShowDatePicker {
                        cell.datePicker.alpha = 1
                    } else {
                        cell.datePicker.alpha = 0
                    }
                    
                    Helper.sharedInstance.setSeparatorFullWidth(cell)
                    if dateCell == nil {
                        dateCell = cell
                    }
                    return cell
                }
                
            default:
                break
            }
            
            break
            
        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier("PhotoCell", forIndexPath: indexPath) as! PhotoCell
            let tapCell = UITapGestureRecognizer(target: self, action: "tapPhotoCell:")
            cell.addGestureRecognizer(tapCell)
            Helper.sharedInstance.setSeparatorFullWidth(cell)
            if photoCell == nil {
                photoCell = cell
            }
            return cell
            
        default:
            break
        }
        
        return dummyCell
    }
    
    func tapNoteCell(sender: UITapGestureRecognizer) {
        noteCell!.noteText.becomeFirstResponder()
    }
    
    func tapAmoutCell(sender: UITapGestureRecognizer) {
        amountCell!.amountText.becomeFirstResponder()
    }
    
    func tapMoreCell(sender: UITapGestureRecognizer) {
        isCollaped = false
        tableView.reloadData()
    }
    
    func tapDateCell(sender: UITapGestureRecognizer) {
        
        noteCell!.noteText.resignFirstResponder()
        amountCell!.amountText.resignFirstResponder()
        
        if isShowDatePicker {
            isShowDatePicker = false
            tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: UITableViewRowAnimation.Automatic)
        } else {
            isShowDatePicker = true
            tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    func tapPhotoCell(sender: UITapGestureRecognizer) {
        showActionSheet()
    }
    
    func showActionSheet() {
        
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let takePhotoAction = UIAlertAction(title: "Take a Photo", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Take a Photo", appendNewline: true)
        })
        let photoLibraryAction = UIAlertAction(title: "Photo from Library", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Photo from Library", appendNewline: true)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled", appendNewline: true)
        })
        
        optionMenu.addAction(takePhotoAction)
        optionMenu.addAction(photoLibraryAction)
        optionMenu.addAction(cancelAction)
        
        self.presentViewController(optionMenu, animated: true, completion: nil)
    }

    func typeSegmentChanged(sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 2 {
            
            categoryCell!.titleLabel.text = "From Account"
            categoryCell!.typeLabel.text = "None"
            accountCell!.titleLabel.text = "To Account"
            accountCell!.typeLabel.text = "None"
            
        } else {
            
            categoryCell!.titleLabel.text = "Category"
            categoryCell!.typeLabel.text = "Other"
            accountCell!.titleLabel.text = "Account"
            accountCell!.typeLabel.text = "Cash"
        }
    }
    
    // MARK: Transfer between 2 views
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // Dismiss all keyboard and datepicker
        noteCell?.noteText.resignFirstResponder()
        amountCell?.amountText.resignFirstResponder()
        dateCell?.datePicker.alpha = 0
        
        let toController = segue.destinationViewController 
        if toController is SelectAccountOrCategoryViewController {
            let vc = toController as! SelectAccountOrCategoryViewController

            let cell = sender as! SelectAccountOrCategoryCell
            vc.itemClass = cell.itemClass
            vc.delegate = self

            // TODO: delegate
        }
    }
}

extension AddTransactionViewController: SelectAccountOrCategoryDelegate {
    func selectAccountOrCategoryViewController(selectAccountOrCategoryController: SelectAccountOrCategoryViewController, selectedItem item: AnyObject) {
        if item is Account {
            selectedTransaction?.setAccount(item as! Account)
            tableView.reloadData()
        } else if item is Category {
            selectedTransaction?.setCategory(item as! Category)
            tableView.reloadData()
        } else {
            print("Error: item is \(item)", appendNewline: true)
        }
    }
}
