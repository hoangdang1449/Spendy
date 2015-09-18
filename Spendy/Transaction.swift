//
//  Transaction.swift
//  Spendy
//
//  Created by Harley Trung on 9/18/15.
//  Copyright (c) 2015 Cheetah. All rights reserved.
//

import Foundation
import Parse

class Transaction {
    var note: String?
    var amount: Double?
    var category: String? // TODO: change to Category
    var account: String?  // TODO: change to Account
    var date: NSDate?

    var _object: PFObject!

    init(note: String?, amount: Double?, category: String?, account: String?, date: NSDate?) {

        _object = PFObject(className: "Transaction")
        _object.setObject(note!, forKey: "note")
        _object.setObject(amount!, forKey: "amount")
        _object.setObject(category!, forKey: "category")
        _object.setObject(date!, forKey: "date")
    }

    func save() {
        _object.pinInBackground()
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