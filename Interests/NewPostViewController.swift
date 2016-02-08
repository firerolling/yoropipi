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
    @IBOutlet weak var postImageView: UIImageView!
    
    private var postImage: UIImage! // use this one to store post image - send it to Parse
    
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
   
    @IBAction func pickFeaturedImageClicked(sender: UITapGestureRecognizer)
    {
        let authorization = PHPhotoLibrary.authorizationStatus()
        
        if authorization == .NotDetermined {
            PHPhotoLibrary.requestAuthorization({ (status) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.pickFeaturedImageClicked(sender)
                })
            })
            return
        }
        
        if authorization == .Authorized {
            let controller = ImagePickerSheetController()
            
            controller.addAction(ImageAction(title: NSLocalizedString("Take Photo or Video", comment: "ActionTitle"),
                secondaryTitle: NSLocalizedString("Use this one", comment: "Action Title"),
                handler: { (_) -> () in
                    
                    self.presentCamera()
                    
                }, secondaryHandler: { (action, numberOfPhotos) -> () in
                    controller.getSelectedImagesWithCompletion({ (images) -> Void in
                        self.postImage = images[0]
                        self.postImageView.image = self.postImage
                    })
            }))
            
            controller.addAction(ImageAction(title: NSLocalizedString("Cancel", comment: "Action Title"), style: .Cancel, handler: nil, secondaryHandler: nil))
            
            presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    func presentCamera()
    {
        // CHALLENGE: present normla image picker controller
        //              update the postImage + postImageView
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
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
        let newPost = Post(user: PFUser.currentUser()!, postImage: postImage, postText: postContentTextView.text, numberOfLikes: 0, interestId: interest.objectId!)
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

extension NewPostViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        self.postImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}





















