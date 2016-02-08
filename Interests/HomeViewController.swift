//
//  HomeViewController.swift
//  Interests
//
//  Created by Duc Tran on 6/13/15.
//  Copyright © 2015 Developer Inspirus. All rights reserved.
//

import UIKit
import Parse
import ParseUI


class HomeViewController: UIViewController
{
    // MARK: - IBOutlets
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var currentUserProfileImageButton: UIButton!
    @IBOutlet weak var currentUserFullNameButton: UIButton!
    
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
            
        }
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

        // Do any additional setup after loading the view.
        if UIScreen.mainScreen().bounds.size.height == 480.0 {
            let flowLayout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
            flowLayout.itemSize = CGSizeMake(250.0, 300.0)
        }
        
        configureUserProfile()
    }
    
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
    
    @IBAction func userProfileButtonClicked()
    {
        PFUser.logOut()
        presentLoginViewController()
    }
    
    // MARK: - Fetch Data From Parse
    
    func fetchInterests()
    {
        let currentUser = User.currentUser()!
        let interestIds = currentUser.interestIds
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
                    print("\(error!.localizedDescription)")
                }
            })
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Show Interest" {
            let cell = sender as! InterestCollectionViewCell
            let interest = cell.interest
            
            let navigationViewController = segue.destinationViewController as! UINavigationController
            navigationViewController.transitioningDelegate = popTransitionAnimator
            
            let interestViewController = navigationViewController.topViewController as! InterestViewController
            interestViewController.interest = interest
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

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    














