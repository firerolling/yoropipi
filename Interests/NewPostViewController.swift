//
//  NewPostViewController.swift
//  Interests
//
//  Created by Duc Tran on 6/14/15.
//  Copyright © 2015 Developer Inspirus. All rights reserved.
//

import UIKit
import Photos
import Parse

class NewPostViewController: UIViewController {
    
    var interest: Interest!

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var currentUserProfileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postContentTextView: UITextView!

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let currentUser = User.currentUser()!
        self.usernameLabel.text! = currentUser.username!
        if let imageFile = currentUser.profileImageFile {
            imageFile.getDataInBackgroundWithBlock({ (data, error) -> Void in
                if error == nil {
                    if let imageData = data {
                        if let image = UIImage(data: imageData) {
                            self.currentUserProfileImageView.image! = image
                        }
                    }
                }
            })
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        postContentTextView.becomeFirstResponder()
        postContentTextView.text = ""
        
        // CHALLENGE: - make the user profile image rounded
        currentUserProfileImageView.layer.cornerRadius = currentUserProfileImageView.bounds.width / 2
        currentUserProfileImageView.layer.masksToBounds = true
        
        // handle text view
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    // MARK: - Text View Handler
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func keyboardWillShow(notification: NSNotification)
    {
        let userInfo = notification.userInfo ?? [:]
        let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue().size
        
        self.postContentTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        self.postContentTextView.scrollIndicatorInsets = self.postContentTextView.contentInset
    }
    
    func keyboardWillHide(notification: NSNotification)
    {
        self.postContentTextView.contentInset = UIEdgeInsetsZero
        self.postContentTextView.scrollIndicatorInsets = UIEdgeInsetsZero
    }
    
    
    // MARK: - Pick Featured Image
   
    
    @IBAction func dismiss()
    {
        postContentTextView.resignFirstResponder()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func post()
    {
        uploadNewPost()
        postContentTextView.resignFirstResponder()
        
    }
    
    func uploadNewPost()
    {
        
        let currentUser = PFUser.currentUser()!
        let newPost = Post(user: currentUser, postText: postContentTextView.text, numberOfLikes: 0, interestId: interest.objectId!, isSelected: false)
        newPost.saveInBackgroundWithBlock { (success, error) -> Void in
            if error == nil {
                self.interest.incrementNumberOfPosts()
            } else {
                print("\(error?.localizedDescription)")
            }
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }
    }
}






















