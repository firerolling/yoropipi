//
//  TestObject.swift
//  Interests
//
//  Created by Duc Tran on 6/19/15.
//  Copyright © 2015 Developer Inspirus. All rights reserved.
//

import UIKit
import Parse

public class TestObject: PFObject, PFSubclassing
{
    @NSManaged public var title: String!
    @NSManaged public var objectDescription: String!
    @NSManaged public var numbers: Int
    
    override public class func initialize()
    {
        struct Static {
            static var onceToken: dispatch_once_t = 0
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    public static func parseClassName() -> String
    {
        return "TestObject"
    }
}





































