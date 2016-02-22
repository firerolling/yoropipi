//
//  HomeViewController.swift
//  Interests
//
//  Created by Duc Tran on 6/13/15.
//  Copyright © 2015 Developer Inspirus. All rights reserved.
//

import UIKit
import Photos
import Parse
import ParseUI
import JavaScriptCore

class HomeViewController: UIViewController
{
    // MARK: - IBOutlets
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var currentUserProfileImageButton: UIButton!
    @IBOutlet weak var currentUserFullNameButton: UIButton!
    
     private var featuredImage: UIImage!
    
    
    ///ボタンのイメージ
    var buttonImg = UIImage()
    
    let profileBackView = UIView()
    let profileView = UIView()
    var profileImage = UIImageView()
    let profileName = UILabel()
    let reviewButton = UIButton()
    let findButton = UIButton()
    let logoutButton = UIButton()
    let saveButton = UIButton()
    let profileCloseButton = UIButton()
    let profileImageSelectButton = UIButton()
    var presetImage = UIImage(named: "logo")
    
    //吹き出し三角形
    let triangle = UIImageView(image: UIImage(named: "triangle")?.imageWithRenderingMode(.AlwaysTemplate))
    
    // MARK: - UICollectionViewDataSource
    private var interests = [Interest]()

    private var slideRightTransitionAnimator = SlideRightTransitionAnimator()
    private var popTransitionAnimator = PopTransitionAnimator()
    private var slideRightThenPop = SlideRightThenPopTransitionAnimator()
    
    
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
       
                

        
        if PFUser.currentUser() == nil {
            // the user hasn't logged in yet
            presentLoginViewController()
        } else {
            // the user logged in, do sth else
            fetchInterests()
            
            let center = NSNotificationCenter.defaultCenter()
            let queue = NSOperationQueue.mainQueue()
            center.addObserverForName("NewInterestCreated", object: nil, queue: queue, usingBlock: { (notification) -> Void in
                
                if let newInterest = notification.userInfo?["newInterestObject"] as? Interest {
                    if !self.interestWasDisplayed(newInterest) {
                        self.interests.insert(newInterest, atIndex: 0)
                        self.collectionView.reloadData()
                    }
                }
                
            })
            
            disp()
            
        }
        
    }
    
    func disp(){
        
        
        
        
        //ボタンへの画像設定
        currentUserProfileImageButton.setImage(presetImage, forState: .Normal)
        
        //profileの透過ビュー
        
        profileBackView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        profileBackView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        
        //プロフィール部分
        
        profileView.backgroundColor = UIColor(hex: "#F2F1EF")
        profileView.layer.cornerRadius = 20.0
        profileView.frame.origin.x = self.view.frame.width*0.3/2
        profileView.frame.origin.y = self.view.frame.height*0.3/2
        profileView.frame.size.width = self.view.frame.width*0.7
        profileView.frame.size.height = self.view.frame.height*0.7
        self.profileBackView.addSubview(profileView)
        //吹き出し
        
        triangle.frame = CGRect(x: self.view.frame.width*0.3/2+self.profileView.frame.width/2-10, y: self.profileView.frame.origin.y-20, width: 20, height: 20)
        let angle:CGFloat = CGFloat((90.0 * M_PI) / 180.0)
        triangle.transform = CGAffineTransformMakeRotation(angle)
        triangle.tintColor = UIColor(hex: "#F2F1EF")
        self.profileBackView.addSubview(triangle)
        
        
        
        
        
        
        //閉じるボタン
        profileCloseButton.setTitle("×", forState: .Normal)
        profileCloseButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        profileCloseButton.backgroundColor = UIColor(hex: "#36D7B7")
        profileCloseButton.layer.cornerRadius = currentUserProfileImageButton.frame.width/2
        profileCloseButton.frame = CGRect(x: self.profileBackView.frame.width/2-currentUserProfileImageButton.frame.width/2, y: currentUserProfileImageButton.frame.origin.y, width: currentUserProfileImageButton.frame.width, height: currentUserProfileImageButton.frame.height)
        self.profileBackView.addSubview(profileCloseButton)
        profileCloseButton.addTarget(self, action: "tapped:", forControlEvents: .TouchUpInside)
        
        
        //ユーザープロフィール写真選択ボタン
        profileImageSelectButton.backgroundColor = UIColor(hex: "#36D7B7")
        profileImageSelectButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        profileImageSelectButton.setTitle("+", forState: .Normal)
        profileImageSelectButton.layer.cornerRadius = 20
        profileImageSelectButton.frame = CGRect(x: self.profileBackView.frame.width/2-currentUserProfileImageButton.frame.width/2+70, y: currentUserProfileImageButton.frame.origin.y+180, width: 40, height: 40)
        self.profileBackView.addSubview(profileImageSelectButton)
        self.profileBackView.bringSubviewToFront(profileImageSelectButton)
        profileImageSelectButton.addTarget(self, action: "selected:", forControlEvents: .TouchUpInside)
        
        //ユーザープロフィール写真表示
        
        
        profileImage.image = presetImage
        profileImage.frame = CGRect(x: self.profileBackView.frame.width/2-50, y: 150, width: 100, height: 100)
        profileImage.layer.cornerRadius = 50.0
        profileImage.layer.masksToBounds = true
        self.profileBackView.addSubview(profileImage)
        
        //ユーザー名表示
        let currentUser = PFUser.currentUser()
        profileName.text = currentUser?.username
        profileName.frame = CGRect(x: self.view.frame.width*0.3/2, y: profileImage.frame.origin.y + profileImage.frame.height+20, width: self.profileView.frame.width, height: 50)
        profileName.font = UIFont(name: "Avenir", size: 28)
        profileName.textColor = UIColor.darkGrayColor()
        profileName.textAlignment = .Center
        self.profileBackView.addSubview(profileName)
        
        
        
        let profileNameEndY = profileName.frame.origin.y+profileName.frame.height
        let profileViewEndY = profileView.frame.origin.y+profileView.frame.height
        let space = profileViewEndY - profileNameEndY
        let generalHeight = space/4
        let generalX = self.view.frame.width*0.3/2
        let generalWidth = self.profileView.frame.width
        
        //保存ボタン
        saveButton.setTitle("Save", forState: .Normal)
        saveButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        saveButton.backgroundColor = UIColor(hex: "#F64747")
        saveButton.frame = CGRect(x: generalX, y: profileNameEndY, width: generalWidth, height:generalHeight )
        saveButton.titleLabel?.font = UIFont(name: "Avenir", size: 20)
        self.profileBackView.addSubview(saveButton)
        saveButton.addTarget(self, action: "save:", forControlEvents: .TouchUpInside)
        
        //レビューボタン
        reviewButton.setTitle("Review Yoropy", forState: .Normal)
        reviewButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        reviewButton.backgroundColor = UIColor(hex: "#36D7B7")
        reviewButton.titleLabel?.font = UIFont(name: "Avenir", size: 20)
        reviewButton.frame = CGRect(x: generalX, y: profileNameEndY+generalHeight, width: generalWidth, height:generalHeight )
        self.profileBackView.addSubview(reviewButton)
        reviewButton.addTarget(self, action: "review:", forControlEvents: .TouchUpInside)
        
        //友達探すボタン
        findButton.setTitle("Find Friends", forState: .Normal)
        findButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        findButton.backgroundColor = UIColor(hex: "#36D7B7")
        findButton.titleLabel?.font = UIFont(name: "Avenir", size: 20)
        findButton.frame = CGRect(x: generalX, y: profileNameEndY+generalHeight*2, width: generalWidth, height:generalHeight )
        self.profileBackView.addSubview(findButton)
        findButton.addTarget(self, action: "find:", forControlEvents: .TouchUpInside)
        
        //ログアウト
        logoutButton.setTitle("LogOut", forState: .Normal)
        logoutButton.setTitleColor(UIColor(hex: "#6C7A89"), forState: .Normal)
        logoutButton.titleLabel?.font = UIFont(name: "Avenir", size: 20)
        logoutButton.frame = CGRect(x: generalX, y: profileNameEndY+generalHeight*3, width: generalWidth, height:generalHeight )
        self.profileBackView.addSubview(logoutButton)
        logoutButton.addTarget(self, action: "logout:", forControlEvents: .TouchUpInside)
        
        
        
        
        print(profileNameEndY)
        print(profileViewEndY)
        
        print(generalX)
        print(generalHeight)
        print(generalWidth)
    }
    
    
    
    func interestWasDisplayed(newInterest: Interest) -> Bool {
        for interest in interests {
            if interest.objectId! == newInterest.objectId! {
                return true
            }
        }
        return false
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
<<<<<<< HEAD
        


=======
>>>>>>> dc6bdf8ef832d57e656c64783264ccd1bd698566
        // Do any additional setup after loading the view.
        if UIScreen.mainScreen().bounds.size.height == 480.0 {
            let flowLayout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
            flowLayout.itemSize = CGSizeMake(250.0, 300.0)
        }
    
        
        
        configureUserProfile()
    }
    
