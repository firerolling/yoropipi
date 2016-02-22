//
//  Place.swift
//  interests
//
//  Created by 株式会社ConU on 2016/02/16.
//  Copyright © 2016年 Developer Inspirus. All rights reserved.
//

import UIKit
import Parse

public class Place: PFObject, PFSubclassing
{
    // MARK: - Public API
    
    @NSManaged public var user: PFUser // must use PFUser
    @NSManaged public var placeText: String
    @NSManaged public var placeUrl: String
    @NSManaged public var numberOfLikes: Int
    @NSManaged public var interestId: String!
    @NSManaged public var likedUserIds: [String]!
    @NSManaged public var isSelected: Bool
    
    // MARK: - Create new post
    override init() {
        super.init()
    }
    
    init(user: PFUser, placeText: String, placeUrl: String, numberOfLikes: Int, interestId: String, isSelected: Bool)
    {
        super.init()
        
        self.user = user
        self.placeText = placeText
        self.placeUrl = placeUrl
        self.numberOfLikes = numberOfLikes
        self.interestId = interestId
        self.likedUserIds = [String]()
        self.isSelected = isSelected
    }
    
    // MARK: - Like / Dislike
    
    public func like()
    {
        let currentUserObjectId = User.currentUser()!.objectId!
        if !likedUserIds.contains(currentUserObjectId) {
            numberOfLikes++
            likedUserIds.insert(currentUserObjectId, atIndex: 0)
            self.saveInBackground()
        }
    }
    
    public func dislike()
    {
        let currentUserObjectId = User.currentUser()!.objectId!
        if likedUserIds.contains(currentUserObjectId) {
            numberOfLikes--
            for (index, userId) in likedUserIds.enumerate() {
                if userId == currentUserObjectId {
                    likedUserIds.removeAtIndex(index)
                    break
                }
            }
            self.saveInBackground()
        }
    }
    
    // MARK: - PFSubclassing
    override public class func initialize()
    {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    public static func parseClassName() -> String {
        return "Place"
    }
    
}













