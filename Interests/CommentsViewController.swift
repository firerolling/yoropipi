//
//  CommentsViewController.swift
//  Interests
//
//  Created by Duc Tran on 6/14/15.
//  Copyright © 2015 Developer Inspirus. All rights reserved.
//

import UIKit
import Parse

class CommentsViewController: UIViewController
{
    // MARK: - Public API
    var post: Post!
    
    @IBOutlet weak var tableView: UITableView!
    private var newCommentButton: ActionButton!
    private var comments = [Comment]()
    
    // MARK: - View Controller Lifecycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        fetchComments()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        fetchComments()
        
        // configure the navigation bar
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = UIColor(hex: "EE8222")
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        
        title = "Comments"
        
        // configure the table view
        // make the table View to have dynamic height
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorColor = UIColor.clearColor()
        tableView.allowsSelection = false
        
        // CHALLENGE: write this function
        createNewPostButton()
    }
    
    // CHALLENGE: write this function
    func createNewPostButton()
    {
        newCommentButton = ActionButton(attachedToView: self.view, items: [])
        newCommentButton.action = { button in
            self.performSegueWithIdentifier("Show Comment Composer", sender: nil)
        }
        // set the button's backgroundColor
    }
    
    private func fetchComments()
    {
        let query = PFQuery(className: "Comment")
        query.whereKey("postId", equalTo: post.objectId!)
        query.orderByDescending("updatedAt")
        query.cachePolicy = PFCachePolicy.NetworkElseCache
        query.includeKey("user")
        
        query.findObjectsInBackgroundWithBlock { (optionalObjects, error) -> Void in
            if error == nil {
                if let commentObjects = optionalObjects as? [PFObject] {
                    if commentObjects.count > 0 {
                        self.comments.removeAll(keepCapacity: false)
                        for commentObject in commentObjects {
                            let comment = commentObject as! Comment
                            self.comments.append(comment)
                        }
                        self.tableView.reloadData()
                    }
                }
            } else {
                print(error!)
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Show Comment Composer" {
            let newCommentVC = segue.destinationViewController as! NewCommentViewController
            newCommentVC.post = post
        }
    
    }

}

extension CommentsViewController : UITableViewDataSource
{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return (comments.count + 1) // all the comments and the main post
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        // CHALLENGE: - configure the post cell
        if indexPath.row == 0 {
            if post.postImageFile == nil {
                // main post cell
                let cell = tableView.dequeueReusableCellWithIdentifier("PostCellWithoutImage", forIndexPath: indexPath) as! PostTableViewCell
                cell.post = post
                return cell
            } else {
                // main post cell
                let cell = tableView.dequeueReusableCellWithIdentifier("PostCellWithImage", forIndexPath: indexPath) as! PostTableViewCell
                cell.post = post
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("Comment Cell", forIndexPath: indexPath) as! CommentTableViewCell
            cell.comment = self.comments[indexPath.row - 1]
            return cell
        }
    }
}

































