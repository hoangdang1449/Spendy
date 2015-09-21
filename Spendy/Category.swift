//
//  Category.swift
//  Spendy
//
//  Created by Harley Trung on 9/18/15.
//  Copyright (c) 2015 Cheetah. All rights reserved.
//

import Foundation
import Parse

var _allCategories: [Category]?

class Category: PFObject {
    @NSManaged var name:String!
    @NSManaged var icon:String!

    init(name: String) {
        super.init()
        self.name = name
    }

    override init() {
        super.init()
    }

    class func loadAllWithQuery(#local: Bool) {
        let query = PFQuery(className: "Category")
    }

    class func loadAll() {
        // load from local first
        let localQuery = PFQuery(className: "Category")
        localQuery.fromLocalDatastore().findObjectsInBackgroundWithBlock { (categories: [AnyObject]?, error: NSError?) -> Void in
            if let error = error {
                println("Error loading categories from Local: \(error)")
            } else {
                println("\n[local] categories: \(categories)")
                _allCategories = categories as! [Category]?
                PFObject.unpinAllInBackground(_allCategories)

                if _allCategories == nil || _allCategories!.isEmpty {
                    // load from remote
                    let remoteQuery = PFQuery(className: "Category")
                    remoteQuery.findObjectsInBackgroundWithBlock { (categories: [AnyObject]?, error: NSError?) -> Void in
                        if let error = error {
                            println("Error loading categories from Server: \(error)")
                        } else {
                            println("[server] categories: \(categories)")
                            _allCategories = categories as! [Category]?
                            PFObject.pinAllInBackground(_allCategories)
                        }
                    }
                }
            }
        }
    }

    class func all() -> [Category]? {
        return _allCategories;
    }

    class func findById(objectId: String) -> Category? {
        let record = _allCategories?.filter({ (el) -> Bool in
            el.objectId == objectId
        }).first
        return record
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