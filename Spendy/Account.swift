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

class Account: HTObject {
    dynamic var name: String!
    dynamic var userId: String!
    dynamic var icon: String! // temporary, to make Account and Category work well together

    init(name: String) {
        super.init(parseClassName: "Account")

        self["name"] = name
        self["userId"] = PFUser.currentUser()!.objectId!
    }

    override init(object: PFObject) {
        super.init(object: object)

        self["name"] = object.objectForKey("name")
        self["userId"] = object.objectForKey("userId")
    }

    static func loadAll() {
        let user = PFUser.currentUser()!
        println("=====================\nUser: \(user)\n=====================")

        let localQuery = PFQuery(className: "Account").fromLocalDatastore()

        // TODO: move this out
        if user.objectId == nil {
            user.save()
        }


        localQuery.whereKey("userId", equalTo: user.objectId!)
        localQuery.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in

            if error != nil {
                println("Error loading accounts from Local: \(error)")
                return
            }

            _allAccounts = objects?.map({ Account(object: $0 as! PFObject) })
            println("\n[local] accounts: \(objects)")

            if _allAccounts == nil || _allAccounts!.isEmpty {
                // load from server
                let remoteQuery = PFQuery(className: "Account")
                remoteQuery.whereKey("userId", equalTo: user.objectId!)
                remoteQuery.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
                    if let error = error {
                        println("Error loading accounts from Server: \(error)")
                        return
                    }

                    println("\n[server] accounts: \(objects)")
                    _allAccounts = objects?.map({ Account(object: $0 as! PFObject) })

                    if _allAccounts!.isEmpty {
                        println("No account found for \(user). Creating Default Account")

                        var defaultAccount = Account(name: "Default Account")
                        var secondAccount  = Account(name: "Second Account")

                        defaultAccount.pinAndSaveEventuallyWithName("MyAccounts")
                        secondAccount.pinAndSaveEventuallyWithName("MyAccounts")
                        _allAccounts!.append(defaultAccount)
                        _allAccounts!.append(secondAccount)

                        println("accounts: \(_allAccounts!)")
                    } else {
                        Account.pinAllWithName(_allAccounts!, name: "MyAccounts")
                    }
                }
            }
        }
    }

    class func defaultAccount() -> Account? {
        return _allAccounts?.first
    }

    class func all() -> [Account]? {
        return _allAccounts;
    }

    class func findById(objectId: String) -> Account? {
        let record = _allAccounts?.filter({ (el) -> Bool in
            el.objectId == objectId
        }).first
        return record
    }
}

extension Account: Printable {
    override var description: String {
        let base = super.description
        return "userId: \(userId), name: \(name), icon: \(icon), base: \(base)"
    }
}