//
//  ChatCell.swift
//  interests
//
//  Created by 株式会社ConU on 2016/02/16.
//  Copyright © 2016年 Developer Inspirus. All rights reserved.
//

import UIKit
import Parse

protocol ChatCellDelegate
{
    func commentButtonClicked(chat: Chat)
}

class ChatCell: UITableViewCell {
    
    
    var chat: Chat! {
        didSet {
            updateUI()
        }
    }
    
    var delegate: ChatCellDelegate!
    
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var chatLabel: UILabel!
    
    @IBOutlet weak var mask: UIView!
    
    let chatLikeLabel = UILabel()
    
    
    let button = DOFavoriteButton(frame: CGRectMake(0, 0, 40, 40), image: UIImage(named: "heart"))
    
    
    
    
    private func updateUI() {
        chatLabel.text = chat.chatText
        
        userLabel.text = chat.user.username
        
        let timeString = stringFromDate(chat.createdAt!, format:"yyyy-MM-dd 'at' HH:mm" )
        time.text = timeString
        
        chatLikeLabel.text = "\(chat.numberOfLikes)"
        
        
        //        let user:String = "\(PFUser.currentUser()?.objectId)"
        //        print(user)
        
        let user = PFUser.currentUser()
        let currentUserId = user?.objectId
        let array:[String] = chat.likedUserIds
        print(array)
        let index = array.indexOf(currentUserId!)
        print(index)
        
        if (index != nil) {
            button.select()
        } else {
            print("おされてない")
            button.deselect()
        }
        
        
    }
    
    func myPost() {
        self.mask.layer.borderColor = UIColor(hex: "#F2F1EF").CGColor
        self.mask.layer.backgroundColor = UIColor(hex: "#F2F1EF").CGColor
        self.triangle.tintColor = UIColor(hex: "#F2F1EF")
        
    }
    
    
    func tapped(sender: DOFavoriteButton) {
        
        
        if currentUserLikes() {
            chat.dislike()
            sender.deselect()
            
        }else{
            chat.like()
            sender.select()
        }
        
//        chatLikeLabel.text = "\(chat.numberOfLikes)"
    }
    
    
    let triangle = UIImageView(image: UIImage(named: "triangle")?.imageWithRenderingMode(.AlwaysTemplate))
    
    
    func currentUserLikes() -> Bool {
        if let ids = chat.likedUserIds {
            if ids.contains(User.currentUser()!.objectId!) {
                return true
            }
        }
        return false
    }
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        
        chatLabel.textColor = UIColor.darkGrayColor()
        
        mask.layer.borderColor = UIColor(hex: "#36D7B7").CGColor
        mask.layer.borderWidth = 2.0
        mask.layer.cornerRadius = 10.0
        mask.layer.backgroundColor = UIColor(hex: "#36D7B7").CGColor

        triangle.tintColor = UIColor(hex: "#36D7B7")
        triangle.frame = CGRect(x: 40, y: 30, width: 30, height: 20)
        
        
        button.addTarget(self, action: Selector("tapped:"), forControlEvents: .TouchUpInside)
        
        button.imageColorOff = UIColor(hex: "#bdc3c7")
        button.imageColorOn = UIColor(hex: "#F64747")
        button.duration = 2.0 // default: 1.0
        button.circleColor = UIColor(hex: "#F64747")
        button.lineColor = UIColor(hex: "#F64747")
        
        button.frame = CGRect(x: 365, y: 45, width: 60, height: 60)
        
        
//        chatLikeLabel.text = "0"
//        chatLikeLabel.frame = CGRect(x: 375, y: 70, width: 20, height: 20)
//        chatLikeLabel.textColor = UIColor.whiteColor()
//        chatLikeLabel.font = UIFont(name: "Avenir", size: 12)
        
        self.sendSubviewToBack(triangle)
        
        self.addSubview(button)
        self.addSubview(chatLikeLabel)
        self.addSubview(triangle)
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
