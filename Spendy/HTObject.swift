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
    var _object: PFObject?
    var _parseClassName: String!

    init(parseClassName: String) {
        super.init()

        _parseClassName = parseClassName
        _object = PFObject(className: _parseClassName)
    }

    init(object: PFObject) {
        super.init()
        
        _parseClassName = object.parseClassName
        _object = object
    }

    func getChildClassName(instance: AnyClass) -> String {
        let name = NSStringFromClass(instance)
        let components = name.componentsSeparatedByString(".")
        return components.last ?? "UnknownClass"
    }

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
            _object!.setObject(value!, forKey: key)
        }
    }
    
    // Should be called after we make any changes
    func save() {
        println("pining + saving in background (no error checking):\n\(self)")
        _object!.pinInBackground()
        _object!.saveInBackground()
    }

    func isNew() -> Bool {
        return _object?.objectId == nil
    }

    var objectId: String? {
        return _object?.objectId
    }

    func pinAndSaveEventuallyWithName(name: String) {
        println("pinAndSaveEventually called on\n\(self)")
        _object!.pinInBackgroundWithName(name) { (isSuccess, error: NSError?) -> Void in
            if error != nil {
                println("[pinInBackgroundWithName] ERROR: \(error!). For \(self._object)")
            }
        }
        _object!.saveEventually()
    }

    class func pinAllWithName(htObjects: [HTObject], name: String) {
        PFObject.pinAllInBackground(htObjects.map({$0._object!}), withName: name) { (isSuccess, error: NSError?) -> Void in
            if error != nil {
                println("[pinAllInBackground] ERROR: \(error!). For \(htObjects)")
            }
        }
    }
}

extension HTObject: Printable {
    override var description: String {
        return _object != nil ? "object: \(_object!)" : "object is nil"
    }
}