<<<<<<< HEAD
    func tapped(sender: UIButton) {
        self.profileBackView.removeFromSuperview()
    }
    func review(sender: UIButton) {
        print("review")
    }

    func save(sender: UIButton) {
        print("save")
        updateUser()
    }

    func logout(sender: UIButton) {
        print("logout")
        PFUser.logOut()
        let currentUser = PFUser.currentUser()
        if currentUser != nil {}
        self.profileBackView.removeFromSuperview()
        self.dismissViewControllerAnimated(true, completion: nil)
        
        presentLoginViewController()
    }
    func find(sender: UIButton) {
        print("find")
    }

    
    func selected(sender: UIButton) {
        let authorization = PHPhotoLibrary.authorizationStatus()
        
        if authorization == .NotDetermined {
            PHPhotoLibrary.requestAuthorization({ (status) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.selected(sender)
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
                        self.profileImage.image = self.featuredImage

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
    
    
    func updateUser() {
        let featuredImageFile = createFileFrom(self.featuredImage)
        if let currentUser = PFUser.currentUser() {
            currentUser["profileImageFile"] = featuredImageFile
            currentUser.saveInBackground()
        }
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


=======
    
>>>>>>> dc6bdf8ef832d57e656c64783264ccd1bd698566
    
    func configureUserProfile()
    {
        // configure image button
        currentUserProfileImageButton.contentMode = UIViewContentMode.ScaleAspectFill
        currentUserProfileImageButton.layer.cornerRadius = currentUserProfileImageButton.bounds.width / 2
        currentUserProfileImageButton.layer.masksToBounds = true
                      
        }

    
    private struct Storyboard {
        static let CellIdentifier = "Interest Cell"
    }
    
    @IBAction func profileImageClicked(sender: AnyObject) {
        
        self.view.addSubview(profileBackView)
    }
   
    @IBAction func userProfileButtonClicked()
    {
        print("いらない")
    }
    
    // MARK: - Fetch Data From Parse
    
    func fetchInterests()
    {
        let currentUser = User.currentUser()!
        if let interestIds = currentUser.interestIds{
        if interestIds.count > 0
        {
            let interestQuery = PFQuery(className: Interest.parseClassName())
            interestQuery.cachePolicy = PFCachePolicy.NetworkElseCache
            interestQuery.orderByDescending("updatedAt")
            interestQuery.whereKey("objectId", containedIn: interestIds)
            
            interestQuery.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                if error == nil {
                    if let interestObjects = objects as? [PFObject] {
                        self.interests.removeAll()
                        for interestObject in interestObjects {
                            let interest = interestObject as! Interest
                            self.interests.append(interest)
                        }
                        
                        self.collectionView.reloadData()
                    }
                } else {
                    print("aaa")
                }
            })
        }
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Show Interest" {
            let cell = sender as! InterestCollectionViewCell
            let interest = cell.interest
            
            let navigationViewController = segue.destinationViewController as! UINavigationController
            navigationViewController.transitioningDelegate = popTransitionAnimator

            
            var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
        print(interest)
            appDelegate.interest = interest
            
            
            
        } else if segue.identifier == "CreateNewInterest" {
            let newInterestViewController = segue.destinationViewController as! NewInterestViewController
            newInterestViewController.transitioningDelegate = slideRightThenPop
        } else if segue.identifier == "Show Discover" {
            let discoverViewController = segue.destinationViewController as! DiscoverViewController
            discoverViewController.transitioningDelegate = slideRightThenPop
        }
    }
}

extension HomeViewController : UICollectionViewDataSource
{
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return interests.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Storyboard.CellIdentifier, forIndexPath: indexPath) as! InterestCollectionViewCell
        
        cell.interest = self.interests[indexPath.item]
        
        return cell
    }
}

extension HomeViewController : UIScrollViewDelegate
{
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
    {
        let layout = self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        
        var offset = targetContentOffset.memory
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        let roundedIndex = round(index)
        
        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
        targetContentOffset.memory = offset
    }
}



// MARK: - Login / Signup

extension HomeViewController : PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate
{
    func presentLoginViewController()
    {
        let loginController = PFLogInViewController()
        let signupController = PFSignUpViewController()
        
        signupController.delegate = self
        loginController.delegate = self
        
        loginController.fields = [PFLogInFields.UsernameAndPassword, PFLogInFields.LogInButton, PFLogInFields.SignUpButton]
        loginController.signUpController = signupController
        
        presentViewController(loginController, animated: true, completion: nil)
    }
    
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser)
    {
        logInController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        signUpController.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

extension HomeViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        self.backgroundImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        featuredImage = self.backgroundImageView.image
        featuredImage = self.buttonImg
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    














