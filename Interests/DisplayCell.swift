//
//  CellTableViewCell.swift
//  practice
//
//  Created by 株式会社ConU on 2016/01/26.
//  Copyright © 2016年 株式会社ConU. All rights reserved.
//

import UIKit
import Parse

protocol DisplayCellDelegate
{
    func commentButtonClicked(post: Post)
}

class DisplayCell: UITableViewCell {
    
    
    var post: Post! {
        didSet {
            updateUI()
        }
    }
    
    var delegate: DisplayCellDelegate!

 
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var mask: UIView!
    
    let likeLabel = UILabel()
 
    
    let button = DOFavoriteButton(frame: CGRectMake(0, 0, 70, 70), image: UIImage(named: "like"))
    
    //オーナー専用ボタン
    let selectButton = UIButton()
    let selectIcon = UIImage(named: "decision")
    
    
    let selectedIcon = UIImageView()
    
    private func updateUI() {
        dateLabel.text = post.postText
        likeLabel.text = "\(post.numberOfLikes)"
        
        
//        let user:String = "\(PFUser.currentUser()?.objectId)"
//        print(user)
        
        let user = PFUser.currentUser()
        let currentUserId = user?.objectId
        let array:[String] = post.likedUserIds
        print(array)
        let index = array.indexOf(currentUserId!)
        print(index)
        
        if (index != nil) {
            button.select()
        } else {
            print("おされてない")
            button.deselect()
        }
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didTapButton:", name: "BUTTON2", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "redeside:", name: "REDESIDE2", object: nil)
        
        
    }
    
    func didTapButton(sender: UIButton!) {
        
        self.button.removeFromSuperview()
        self.addSubview(selectButton)
        self.bringSubviewToFront(selectButton)
        post.saveInBackground()
        NSNotificationCenter.defaultCenter().postNotificationName("deselect", object: nil)
        
        
    }
    
    
    func redeside(sender: UIButton!){
        post.isSelected = false
        post.saveInBackground()
        NSNotificationCenter.defaultCenter().postNotificationName("redesidetapped", object: nil)
        mask.layer.borderColor = UIColor(hex: "#36D7B7").CGColor
        mask.layer.borderWidth = 2.0
        mask.layer.cornerRadius = 10.0
        mask.backgroundColor = UIColor.whiteColor()
        selectButton.alpha = 0.5
        dateLabel.textColor = UIColor(hex: "#36D7B7")
        date.tintColor = UIColor(hex: "#36D7B7")
        diamond.removeFromSuperview()
        self.selectedIcon.removeFromSuperview()
        self.addSubview(button)
        

    }
    
    func selectedView() {
        self.button.removeFromSuperview()
        self.selectButton.removeFromSuperview()
         if post.isSelected == true {
            self.addSubview(selectedIcon)
            mask.layer.borderColor = UIColor(hex: "#F89406").CGColor
            mask.backgroundColor = UIColor(hex: "#F89406")
            self.date.tintColor = UIColor.whiteColor()
            self.likeLabel.backgroundColor = UIColor.whiteColor()
            self.likeLabel.textColor = UIColor(hex: "#F89406")
            self.dateLabel.textColor = UIColor.whiteColor()
    }
    }
    
    
    func tapped(sender: DOFavoriteButton) {
        
        
        if currentUserLikes() {
            post.dislike()
            sender.deselect()
            
        }else{
            post.like()
            sender.select()
        }
        
        likeLabel.text = "\(post.numberOfLikes)"
    }
    
    let date = UIImageView(image: UIImage(named: "date")?.imageWithRenderingMode(.AlwaysTemplate))
    let diamond = UIImageView(image: UIImage(named: "diamond")?.imageWithRenderingMode(.AlwaysTemplate))
   
    func currentUserLikes() -> Bool {
        if let ids = post.likedUserIds {
            if ids.contains(User.currentUser()!.objectId!) {
                return true
            }
        }
        return false
    }
    
    func mostLiked() {
        mask.layer.borderColor = UIColor(hex: "#36D7B7").CGColor
        mask.backgroundColor = UIColor(hex: "#36D7B7")
        date.tintColor = UIColor.whiteColor()
        dateLabel.textColor = UIColor.whiteColor()
        self.addSubview(diamond)
        
    }
    
    
    

    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        mask.layer.borderColor = UIColor(hex: "#36D7B7").CGColor
        mask.layer.borderWidth = 2.0
        mask.layer.cornerRadius = 10.0
     
        date.tintColor = UIColor(hex: "#36D7B7")
        date.frame = CGRect(x: 15, y: 20, width: 60, height: 60)
        
        
        
        diamond.frame = CGRect(x: 55, y: 15, width: 20, height: 20)
        diamond.alpha = 0.8
        let angle:CGFloat = CGFloat((30.0 * M_PI) / 180.0)
        diamond.transform = CGAffineTransformMakeRotation(angle)
        
        diamond.tintColor = UIColor.whiteColor()
        

        
        button.addTarget(self, action: Selector("tapped:"), forControlEvents: .TouchUpInside)
        
        button.imageColorOff = UIColor(hex: "#bdc3c7")
        button.imageColorOn = UIColor(hex: "#F89406")
        button.duration = 2.0 // default: 1.0
        button.circleColor = UIColor(hex: "#F89406")
        button.lineColor = UIColor(hex: "#F89406")
        
        button.frame = CGRect(x: 330, y: 15, width: 50, height: 50)
        
        
        likeLabel.text = "0"
        likeLabel.backgroundColor = UIColor(hex: "#F89406")
        likeLabel.layer.cornerRadius = 12.5
        likeLabel.frame = CGRect(x: 15, y: 20, width: 25, height: 25)
        likeLabel.layer.masksToBounds = true
        likeLabel.textAlignment = .Center
        likeLabel.textColor = UIColor.whiteColor()
        
        
        selectButton.setImage(selectIcon, forState: .Normal)
        selectButton.frame = CGRect(x: 340, y: 15, width: 60*50/60, height: 76*50/60)
        selectButton.alpha = 0.5
        selectButton.transform = CGAffineTransformMakeRotation(angle)
        selectButton.addTarget(self, action: "selected:", forControlEvents: .TouchUpInside)
        
        selectedIcon.image = selectIcon
        selectedIcon.frame = CGRect(x: 340, y: 15, width: 60*50/60, height: 76*50/60)
        selectedIcon.transform = CGAffineTransformMakeRotation(angle)
        
        
        
        self.addSubview(date)
        self.addSubview(button)
        self.addSubview(likeLabel)
        
    }
    
    
    func selected(sender: UIButton){
        
        let alertView = SCLAlertView()
        alertView.addButton("SELECT"){ self.selectDate() }
            alertView.addButton("CENCEL"){
                self.cancelDate()
        
        }
        
        alertView.showCloseButton = false
        alertView.showSuccess("Select This Date?", subTitle: "")
        
    }
    
    func selectDate() {
        print("select")
        self.selectButton.alpha = 1.0
        self.mask.backgroundColor = UIColor(hex: "#F89406")
        self.mask.layer.borderColor = UIColor(hex: "#F89406").CGColor
        post.isSelected = true
        post.saveInBackground()
        NSNotificationCenter.defaultCenter().postNotificationName("SELECTDATE", object: nil, userInfo: ["selectdate":post.postText])

    }
    
    func cancelDate() {
        print("cancel")
    }
    
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
