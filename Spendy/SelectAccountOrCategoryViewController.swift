//
//  SelectAccountOrCategoryViewController.swift
//  Spendy
//
//  Created by Harley Trung on 9/17/15.
//  Copyright (c) 2015 Cheetah. All rights reserved.
//

import UIKit
import Parse

class SelectAccountOrCategoryViewController: UIViewController {
    // Account or Category
    var itemClass: String!

    @IBOutlet weak var tableView: UITableView!
    var items: [PFObject]?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        tableView.dataSource = self
        tableView.delegate = self

        loadItems()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */

    func loadItems() {
        if itemClass == "Category" {
            items = Category.all() as [Category]?
            tableView.reloadData()
        } else if itemClass == "Account" {
            items = Account.all() as [Account]?
            tableView.reloadData()
        }
    }
}

extension SelectAccountOrCategoryViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int  {
        return items?.count ?? 0
    }

    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CategoryCell") as! CategoryCell

        let item = items?[indexPath.row] as PFObject?

        cell.nameLabel.text = item?.objectForKey("name") as! String?
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var selectedCategory = tableView.cellForRowAtIndexPath(indexPath) as! CategoryCell
        
        // TODO: pass Category or Item to previous view
    }
    
}