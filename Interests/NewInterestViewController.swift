//
//  NewInterestViewController.swift
//  Interests
//
//  Created by Duc Tran on 6/15/15.
//  Copyright © 2015 Developer Inspirus. All rights reserved.
//

import UIKit
import Photos
import Parse

class NewInterestViewController: UIViewController
{
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var backgroundColorView: UIView!
    
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var newInterestTitleTextField: DesignableTextField!
    @IBOutlet weak var newInterestDescriptionTextView: UITextView!
    @IBOutlet weak var createNewInterestButton: DesignableButton!
    @IBOutlet weak var selectFeaturedImageButton: DesignableButton!

    @IBOutlet var hideKeyboardInputAccessoryView: UIView!
    
    private var featuredImage: UIImage!
    
    // MARK: - VC lifecycle
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newInterestTitleTextField.inputAccessoryView = hideKeyboardInputAccessoryView
        newInterestDescriptionTextView.inputAccessoryView = hideKeyboardInputAccessoryView
        
        // Do any additional setup after loading the view.
        newInterestTitleTextField.becomeFirstResponder()
        newInterestTitleTextField.delegate = self
        newInterestDescriptionTextView.delegate = self
        
        // handle text view
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    }
    // MARK: - Text View Handler
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func keyboardWillShow(notification: NSNotification)
    {
        let userInfo = notification.userInfo ?? [:]
        let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue().size
        
        self.newInterestDescriptionTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        self.newInterestDescriptionTextView.scrollIndicatorInsets = self.newInterestDescriptionTextView.contentInset
    }
    
    func keyboardWillHide(notification: NSNotification)
    {
        self.newInterestDescriptionTextView.contentInset = UIEdgeInsetsZero
        self.newInterestDescriptionTextView.scrollIndicatorInsets = UIEdgeInsetsZero
    }
    
    // MARK: - Target / Action
    
    @IBAction func dismiss(sender: UIButton)
    {
        hideKeyboard()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func selectFeaturedImageButtonClicked(sender: DesignableButton)
    {
        let authorization = PHPhotoLibrary.authorizationStatus()
        
        if authorization == .NotDetermined {
            PHPhotoLibrary.requestAuthorization({ (status) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.selectFeaturedImageButtonClicked(sender)
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
                        self.featuredImage = images[0]
                        self.backgroundImageView.image = self.featuredImage
                        self.backgroundColorView.alpha = 0.8
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
    
    @IBAction func createNewInterestButtonClicked(sender: DesignableButton)
    {
        if newInterestDescriptionTextView.text == "Describe your new interest..." || newInterestTitleTextField.text!.isEmpty {
            shakeTextField()
        } else if featuredImage == nil {
            shakePhotoButton()
        } else {
            // create a new interest
            // ..
            
            createNewInterest()
            
            self.hideKeyboard()
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func createNewInterest()
    {
        let featuredImageFile = createFileFrom(self.featuredImage)
        let currentUser = "\(PFUser.currentUser()?.objectId)"
        
        let newInterest = Interest(title: newInterestTitleTextField.text!, interestDescription: newInterestDescriptionTextView.text!, imageFile: featuredImageFile, numberOfMembers: 1, numberOfChats: 0, numberOfPlaces: 0, numberOfPosts: 0, createdUser: currentUser, isDesided: false, placeIsDesided: false, selectedDate: "", selectedPlace: "", selectedUrl: "")
        
        newInterest.saveInBackgroundWithBlock({ (success, error) -> Void in
            if error == nil {
                // success
                // update the current user's interestIds
                let currentUser = User.currentUser()!
                if(currentUser.interestIds == nil){
                    currentUser.interestIds = []
                }
                currentUser.joinInterest(newInterest.objectId!)
                
                let center = NSNotificationCenter.defaultCenter()
                let notification = NSNotification(name: "NewInterestCreated", object: nil, userInfo: ["newInterestObject" : newInterest])
                center.postNotification(notification)
            } else {
                // fail
                print("\(error!.localizedDescription)")
            }
        })
    }
    
    struct ImageSize {
        static let height: CGFloat = 480.0
    }
    
    func createFileFrom(image: UIImage) -> PFFile!
    {

        let ratio = image.size.width / image.size.height
        let resizedImage = resizeImage(image, toWidth: ImageSize.height * ratio, andHeight: ImageSize.height)
        let imageData = UIImageJPEGRepresentation(resizedImage, 0.8)!
        return PFFile(name: "image.jpg", data: imageData)
    }
    
    func resizeImage(originalImage: UIImage, toWidth width: CGFloat, andHeight height: CGFloat) -> UIImage
    {
        let newSize = CGSizeMake(width, height)
        let newRectangle = CGRectMake(0, 0, width, height)
        UIGraphicsBeginImageContext(newSize)
        originalImage.drawInRect(newRectangle)
        
        let resizedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage
    }
    
    func shakeTextField()
    {
        newInterestTitleTextField.animation = "shake"
        newInterestTitleTextField.curve = "spring"
        newInterestTitleTextField.duration = 1.0
        newInterestTitleTextField.animate()
    }
    
    func shakePhotoButton()
    {
        selectFeaturedImageButton.animation = "shake"
        selectFeaturedImageButton.curve = "spring"
        selectFeaturedImageButton.duration = 1.0
        selectFeaturedImageButton.animate()
    }
    
    @IBAction func hideKeyboard()
    {
        if newInterestDescriptionTextView.isFirstResponder() {
            newInterestDescriptionTextView.resignFirstResponder()
        } else if newInterestTitleTextField.isFirstResponder() {
            newInterestTitleTextField.resignFirstResponder()
        }
    }
    
}

// MARK: - UITextFieldDelegate

extension NewInterestViewController : UITextFieldDelegate
{
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if newInterestDescriptionTextView.text == "Describe your new interest..." && !textField.text!.isEmpty {
            newInterestDescriptionTextView.becomeFirstResponder()
        } else if newInterestTitleTextField.text!.isEmpty {
            shakeTextField()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
}

extension NewInterestViewController : UITextViewDelegate
{
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        textView.text = ""
        return true
    }
    
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        if textView.text.isEmpty {
            textView.text = "Describe your new interest..."
        }
        
        return true
    }
}


extension NewInterestViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        self.backgroundImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        featuredImage = self.backgroundImageView.image
        self.backgroundColorView.alpha = 0.8
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}


























