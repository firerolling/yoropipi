//
//  ChatTableViewCell.swift
//  interests
//
//  Created by 株式会社ConU on 2016/02/16.
//  Copyright © 2016年 Developer Inspirus. All rights reserved.
//


import UIKit

protocol ChatTableViewCellDelegate
{
    func commentButtonClicked(post: Post)
}

class ChatTableViewCell: UITableViewCell
{
    // MARK: - Public API
    var chat: Chat! {
        didSet {
            updateUI()
        }
    }
    
    var delegate: ChatTableViewCellDelegate!
    
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var chatTextLabel: UILabel!
    @IBOutlet weak var likeButton: DesignableButton!
    
    // MARK: - Private
    
    private func updateUI()
    {
        // user profile image
        let user = chat.user as! User
        user.profileImageFile?.getDataInBackgroundWithBlock { (data, error) -> Void in
            if error == nil {
                if let imageData = data {
                    self.userProfileImageView.image = UIImage(data: imageData)!
                }
            }
        }
        
        userNameLabel?.text = chat.user.username!
        createdAtLabel?.text = NSDate.shortStringFromDate(chat.createdAt!)
        chatTextLabel?.text = chat.chatText
        
        
        
        
        // rounded post image view, user profile image
        
        userProfileImageView?.layer.cornerRadius = userProfileImageView.bounds.width / 2
        userProfileImageView?.layer.masksToBounds = true
        
        likeButton.setTitle(" \(chat.numberOfLikes)", forState: .Normal)
        
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
        
        
    }
    
    @IBAction func likeButtonClicked(sender: DesignableButton)
    {
        if currentUserLikes() {
            chat.dislike()
        } else {
            chat.like()
        }
        likeButton.setTitle("\(chat.numberOfLikes)", forState: .Normal)
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
        if let ids = chat.likedUserIds {
            if ids.contains(User.currentUser()!.objectId!) {
                return true
            }
        }
        return false
    }
    
    
}



