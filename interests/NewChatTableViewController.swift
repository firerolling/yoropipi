//
//  NewChatTableViewController.swift
//  interests
//
//  Created by 株式会社ConU on 2016/02/16.
//  Copyright © 2016年 Developer Inspirus. All rights reserved.
//

import UIKit
import Parse


class NewChatViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var chatField: UITextField!
    
    var interest: Interest!
    // MARK: - Properties
    
    
    
    
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatField.delegate = self
        
        
    }
    
    
    
    @IBAction func sendChat(sender: UIButton) {
        
        uploadNewChat()
        
        self.dismissViewControllerAnimated(true, completion: nil)
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
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        chatField.resignFirstResponder()
        return true
    }
    
}

