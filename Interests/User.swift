//
//  User.swift
//  Interests
//
//  Created by Duc Tran on 6/13/15.
//  Copyright © 2015 Developer Inspirus. All rights reserved.
//

import UIKit
import Parse

public class User: PFUser
{
    @NSManaged public var interestIds: [String]! 
    @NSManaged public var profileImageFile: PFFile!
    
    public func isMemberOf(interestId: String) -> Bool {
         return interestIds.contains(interestId)
    }
    
    public func joinInterest(interestId: String)
    {
        self.interestIds.insert(interestId, atIndex: 0)
        self.saveInBackgroundWithBlock { (success, error) -> Void in
            if error != nil {
                print("\(error!.localizedDescription)")
            }
        }
    }
    
    override public class func initialize()
    {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
}
























