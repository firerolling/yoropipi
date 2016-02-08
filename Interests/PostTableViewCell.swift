//
//  PostTableViewCell.swift
//  Interests
//
//  Created by Duc Tran on 6/13/15.
//  Copyright © 2015 Developer Inspirus. All rights reserved.
//

import UIKit

protocol PostTableViewCellDelegate
{
    func commentButtonClicked(post: Post)
}

class PostTableViewCell: UITableViewCell
{
    // MARK: - Public API
    var post: Post! {
        didSet {
            updateUI()
        }
    }
    
    var delegate: PostTableViewCellDelegate!
    
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postTextLabel: UILabel!
    @IBOutlet weak var likeButton: DesignableButton!
    @IBOutlet weak var commentButton: DesignableButton!
    
    // MARK: - Private
    
    private func updateUI()
    {
        // user profile image
        let user = post.user as! User
        user.profileImageFile?.getDataInBackgroundWithBlock { (data, error) -> Void in
            if error == nil {
                if let imageData = data {
                    self.userProfileImageView.image = UIImage(data: imageData)!
                }
            }
        }
        
        userNameLabel?.text = post.user.username!
        createdAtLabel?.text = NSDate.shortStringFromDate(post.createdAt!)
        postTextLabel?.text = post.postText

        post.postImageFile?.getDataInBackgroundWithBlock { (data, error) -> Void in
            if error == nil {
                if let imageData = data {
                    self.postImageView.image = UIImage(data: imageData)!
                }
            }
        }
        
        // rounded post image view, user profile image
        postImageView?.layer.cornerRadius = 5.0
        postImageView?.layer.masksToBounds = true
        
        userProfileImageView?.layer.cornerRadius = userProfileImageView.bounds.width / 2
        userProfileImageView?.layer.masksToBounds = true
        
        likeButton.setTitle(" \(post.numberOfLikes)", forState: .Normal)
        
        configureButtonAppearance()
        changeLikeButtonColor()
    }
    
    private func configureButtonAppearance()
    {
        likeButton.cornerRadius = 20.0
        likeButton.borderWidth = 1.0
        likeButton.borderColor = UIColor.lightGrayColor()
        
        let setImage = UIImage(named: "heart")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        
    
        likeButton.setImage(setImage, forState: .Normal)
        
        commentButton?.cornerRadius = 3.0
        commentButton?.borderWidth = 2.0
        commentButton?.borderColor = UIColor.lightGrayColor()
    }
    
    @IBAction func likeButtonClicked(sender: DesignableButton)
    {
        if currentUserLikes() {
            post.dislike()
        } else {
            post.like()
        }
        likeButton.setTitle("\(post.numberOfLikes)", forState: .Normal)
        changeLikeButtonColor()
        
        // animation
        sender.animation = "pop"
        sender.curve = "spring"
        sender.duration = 1.5
        sender.damping = 0.1
        sender.velocity = 0.2
        sender.animate()
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
    
    func currentUserLikes() -> Bool {
        if let ids = post.likedUserIds {
            if ids.contains(User.currentUser()!.objectId!) {
                return true
            }
        }
        return false
    }
    
    @IBAction func commentButtonClicked(sender: DesignableButton)
    {
        // animation
        sender.animation = "pop"
        sender.curve = "spring"
        sender.duration = 1.5
        sender.damping = 0.1
        sender.velocity = 0.2
        sender.animate()
        
        delegate?.commentButtonClicked(post)
    }
    
}























