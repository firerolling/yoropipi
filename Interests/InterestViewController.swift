//
//  InterestViewController.swift
//  Interests
//
//  Created by Duc Tran on 6/13/15.
//  Copyright © 2015 Developer Inspirus. All rights reserved.
//
//  interest information + posts

import UIKit
import Parse

class InterestViewController: UIViewController {
    
    // MARK: - Public API
    var interest: Interest!
    
    // MARK: - Private
    @IBOutlet weak var tableView: UITableView!
    private let tableHeaderHeight: CGFloat = 350.0
    private let tableHeaderCutAway: CGFloat = 50.0
    
    private var headerView: InterestHeaderView!
    private var headerMaskLayer: CAShapeLayer!
    
    // Datasource
    private var posts = [Post]()
    
    private var newPostButton: ActionButton!
    
    // MARK: - View Controller Life Cycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        fetchPosts()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 387.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        headerView = tableView.tableHeaderView as! InterestHeaderView
        headerView.delegate = self
        headerView.interest = interest
        
        tableView.tableHeaderView = nil
        tableView.addSubview(headerView)
        
        tableView.contentInset = UIEdgeInsets(top: tableHeaderHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -tableHeaderHeight)
        
        headerMaskLayer = CAShapeLayer()
        headerMaskLayer.fillColor = UIColor.blackColor().CGColor
        headerView.layer.mask = headerMaskLayer
        
        updateHeaderView()
        createNewPostButton()
        
        fetchPosts()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateHeaderView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateHeaderView()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func updateHeaderView()
    {
        let effectiveHeight = tableHeaderHeight - tableHeaderCutAway / 2
        var headerRect = CGRect(x: 0, y: -effectiveHeight, width: tableView.bounds.width, height: tableHeaderHeight)
        
        if tableView.contentOffset.y < -effectiveHeight {
            headerRect.origin.y = tableView.contentOffset.y
            headerRect.size.height = -tableView.contentOffset.y + tableHeaderCutAway/2
        }
        
        headerView.frame = headerRect
        
        // cut away
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: 0, y: 0))
        path.addLineToPoint(CGPoint(x: headerRect.width, y: 0))
        path.addLineToPoint(CGPoint(x: headerRect.width, y: headerRect.height))
        path.addLineToPoint(CGPoint(x: 0, y: headerRect.height - tableHeaderCutAway))
        headerMaskLayer?.path = path.CGPath
        
    }
    
    func fetchPosts()
    {
        let interestId = interest.objectId!
        let query = PFQuery(className: Post.parseClassName())
        query.cachePolicy = PFCachePolicy.NetworkElseCache
        query.whereKey("interestId", equalTo: interestId)
        query.orderByDescending("createdAt")
        query.includeKey("user")
        
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                self.posts.removeAll()
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        let post = object as! Post
                        self.posts.append(post)
                    }
                    self.tableView?.reloadData()
                }
            } else {
                print("\(error?.localizedDescription)")
            }
        }
    }
    
    func createNewPostButton()
    {
        newPostButton = ActionButton(attachedToView: self.view, items: [])
        newPostButton.action = { button in
            self.performSegueWithIdentifier("Show Post Composer", sender: nil)
        }
        // set the button's backgroundColor
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Show Comments" {
            let commentsVC = segue.destinationViewController as! CommentsViewController
            commentsVC.post = sender as! Post
        } else if segue.identifier == "Show Post Composer" {
            let postComposer = segue.destinationViewController as! NewPostViewController
            postComposer.interest = interest
        }
    }
    
}

extension InterestViewController : UITableViewDataSource
{
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let post = posts[indexPath.row]
        
        if post.postImageFile != nil {
            let cell = tableView.dequeueReusableCellWithIdentifier("PostCellWithImage", forIndexPath: indexPath) as! PostTableViewCell
            cell.post = post
            cell.delegate = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("PostCellWithoutImage", forIndexPath: indexPath) as! PostTableViewCell
            cell.post = post
            cell.delegate = self
            return cell
        }
    }
    
}

extension InterestViewController : UITableViewDelegate
{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.performSegueWithIdentifier("Show Comments", sender: self.posts[indexPath.row])
    }
}

extension InterestViewController : UIScrollViewDelegate
{
    func scrollViewDidScroll(scrollView: UIScrollView)
    {
        updateHeaderView()
        
        // CHALLENGE: - Add code to show/hide "Pull down to close"
        let offsetY = scrollView.contentOffset.y
        let adjustment: CGFloat = 130.0
        
        // for later use
        if (-offsetY) > (tableHeaderHeight+adjustment) {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        if (-offsetY) > (tableHeaderHeight) {
            self.headerView.pullDownToCloseLabel.hidden = false
        } else {
            self.headerView.pullDownToCloseLabel.hidden = true
        }
    }
}

extension InterestViewController : InterestHeaderViewDelegate
{
    func closeButtonClicked() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension InterestViewController : PostTableViewCellDelegate
{
    func commentButtonClicked(post: Post)
    {
        self.performSegueWithIdentifier("Show Comments", sender: post)
    }
}





























