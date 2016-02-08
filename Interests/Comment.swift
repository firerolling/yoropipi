//
//  Comment.swift
//  ProjectInterest
//
//  Created by Duc Tran on 6/3/15.
//  Copyright (c) 2015 Developer Inspirus. All rights reserved.
//

import UIKit
import Parse

public class Comment: PFObject, PFSubclassing
{
    @NSManaged public var postId: String!
    @NSManaged public var user: PFUser!
    @NSManaged public var commentText: String!
    @NSManaged public var numberOfLikes: Int
    @NSManaged public var likedUserIds: [String]!
    
    // MARK: - Like/dislike comment by current user
    
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
        if let index = likedUserIds.indexOf(currentUserObjectId) {
            numberOfLikes--
            likedUserIds.removeAtIndex(index)
            self.saveInBackground()
        }
    }
    
    override init() {
        super.init()
    }
    
    // MARK: - create new comment
    
    init(postId: String, user: PFUser, commentText: String, numberOfLikes: Int)
    {
        super.init()
        self.postId = postId
        self.user = user
        self.commentText = commentText
        self.numberOfLikes = numberOfLikes
        self.likedUserIds = [String]()
    }
    
    // MARK: - Register, call this before register for Parse
    
    override public class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    public static func parseClassName() -> String
    {
        return "Comment"
    }
    
}
