//
//  DiscoverViewController.swift
//  Interests
//
//  Created by Duc Tran on 6/16/15.
//  Copyright © 2015 Developer Inspirus. All rights reserved.
//

import UIKit
import Parse

class DiscoverViewController: UIViewController
{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var searchBarInputAccessoryView: UIView!
    
    private var searchText: String! {
        didSet {
            searchInterestsForKey(searchText)
        }
    }
    
    private var interests = [Interest]()
    private var popTransitionAnimator = PopTransitionAnimator()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make the row height dynamic
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // backgroundColor, separator, don't allow selection
        tableView.backgroundColor = UIColor.clearColor()
        tableView.separatorColor = UIColor.clearColor()
        tableView.allowsSelection = false

        searchBar.delegate = self
        
        suggestInterests()
    }
    
    func searchInterestsForKey(key: String)
    {
        let pred = NSPredicate(format: "title BEGINSWITH %@ OR description BEGINSWITH %@", argumentArray: [key, key])
        let query = PFQuery(className: Interest.parseClassName(), predicate: pred)
        query.orderByDescending("updatedAt")
        query.cachePolicy = PFCachePolicy.NetworkElseCache
        
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                if let objects = objects as? [PFObject] {
                    self.interests.removeAll()
                    for interestObject in objects {
                        let interest = interestObject as! Interest
                        self.interests.append(interest)
                    }
                    self.tableView.reloadData()
                }
            } else {
                print("\(error?.localizedDescription)")
            }
        }
    }
    
    func suggestInterests()
    {
        let query = PFQuery(className: Interest.parseClassName())
        query.orderByDescending("updatedAt")
        query.limit = 20
        query.cachePolicy = PFCachePolicy.NetworkElseCache
        
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                if let objects = objects as? [PFObject] {
                    self.interests.removeAll()
                    for interestObject in objects {
                        let interest = interestObject as! Interest
                        self.interests.append(interest)
                    }
                    self.tableView.reloadData()
                }
            } else {
                print("\(error?.localizedDescription)")
            }
        }
    }
    
    @IBAction func dismiss(sender: UIButton)
    {
        if searchBar.isFirstResponder() {
            searchBar.resignFirstResponder()
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func refreshButtonClicked(sender: UIButton)
    {
        //
    }
    
    @IBAction func hideKeyboardButtonClicked(sender: UIButton)
    {
        searchBar.resignFirstResponder()
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Show Discover Interest" {
            let navVC = segue.destinationViewController as! UINavigationController
            let interestVC = navVC.topViewController as! InterestViewController
            interestVC.interest = sender as! Interest
            navVC.transitioningDelegate = popTransitionAnimator
        }
    }

}

extension DiscoverViewController : UISearchBarDelegate
{
    func searchBarSearchButtonClicked(searchBar: UISearchBar)
    {
        if searchBar.text! != "" {
            searchText = searchBar.text!.lowercaseString
        }
        
        searchBar.resignFirstResponder()
    }
}

extension DiscoverViewController: UITableViewDataSource
{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interests.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("Interest Cell", forIndexPath: indexPath) as! DiscoverTableViewCell
        
        cell.interest = interests[indexPath.row]
        cell.delegate = self
        cell.contentView.backgroundColor = UIColor.clearColor()
        
        return cell
    }
}

extension DiscoverViewController : DiscoverTableViewCellDelegate
{
    func joinButtonClicked(interest: Interest!)
    {
        performSegueWithIdentifier("Show Discover Interest", sender: interest)
    }
}


























