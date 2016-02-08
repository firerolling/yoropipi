//
//  NewCommentViewController.swift
//  ProjectInterest
//
//  Created by Duc Tran on 6/3/15.
//  Copyright (c) 2015 Developer Inspirus. All rights reserved.
//

import UIKit

class NewCommentViewController: UIViewController
{
    var post: Post!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var currentUserProfileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.barTintColor = UIColor(hex: "EE8222")
        
        // Show the keyboard
        commentTextView.becomeFirstResponder()
        commentTextView.text = ""
        
        // Do any additional setup after loading the view.
        // Notification for keyboard
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        
        // profile image
        if let currentUser = User.currentUser() {
            self.usernameLabel.text = currentUser.username
            let profileImageFile = currentUser.profileImageFile
            profileImageFile?.getDataInBackgroundWithBlock({ (imageData, error) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        if let image = UIImage(data: imageData) {
                            self.currentUserProfileImageView.image = image
                        }
                    }
                }
            })
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    // MARK: - Target Action
    
    @IBAction func postDidTap()
    {
        createNewComment()
        commentTextView.resignFirstResponder()
    }
    
    
    // Later use - Send to Parse
    
    func createNewComment()
    {
        let newComment = Comment(postId: post.objectId!, user: User.currentUser()!, commentText: commentTextView.text, numberOfLikes: 0)
        newComment.saveInBackgroundWithBlock { (success, error) -> Void in
            if error == nil {
            
            } else {
                print("\(error?.localizedDescription)")
            }
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    @IBAction func dismissComposer()
    {
        commentTextView.resignFirstResponder()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Text View Keyboard Handling
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)   // remove the notification when deinit
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let userInfo = notification.userInfo ?? [:]
        let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue().size
        self.commentTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        
        self.commentTextView.scrollIndicatorInsets = self.commentTextView.contentInset
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.commentTextView.contentInset = UIEdgeInsetsZero
        self.commentTextView.scrollIndicatorInsets = UIEdgeInsetsZero
    }
    
    
}
