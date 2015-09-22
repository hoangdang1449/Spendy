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
        print("=====================\nUser: \(user)\n=====================", terminator: "\n")

        let localQuery = PFQuery(className: "Account").fromLocalDatastore()

        // TODO: move this out
        if user.objectId == nil {
//            user.save()
            do {
                try user.save()
                print("Success")
            } catch {
                print("An error occurred when saving user.")
            }
        }
//localQuery.findObjectsInBackgroundWithBlock

        localQuery.whereKey("userId", equalTo: user.objectId!)
        localQuery.findObjectsInBackgroundWithBlock {
            (objects, error) -> Void in

            if error != nil {
                print("Error loading accounts from Local: \(error)", terminator: "\n")
                return
            }

            _allAccounts = objects?.map({ Account(object: $0 ) })
            print("\n[local] accounts: \(objects)", terminator: "\n")

            if _allAccounts == nil || _allAccounts!.isEmpty {
                // load from server
                let remoteQuery = PFQuery(className: "Account")
                remoteQuery.whereKey("userId", equalTo: user.objectId!)
                remoteQuery.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
                    if let error = error {
                        print("Error loading accounts from Server: \(error)", terminator: "\n")
                        return
                    }

                    print("\n[server] accounts: \(objects)")
                    _allAccounts = objects?.map({ Account(object: $0 ) })

                    if _allAccounts!.isEmpty {
                        print("No account found for \(user). Creating Default Account", terminator: "\n")

                        let defaultAccount = Account(name: "Default Account")
                        let secondAccount  = Account(name: "Second Account")

                        defaultAccount.pinAndSaveEventuallyWithName("MyAccounts")
                        secondAccount.pinAndSaveEventuallyWithName("MyAccounts")
                        _allAccounts!.append(defaultAccount)
                        _allAccounts!.append(secondAccount)

                        print("accounts: \(_allAccounts!)", terminator: "\n")
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

//extension Account: CustomStringConvertible {
//    override var description: String {
//        let base = super.description
//        return "userId: \(userId), name: \(name), icon: \(icon), base: \(base)"
//    }
//}