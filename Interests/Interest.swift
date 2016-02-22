//
//  Interest.swift
//  Interests
//
//  Created by Duc Tran on 6/13/15.
//  Copyright © 2015 Developer Inspirus. All rights reserved.
//

import UIKit
import Parse

public class Interest: PFObject, PFSubclassing
{
    // MARK: - Public API
    @NSManaged public var title: String!
    @NSManaged public var interestDescription: String!
    @NSManaged public var interestPlaces: String!
    @NSManaged public var numberOfMembers: Int
    @NSManaged public var numberOfPosts: Int
    @NSManaged public var featuredImageFile: PFFile
    
    public func incrementNumberOfPosts()
    {
        numberOfPosts++
        self.saveInBackground()
    }
    
    public func incrementNumberOfMembers()
    {
        numberOfMembers++
        self.saveInBackground()
    }
    
    // MARK: - Convience init
    
    init(title: String, interestDescription: String, places: String, imageFile: PFFile, numberOfMembers: Int, numberOfPosts: Int)
    {
        super.init()
        self.title = title
        self.interestDescription = interestDescription
        self.interestPlaces = places
        
        self.featuredImageFile = imageFile
        self.numberOfMembers = numberOfMembers
        self.numberOfPosts = numberOfPosts
    }
    
    override init()
    {
        super.init()
    }

    // MARK: - PFSubclassing
    override public class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    public static func parseClassName() -> String {
        return "Interest"
    }
}


















