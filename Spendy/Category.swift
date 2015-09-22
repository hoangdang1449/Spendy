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
        let localQuery = PFQuery(className: "Category")

        localQuery.fromLocalDatastore().findObjectsInBackgroundWithBlock {
            (objects, error) -> Void in

            if let error = error {
                print("Error loading categories from Local: \(error)", appendNewline: true)
                return
            }

            _allCategories = objects?.map({ Category(object: $0 ) })
            print("\n[local] categories: \(objects)", appendNewline: true)

            if _allCategories == nil || _allCategories!.isEmpty {
                print("No categories found locally. Loading from server", appendNewline: true)
                // load from remote
                let remoteQuery = PFQuery(className: "Category")
                remoteQuery.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
                    if let error = error {
                        print("Error loading categories from Server: \(error)")
                    } else {
                        print("[server] categories: \(objects)")
                        _allCategories = objects?.map({ Category(object: $0 ) })

                        // already in background
                        PFObject.pinAllInBackground(objects!, withName: "MyCategories", block: { (success, error: NSError?) -> Void in
                            print("bool: \(success); error: \(error)")
                        })
                        // no need to save because we are not adding data
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

//extension Category: CustomStringConvertible {
//    override var description: String {
//        let base = super.description
//        return "name: \(name), icon: \(icon), base: \(base)"
//    }
//}