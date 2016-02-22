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
    @NSManaged public var numberOfPlaces: Int
    @NSManaged public var numberOfChats: Int
    @NSManaged public var featuredImageFile: PFFile
    @NSManaged public var createdUser: String!
    @NSManaged public var isDesided: Bool
    @NSManaged public var placeIsDesided: Bool
    @NSManaged public var selectedDate: String
    @NSManaged public var selectedPlace: String
    @NSManaged public var selectedUrl: String
    public func incrementNumberOfPosts()
    {
        numberOfPosts++
        self.saveInBackground()
    }
    
    public func incrementNumberOfChats()
    {
        numberOfChats++
        self.saveInBackground()
    }

    
    public func incrementNumberOfPlaces() {
        
        numberOfPlaces++
        self.saveInBackground()
    }
    
    public func incrementNumberOfMembers()
    {
        numberOfMembers++
        self.saveInBackground()
    }
    
    public func voteClosed()
    {
        isDesided = true
    }
    
    // MARK: - Convience init
    

    init(title: String, interestDescription: String, places: String, imageFile: PFFile, numberOfMembers: Int, numberOfChats: Int, numberOfPlaces: Int, numberOfPosts: Int, createdUser: String, isDesided: Bool, placeIsDesided: Bool, selectedDate: String, selectedPlace: String, selectedUrl: String)

    {
        super.init()
        self.title = title
        self.interestDescription = interestDescription
        self.interestPlaces = places
        
        self.featuredImageFile = imageFile
        self.numberOfMembers = numberOfMembers
        self.numberOfPosts = numberOfPosts
        self.numberOfPlaces = numberOfPlaces
        self.numberOfChats = numberOfChats
        self.createdUser = createdUser
        self.isDesided = isDesided
        self.placeIsDesided = placeIsDesided
        self.selectedDate = selectedDate
        self.selectedPlace = selectedPlace
        self.selectedUrl = selectedUrl
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


















