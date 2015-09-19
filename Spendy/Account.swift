//
//  Account.swift
//  Spendy
//
//  Created by Harley Trung on 9/18/15.
//  Copyright (c) 2015 Cheetah. All rights reserved.
//

import Foundation
import Parse

var _allAccounts: [Account]?

class Account: PFObject {
    @NSManaged var name: String!
    @NSManaged var userId: String!


    init(name: String) {
        super.init()

        self.name = name
        self.userId = PFUser.currentUser()?.objectId!
    }

    override init() {
        super.init()
    }

    static func loadAll() {
        let user = PFUser.currentUser()!
        
        let localQuery = PFQuery(className: "Account")
        localQuery.whereKey("userId", equalTo: user.objectId!)
        localQuery.fromLocalDatastore().findObjectsInBackgroundWithBlock { (accounts: [AnyObject]?, error: NSError?) -> Void in
            if error != nil {
                println("Error loading accounts from Local: \(error)")
                return
            }

            println("[local] accounts: \(accounts)")
            _allAccounts = accounts as! [Account]?

            if _allAccounts == nil || _allAccounts!.isEmpty {
                // load from server
                let remoteQuery = PFQuery(className: "Account")
                remoteQuery.whereKey("userId", equalTo: user.objectId!)
                remoteQuery.findObjectsInBackgroundWithBlock { (accounts: [AnyObject]?, error: NSError?) -> Void in
                    if let error = error {
                        println("Error loading accounts from Server: \(error)")
                        return
                    }

                    println("[server] accounts: \(accounts)")
                    _allAccounts = accounts as! [Account]?

                    if _allAccounts!.isEmpty {
                        println("No account found for \(user). Creating Default Account")
                        var defaultAccount = Account(name: "Default Account")
                        defaultAccount.userId = user.objectId!
                        defaultAccount.pinInBackground()
                        defaultAccount.saveEventually()
                        _allAccounts?.append(defaultAccount)
                        println("accounts: \(_allAccounts!)")
                    } else {
                        PFObject.pinAllInBackground(_allAccounts)
                    }
                }
            }
        }
    }

    static func all() -> [Account]? {
        return _allAccounts;
    }
}

extension Account: PFSubclassing {
    class func parseClassName() -> String {
        return "Account"
    }

    override class func initialize() {
        var onceToken: dispatch_once_t = 0
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }

    override class func query() -> PFQuery? {
        //1
        let query = PFQuery(className: parseClassName())
        //2
        query.whereKey("userId", equalTo: PFUser.currentUser()!.objectId!)
        //3
        query.orderByDescending("createdAt")

        return query
    }
}