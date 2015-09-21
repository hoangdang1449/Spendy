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

var _allTransactions: [Transaction]?

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



    // MARK: - date formatter
    static var dateFormatter = NSDateFormatter()
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

    // MARK: - unused
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

    // MARK: - Utilities
    class func all() -> [Transaction]? {
        return _allTransactions
    }

    class func dictGroupedByMonth(trans: [Transaction]) -> [String: [Transaction]] {
        var dict = [String:[Transaction]]()
        for el in trans {
            let key = el.monthHeader() ?? "Unknown"
            dict[key] = (dict[key] ?? []) + [el]
        }
        return dict
    }

    class func listGroupedByMonth(trans: [Transaction]) -> [[Transaction]] {
        let grouped = dictGroupedByMonth(trans)
        var list: [[Transaction]] = []
        for (key, el) in grouped {
            var g:[Transaction] = grouped[key]!
            // sort values in each bucket, newest first
            g.sort({ $1.date! < $0.date! })
            list.append(g)
        }

        // sort by month
        list.sort({ $1[0].date! < $0[0].date! })

        return list
    }

    class func loadAll() {
        println("\n\nloading fake data for Transactions")
        let defaultCategory = Category.all()?.first
        let defaultAccount = Account.all()?.first

        // Initialize with fake transactions
        let dateFormatter = Transaction.dateFormatter
        dateFormatter.dateFormat = "yyyy-MM-dd"

        // TODO: load from and save to servers
        _allTransactions =
            [
                Transaction(kind: Transaction.expenseKind, note: "Note 1", amount: 3.23, category: defaultCategory, account: defaultAccount, date: dateFormatter.dateFromString("2015-08-01")),
                Transaction(kind: Transaction.expenseKind, note: "Note 2", amount: 4.23, category: defaultCategory, account: defaultAccount, date: dateFormatter.dateFromString("2015-08-02")),
                Transaction(kind: Transaction.expenseKind, note: "Note 3", amount: 1.23, category: defaultCategory, account: defaultAccount, date: dateFormatter.dateFromString("2015-09-01")),
                Transaction(kind: Transaction.expenseKind, note: "Note 4", amount: 2.23, category: defaultCategory, account: defaultAccount, date: dateFormatter.dateFromString("2015-09-02")),
                Transaction(kind: Transaction.expenseKind, note: "Note 5", amount: 2.23, category: defaultCategory, account: defaultAccount, date: dateFormatter.dateFromString("2015-09-03"))
            ]
        println("post sort: \(_allTransactions!))")
    }

    class func add(element: Transaction) {
        _allTransactions!.append(element)
    }
}