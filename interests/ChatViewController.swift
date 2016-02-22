//
//  ChatViewController.swift
//  interests
//
//  Created by 株式会社ConU on 2016/02/16.
//  Copyright © 2016年 Developer Inspirus. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController, UITextFieldDelegate  {
    
    
    // MARK: - Public API
    var interest: Interest!
    
    
    
    
    
    
    // MARK: - Private
    @IBOutlet weak var tableView: UITableView!
    private let tableHeaderHeight: CGFloat = 150.0
    private let tableHeaderCutAway: CGFloat = 0.0
    
    private var headerView: ChatHeaderView!
    private var headerMaskLayer: CAShapeLayer!
    
    private var max:Int = 0
    
    // Datasource
    private var chats = [Chat]()
    
    
    
    // MARK: - View Controller Life Cycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "handleKeyboardWillShowNotification:", name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: "handleKeyboardWillHideNotification:", name: UIKeyboardWillHideNotification, object: nil)
        
        
        
        fetchChats()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("aninin")
        
        chatField.delegate = self
        
        
        var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        interest = appDelegate.interest
        
        //        tableView.estimatedRowHeight = 387.0
        //        tableView.rowHeight = UITableViewAutomaticDimension
        
        headerView = tableView.tableHeaderView as! ChatHeaderView
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
        
      
        
        
        let nib:UINib = UINib(nibName: "ChatCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "ChatCell")
        
        
        fetchChats()
        
        
        
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
    
    func fetchChats()
    {
        let interestId = interest.objectId!
        let query = PFQuery(className: Chat.parseClassName())
        
        query.cachePolicy = PFCachePolicy.NetworkElseCache
        query.whereKey("interestId", equalTo: interestId)
        query.orderByDescending("numberOfLikes")
        query.includeKey("user")
        
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                self.chats.removeAll()
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        let chat = object as! Chat
                        self.chats.append(chat)
                    }
                    self.tableView?.reloadData()
                }
            } else {
                print("\(error?.localizedDescription)")
            }
        }
        
    }
    
    
    
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        chatField.resignFirstResponder()
        return true
    }

    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Show Comments" {
            let commentsVC = segue.destinationViewController as! CommentsViewController
            commentsVC.post = sender as! Post
        } else if segue.identifier == "Show Chat Composer" {
            let chatComposer = segue.destinationViewController as! NewChatViewController
            chatComposer.interest = interest
            
        }
        
    }
    @IBOutlet weak var chatField: UITextField!
    @IBOutlet weak var chatButton: UIButton!
    
    
    var activeTextField: UITextField! //編集後のtextfield
    
    
    
    
    @IBAction func sendChat(sender: AnyObject) {
        uploadNewChat()
        fetchChats()
        self.view.frame.origin.y = 0
        chatField.text = nil
        self.view.endEditing(true)
    }
    
    func uploadNewChat() {
        let new = chatField.text
        let newChat = Chat(user: PFUser.currentUser()!, chatText: new!, numberOfLikes: 0, interestId: interest.objectId!)
        newChat.saveInBackgroundWithBlock { (success, error) -> Void in
            if error == nil {
                self.interest.incrementNumberOfChats()
            } else {
                print("\(error?.localizedDescription)")
            }
        }
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        activeTextField = textField
        return true
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        // NSNotificationCenterの解除処理
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func handleKeyboardWillShowNotification(notification: NSNotification) {
        //郵便入れみたいなもの
        var userInfo = notification.userInfo!
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let boundSize: CGSize = UIScreen.mainScreen().bounds.size
        var textFieldLimit = activeTextField.frame.origin.y + activeTextField.frame.height + 22.0
        var keyboardLimit = boundSize.height - keyboardScreenEndFrame.size.height
        
        if textFieldLimit >= keyboardLimit {
            self.view.frame.origin.y = keyboardLimit - textFieldLimit
        }
    }
    
    func handleKeyboardWillHideNotification(notification: NSNotification) {
       self.view.frame.origin.y = 0
    }
    
    
}

extension ChatViewController : UITableViewDataSource
{
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return chats.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let chat = chats[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ChatCell", forIndexPath: indexPath) as! ChatCell
        cell.chat = chat
        cell.delegate = self
        let currentUser = "\(chat.user.objectId)"
        print(currentUser)
        let createdUser = "\(interest.createdUser)"
        print(createdUser)
        if currentUser == createdUser {
            cell.myPost()
        }
        
        
        ////モデルに飛ばす
        return cell
    }
}


extension ChatViewController : UITableViewDelegate
{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
    }
    
    
    
}

extension ChatViewController : UIScrollViewDelegate
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

extension ChatViewController : ChatHeaderViewDelegate
{
    func closeButtonClicked() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension ChatViewController : ChatCellDelegate
{
    func commentButtonClicked(chat: Chat)
    {
        self.performSegueWithIdentifier("Show Comments", sender: chat)
    }
}
