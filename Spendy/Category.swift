//
//  Category.swift
//  Spendy
//
//  Created by Harley Trung on 9/18/15.
//  Copyright (c) 2015 Cheetah. All rights reserved.
//

import Foundation
import Parse

var _all: [Category]?

class Category: PFObject {
    dynamic var name:String?

    init(name: String) {
        super.init()

        self.name = name
    }

    override init() {
        super.init()
    }

    static func loadAllWithQuery(#local: Bool) {
        let query = PFQuery(className: "Category")
    }

    static func loadAll() {
        // load from local first
        let localQuery = PFQuery(className: "Category")
        localQuery.fromLocalDatastore().findObjectsInBackgroundWithBlock { (categories: [AnyObject]?, error: NSError?) -> Void in
            if let error = error {
                println("Error loading categories from Local: \(error)")
            } else {
                println("[local] categories: \(categories)")
                _all = categories as! [Category]?

                if _all == nil || _all!.isEmpty {
                    // load from remote
                    let remoteQuery = PFQuery(className: "Category")
                    remoteQuery.findObjectsInBackgroundWithBlock { (categories: [AnyObject]?, error: NSError?) -> Void in
                        if let error = error {
                            println("Error loading categories from Server: \(error)")
                        } else {
                            println("[server] categories: \(categories)")
                            _all = categories as! [Category]?
                            PFObject.pinAllInBackground(_all)
                        }
                    }
                }
            }
        }

    }

    static func all() -> [Category]? {
        return _all;
    }
}

extension Category: PFSubclassing {
    class func parseClassName() -> String {
        return "Category"
    }

    override class func initialize() {
        var onceToken: dispatch_once_t = 0
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }

    override class func query() -> PFQuery? {
        let query = PFQuery(className: parseClassName())
        query.orderByDescending("createdAt")

        return query
    }
}