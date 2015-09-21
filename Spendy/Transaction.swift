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

    static let expenseKind: String = "expense"
    static let incomeKind: String = "income"
    static let transferKind: String = "transfer"

    var note: String?
    var amount: NSDecimalNumber?
    var categoryId: String?
    var fromAccountId: String?
    var toAccountId: String?
    var date: NSDate?
    var kind: String?
    
    // TODO: change kind to enum .Expense, .Income, .Transfer
    init(kind: String?, note: String?, amount: NSDecimalNumber?, category: Category?, account: Account?, date: NSDate?) {
        super.init()
        
        // TODO: abstract to HTObject
        self._object = PFObject(className: "Transaction")

        self["kind"] = kind
        self["note"] = note
        self["amount"] = amount
        self["categoryId"] = category?.objectId
        self["fromAccountId"] = account?.objectId
        self["date"] = date

        println("done \(self)")
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

    // MARK: - date formatter

    func dateToString(dateStyle: NSDateFormatterStyle? = nil, dateFormat: String? = nil) -> String? {
        if let date = date {
            if dateStyle != nil {
                Transaction.dateFormatter.dateStyle = dateStyle!
            }

            if dateFormat != nil {
                Transaction.dateFormatter.dateFormat = dateFormat!
            }

            return Transaction.dateFormatter.stringFromDate(date)
        } else {
            return nil
        }
    }

    // Ex: September 21, 2015
    func dateOnly() -> String? {
        return dateToString(dateStyle: NSDateFormatterStyle.LongStyle)
    }

    // Ex: Thursday, 7 AM
    func dayAndTime() -> String? {
        return dateToString(dateFormat: "EEEE, h a")
    }

    func monthHeader() -> String? {
        return dateToString(dateFormat: "MMMM YYYY")
    }

    static var dateFormatter = NSDateFormatter()
}