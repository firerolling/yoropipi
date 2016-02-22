//
//  PlaceViewController.swift
//  interests
//
//  Created by 株式会社ConU on 2016/02/15.
//  Copyright © 2016年 Developer Inspirus. All rights reserved.
//

import UIKit
import Parse

class PlaceViewController: UIViewController {

    
    // MARK: - Public API
    var interest: Interest!
    
    var pressed = 0
    
    
    
    
    // MARK: - Private
    @IBOutlet weak var tableView: UITableView!
    private let tableHeaderHeight: CGFloat = 300.0
    private let tableHeaderCutAway: CGFloat = 0.0
    
    private var headerView: PlaceHeaderView!
    private var headerMaskLayer: CAShapeLayer!
    
    private var max:Int = 0
    
    // Datasource
    private var places = [Place]()
    
    private var newPostButton: ActionButton!
    
    // MARK: - View Controller Life Cycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        
        
        
        fetchPlaces()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("aninin")
        
        
        var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        interest = appDelegate.interest
        
        //        tableView.estimatedRowHeight = 387.0
        //        tableView.rowHeight = UITableViewAutomaticDimension
        
        headerView = tableView.tableHeaderView as! PlaceHeaderView
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
        
        let nib:UINib = UINib(nibName: "PlaceCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "PlaceCell")
        
        
        fetchPlaces()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didTapButton:", name: "PLACEBUTTON", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "selectPlace:", name: "SELECTPLACE", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "placeDeselect:", name: "placedeselect", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "placeRedeside:", name: "PLACEREDESIDE", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "placeRedesidetapped:", name: "placeredesidetapped", object: nil)

        
        
        
    }
    
    func placeRedeside(sender: UIButton){
        fetchPlaces()
        self.tableView.reloadData()
        
    }
    
    func placeRedesidetapped(sender: UIButton) {
        interest.placeIsDesided = false
        interest.saveInBackground()
        
        self.tableView.reloadData()
    }
    
    func placeDeselect(sender: UIButton){
        self.tableView.reloadData()
    }
    
    func selectPlace(notification: NSNotification?){
        
        self.tableView.reloadData()
        if let userInfo = notification?.userInfo {
            let selectPlace = userInfo["selectplace"]! as! String
            print(selectPlace)
            interest.selectedPlace = selectPlace
            interest.placeIsDesided = true
            interest.saveInBackground()
        }
        print("あい")
        
        updateHeaderView()
        self.tableView.reloadData()
        
    }
    
    func didTapButton(sender:UIButton!) {
        print("受け取りました")
        tableView.reloadData()
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
        headerView.updateUI()
        
        // cut away
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: 0, y: 0))
        path.addLineToPoint(CGPoint(x: headerRect.width, y: 0))
        path.addLineToPoint(CGPoint(x: headerRect.width, y: headerRect.height))
        path.addLineToPoint(CGPoint(x: 0, y: headerRect.height - tableHeaderCutAway))
        headerMaskLayer?.path = path.CGPath
        
    }
    
    func fetchPlaces()
    {
        let interestId = interest.objectId!
        let query = PFQuery(className: Place.parseClassName())
        
        query.cachePolicy = PFCachePolicy.NetworkElseCache
        query.whereKey("interestId", equalTo: interestId)
        query.orderByDescending("numberOfLikes")
        query.includeKey("user")
        
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                self.places.removeAll()
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        let place = object as! Place
                        self.places.append(place)
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
            self.performSegueWithIdentifier("Show Place Composer", sender: nil)
        }
        // set the button's backgroundColor
    }
    @IBAction func Arrange(sender: AnyObject) {
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Show Comments" {
            let commentsVC = segue.destinationViewController as! CommentsViewController
            commentsVC.post = sender as! Post
        } else if segue.identifier == "Show Place Composer" {
            let placeComposer = segue.destinationViewController as! NewPlaceViewController
            placeComposer.interest = interest
            
        } else if segue.identifier == "toDetail" {
            let detailView = segue.destinationViewController as! PlaceDetailViewController
            print(pressed)
            print(places[pressed].placeText)
            detailView.titleLabel2.text = places[pressed].placeText
            detailView.url = places[pressed].placeUrl
            
        }
        
    }
}

extension PlaceViewController : UITableViewDataSource
{
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return places.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
    
        let place = places[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("PlaceCell", forIndexPath: indexPath) as! PlaceCell
        cell.place = place
        cell.delegate = self
        
        
        if interest.placeIsDesided == false {
        if indexPath.row == 0 {
            max = cell.place.numberOfLikes
            cell.mostLiked()
            
        } else if cell.place.numberOfLikes == max {
            cell.mostLiked()
        }
    } else {
            cell.selectedView()
        }
        
        return cell
    }
}



extension PlaceViewController : UITableViewDelegate
{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        
        
        
        performSegueWithIdentifier("toDetail", sender: self)
        self.pressed = indexPath.row
    
        
        self.tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
    }
    
    
    
    
}

extension PlaceViewController : UIScrollViewDelegate
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

extension PlaceViewController : PlaceHeaderViewDelegate
{
    func closeButtonClicked() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension PlaceViewController : PlaceCellDelegate
{
    func commentButtonClicked(place: Place)
    {
        self.performSegueWithIdentifier("Show Comments", sender: place)
    }
}

