//
//  CommentTableViewCell.swift
//  Interests
//
//  Created by Duc Tran on 6/14/15.
//  Copyright © 2015 Developer Inspirus. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell
{
    // MARK: - Public API
    var comment: Comment! {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var commentTextLabel: UILabel!
    @IBOutlet weak var likeButton: DesignableButton!
    
    // MARK: - Private
    
    private func updateUI()
    {
        userNameLabel?.text = comment.user.username!
        commentTextLabel?.text = comment.commentText
        
        likeButton.setTitle("👻 \(comment.numberOfLikes) Likes", forState: .Normal)
        
        changeLikeButtonColor()
    }
    
    private func configureButtonAppearance()
    {
        likeButton.cornerRadius = 3.0
        likeButton.borderWidth = 2.0
        likeButton.borderColor = UIColor.lightGrayColor()
    }
    
    @IBAction func likeButtonClicked(sender: DesignableButton)
    {
        if currentUserLikes() {
            comment.dislike()
        } else {
            comment.like()
        }
        
        likeButton.setTitle("👻 \(comment.numberOfLikes) Likes", forState: .Normal)
        changeLikeButtonColor()
        
        // animation
        sender.animation = "pop"
        sender.curve = "spring"
        sender.duration = 1.5
        sender.damping = 0.1
        sender.velocity = 0.2
        sender.animate()
    }
    
    func currentUserLikes() -> Bool {
        if let ids = comment.likedUserIds {
            if ids.contains(User.currentUser()!.objectId!) {
                return true
            }
        }
        return false
    }
    
    private func changeLikeButtonColor()
    {
        if currentUserLikes() {
            likeButton.borderColor = UIColor.redColor()
            likeButton.tintColor = UIColor.redColor()
        } else {
            likeButton.borderColor = UIColor.lightGrayColor()
            likeButton.tintColor = UIColor.lightGrayColor()
        }
        
    }
}





























