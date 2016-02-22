
//
//  Chat.swift
//  interests
//
//  Created by 株式会社ConU on 2016/02/16.
//  Copyright © 2016年 Developer Inspirus. All rights reserved.
//

import UIKit
import Parse

public class Chat: PFObject, PFSubclassing
{
    // MARK: - Public API
    
    @NSManaged public var user: PFUser // must use PFUser
    @NSManaged public var chatText: String
    @NSManaged public var numberOfLikes: Int
    @NSManaged public var interestId: String!
    @NSManaged public var likedUserIds: [String]!
    
    // MARK: - Create new post
    override init() {
        super.init()
    }
    
    init(user: PFUser, chatText: String, numberOfLikes: Int, interestId: String)
    {
        super.init()
        
        self.user = user
        self.chatText = chatText
        self.numberOfLikes = numberOfLikes
        self.interestId = interestId
        self.likedUserIds = [String]()
        
        
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
        return "Chat"
    }
    
}






