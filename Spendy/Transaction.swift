//
//  Transaction.swift
//  Spendy
//
//  Created by Harley Trung on 9/18/15.
//  Copyright (c) 2015 Cheetah. All rights reserved.
//

import Foundation
import Parse

/* 
Schema:
- kind (income | expense | transfer)
- user_id
- from_account
- to_account (when type is ‘transfer’)
- note
- amount
- category_id
- date
*/

// Note: I'm testing a different approach here compared to Account & Category
// which is not to inherit from PFObject and keep all Parse related communications private
// This makes it less buggy when working with Transaction from outside in
// (as long as we test Transaction carefully)
class Transaction: HTObject {
    // TODO: make this work so we can set _object from inside HTObject
//    override class var parseClassName: String! { get { return "Transaction" } }

    var kind: String?
    var note: String?
    var amount: Double?
    var categoryId: String?
    var fromAccountId: String?
    var toAccountId: String?
    var date: NSDate?
    
    // TODO: change kind to enum .Expense, .Income, .Transfer
    init(kind: String?, note: String?, amount: Double?, category: Category?, account: Account?, date: NSDate?) {
        super.init()
        
        // TODO: abstract to HTObject
        self._object = PFObject(className: "Transaction")
        
        self["kind"] = kind
        self["note"] = note
        self["categoryId"] = category?.objectId
        self["fromAccountId"] = account?.objectId
        self["date"] = date
    }

    static var transactions: [PFObject]?

    static func findAll(completion: (transactions: [PFObject]?, error: NSError?) -> ()) {
        let query = PFQuery(className: "Transaction")
        query.fromLocalDatastore()
        query.findObjectsInBackgroundWithBlock { (results: [AnyObject]?, error: NSError?) -> Void in
            if error != nil {
                println("Error loading transactions")
                completion(transactions: nil, error: error)
            } else {
                self.transactions = results as! [PFObject]?
                completion(transactions: self.transactions, error: error)
            }
        }
    }
}