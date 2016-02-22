//
//  InterestHeaderView.swift
//  Interests
//
//  Created by Duc Tran on 6/13/15.
//  Copyright © 2015 Developer Inspirus. All rights reserved.
//

import UIKit
import Parse

protocol InterestHeaderViewDelegate {
    func closeButtonClicked()
}

class InterestHeaderView: UIView
{
    // MARK: - Public API
    var interest: Interest! {
        didSet {
            updateUI()
        }
    }
    
    var delegate: InterestHeaderViewDelegate!
    
    public func updateUI()
    {
        
        if let interest = interest {
        interest.featuredImageFile.getDataInBackgroundWithBlock { (imageData, error) -> Void in
            if error == nil {
                if let data = imageData {
                    self.backgroundImageView.image! = UIImage(data: data)!
                }
            }
        }
        interestTitleLabel?.text! = interest.title
        numberOfMembersLabel.text! = "\(interest.numberOfMembers)"
        numberOfPostsLabel.text! = "\(interest.numberOfPosts)"
        numberOfPlacesLabel.text! = "\(interest.numberOfPlaces)"
        pullDownToCloseLabel.text! = "Pull down to close"
        
            pullDownToCloseLabel.hidden = true
        
        }
        
        let currentUser = "\(PFUser.currentUser()?.objectId)"
        print(currentUser)
        let createdUser = "\(interest.createdUser)"
        print(createdUser)
        if interest.isDesided == false {
            print("ああ")
            if currentUser == createdUser {
                self.addDecision()
            }
        } else {
            print("いい")
            self.addSelectedDate()
        }
    }

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var interestTitleLabel: UILabel!
    @IBOutlet weak var numberOfMembersLabel: UILabel!
    @IBOutlet weak var numberOfPostsLabel: UILabel!
    @IBOutlet weak var numberOfPlacesLabel: UILabel!
    @IBOutlet weak var pullDownToCloseLabel: UILabel!
    @IBOutlet weak var closeButtonBackgroundView: UIView!
    
    //decisionボタンの配置
    
    let decisionButton = UIButton()
    let decisionIcon = UIImage(named: "decision")
    
    let selectButton = UIButton()
    let selectIcon = UIImage(named: "decision")
    
    let selectDateLabel = UILabel()
    
    let voteClosedLabel = UILabel()
    let selectedIcon = UIImageView()
    
    
    
    
    func addDecision() {
        self.addSubview(decisionButton)
    }
    
    func addSelectedDate() {
        decisionButton.removeFromSuperview()
        self.addSubview(selectButton)
        self.addSubview(selectDateLabel)
        self.addSubview(voteClosedLabel)
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        closeButtonBackgroundView.layer.cornerRadius = closeButtonBackgroundView.bounds.width / 2
        closeButtonBackgroundView.layer.masksToBounds = true
        
        
        decisionButton.setImage(decisionIcon, forState: .Normal)
        decisionButton.frame = CGRect(x: self.backgroundImageView.frame.width/2 - 30, y: 100, width: 60, height: 76)
        decisionButton.addTarget(self, action: "decisionMaking:", forControlEvents: .TouchUpInside)
        
        
        selectButton.setImage(selectIcon, forState: .Normal)
        selectButton.frame = CGRect(x: 10, y: 100, width: 60, height: 76)
        
        let currentUser = "\(PFUser.currentUser()?.objectId)"
        print(currentUser)
        let createdUser = "\(interest.createdUser)"
        print(createdUser)
        if currentUser == createdUser {
            selectButton.addTarget(self, action: "decisionRemaking:", forControlEvents: .TouchUpInside)
        }
        
        
        
        selectDateLabel.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        selectDateLabel.text = interest.selectedDate
        selectDateLabel.font = UIFont(name: "Avenir", size: 25)
        selectDateLabel.frame = CGRect(x: 0, y: 100, width: self.backgroundImageView.frame.width, height: 76)
        selectDateLabel.textColor = UIColor.whiteColor()
        selectDateLabel.textAlignment = .Right
        self.bringSubviewToFront(selectButton)
        
        voteClosedLabel.textColor = UIColor.whiteColor()
        voteClosedLabel.backgroundColor = UIColor(hex: "#F89406")
        voteClosedLabel.frame = CGRect(x: selectButton.frame.origin.x + selectButton.frame.width , y: selectButton.frame.origin.y - 10, width: self.backgroundImageView.frame.width/3, height: 30)
        voteClosedLabel.text = "VOTE CLOSED!!"
        voteClosedLabel.textAlignment = .Center
        voteClosedLabel.font = UIFont(name: "Avenir", size: 17)
        
        
        
    }
    

    func decisionRemaking(sender: UIButton){
        interest.isDesided = false
        interest.saveInBackground()
        self.selectButton.removeFromSuperview()
        self.selectDateLabel.removeFromSuperview()
        self.voteClosedLabel.removeFromSuperview()
        
        
        NSNotificationCenter.defaultCenter().postNotificationName("REDESIDE", object: nil)
        NSNotificationCenter.defaultCenter().postNotificationName("REDESIDE2", object: nil)

    }
    
    
    func decisionMaking(sender: UIButton){
      
        NSNotificationCenter.defaultCenter().postNotificationName("BUTTON", object: nil)
        NSNotificationCenter.defaultCenter().postNotificationName("BUTTON2", object: nil)

       
    }
    
    @IBAction func closeButtonTapped(sender: UIButton)
    {
        // delegate right now is InterestViewController
        delegate.closeButtonClicked()
    }
}

























