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

class Category: HTObject {
    dynamic var name: String?
    dynamic var icon: String?

    init(name: String?, icon: String?) {
        super.init(parseClassName: "Category")

        self["name"] = name
        self["icon"] = icon
    }

    override init(object: PFObject) {
        super.init(object: object)

        self["name"] = object.objectForKey("name")
        self["icon"] = object.objectForKey("icon")
    }

    class func loadAll() {
        // load from local first
        let localQuery = PFQuery(className: "Category").fromLocalDatastore()

        localQuery.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in

            if let error = error {
                println("Error loading categories from Local: \(error)")
                return
            }

            _allCategories = objects?.map({ Category(object: $0 as! PFObject) })
            println("\n[local] categories: \(objects)")

            if _allCategories == nil || _allCategories!.isEmpty {
                println("No categories found locally. Loading from server")
                // load from remote
                let remoteQuery = PFQuery(className: "Category")
                remoteQuery.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
                    if let error = error {
                        println("Error loading categories from Server: \(error)")
                    } else {
                        println("[server] categories: \(objects)")
                        _allCategories = objects?.map({ Category(object: $0 as! PFObject) })
                        PFObject.pinAllInBackground(_allCategories, withName: "MyCategories")
                    }
                }
            }
        }
    }

    class func defaultCategory() -> Category? {
        return _allCategories?.first
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