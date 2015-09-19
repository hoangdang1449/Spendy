//
//  Category.swift
//  Spendy
//
//  Created by Harley Trung on 9/18/15.
//  Copyright (c) 2015 Cheetah. All rights reserved.
//

import Foundation
import Parse

class Category: PFObject {
    dynamic var name:String?

    init(name: String) {
        super.init()

        self.name = name
    }

    override init() {
        super.init()
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