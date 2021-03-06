//
//  DataManager.swift
//  Spendy
//
//  Created by Harley Trung on 9/22/15.
//  Copyright (c) 2015 Cheetah. All rights reserved.
//

import Foundation
import Parse

class DataManager {
    class func setupDefaultData(removeLocalData: Bool = false) {
        if removeLocalData {
            print("\n**Remove all local data**\n", terminator: "\n")
            do {
                try PFObject.unpinAllObjects()
                print("Success")
            } catch {
                print("An error occurred when removing all local data.")
            }
//            PFObject.unpinAllObjectsInBackgroundWithName("MyAccounts")
//            PFObject.unpinAllObjectsInBackgroundWithName("MyCategories")
        }

        // Load all categories from local
        // If categories are empty from local, load from server
        Category.loadAll()

        // Load user's accounts
        // If accounts are empty,load from server
        // If accounts are still empty, create new ones, save to server
        Account.loadAll()

        // TODO: load other settings
    }
}