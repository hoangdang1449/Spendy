//
//  HTObject.swift
//  Spendy
//
//  Created by Harley Trung on 9/20/15.
//  Copyright (c) 2015 Cheetah. All rights reserved.
//

import Foundation
import Parse

// Goal:
// - abstract away communication with Parse
// - provide useful syntactic sugar
//
// Inherit from NSObject so that we can use #setValue and #valueForKey
class HTObject: NSObject {
    let _object = PFObject(className: HTObject.parseClassName())
    
    subscript(key: String) -> AnyObject? {
        get {
            return valueForKey(key)
        }
        set {
            setProperty(key, value: newValue)
        }
    }
    
    // Setter so we can also update the internal Parse object
    func setProperty(key: String, value: AnyObject?) {
        setValue(value, forKey: key)
        if value != nil {
            _object.setObject(value!, forKey: key)
        }
    }
    
    // Should be called after we make any changes
    func save() {
        _object.pinInBackground()
        _object.saveEventually()
    }
    
    class func parseClassName() -> String {
        return "PleaseSetClassName"
    }
}