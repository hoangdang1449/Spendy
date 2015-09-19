//
//  Account.swift
//  Spendy
//
//  Created by Harley Trung on 9/18/15.
//  Copyright (c) 2015 Cheetah. All rights reserved.
//

import Foundation
import Parse

class Account: PFObject {
    dynamic var name:String?
    dynamic var user:PFUser?

    init(name: String) {
        super.init()

        self.name = name
        self.user = PFUser.currentUser()
    }

    override init() {
        super.init()
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
        query.whereKey("user", equalTo: PFUser.currentUser()!)
        //3
        query.orderByDescending("createdAt")

        return query
    }
}