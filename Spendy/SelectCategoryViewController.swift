//
//  SelectCategoryViewController.swift
//  Spendy
//
//  Created by Harley Trung on 9/17/15.
//  Copyright (c) 2015 Cheetah. All rights reserved.
//

import UIKit
import Parse

class SelectCategoryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var categories: [PFObject]?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        tableView.dataSource = self
        tableView.delegate = self

        loadCategories()
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

    func loadCategories() {
        var query = PFQuery(className: "Category")
        query.findObjectsInBackgroundWithBlock { (categories: [AnyObject]?, error: NSError?) -> Void in
            if let error = error {
                println("Error loading categories: \(error)")
            } else {
                println("categories: \(categories)")

                self.categories = categories as! [PFObject]?

                self.tableView.reloadData()
            }
        }

    }
}

extension SelectCategoryViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int  {
        return categories?.count ?? 0
    }

    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CategoryCell") as! CategoryCell

        let category = categories?[indexPath.row] as PFObject?

        cell.nameLabel.text = category?.objectForKey("name") as! String?
        return cell
    }
}