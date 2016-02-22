//
//  PlaceHeaderView.swift
//  interests
//
//  Created by 株式会社ConU on 2016/02/15.
//  Copyright © 2016年 Developer Inspirus. All rights reserved.
//


import UIKit
import Parse

protocol PlaceHeaderViewDelegate {
    func closeButtonClicked()
}

class PlaceHeaderView: UIView
{
    // MARK: - Public API
    var interest: Interest! {
        didSet {
            updateUI()
        }
    }
    
    var delegate: PlaceHeaderViewDelegate!
    
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
        if interest.placeIsDesided == false {
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
    
    
    let decisionButton = UIButton()
    let decisionIcon = UIImage(named: "decision")
    
    let redecisionButton = UIButton()
    
    let decidedPlaceLabel = UILabel()
    
    let selectPlaceLabel = UILabel()
    let selectPlaceView = UIView()
    
    let voteClosedLabel = UILabel()
    
    
    let openButton = UIButton()
    let openIcon = UIImage(named: "search")
    
    
    func addDecision() {
        self.addSubview(decisionButton)
    }
    
    func addSelectedDate() {
        decisionButton.removeFromSuperview()
        self.addSubview(selectPlaceView)
        
    }

    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        closeButtonBackgroundView.layer.cornerRadius = closeButtonBackgroundView.bounds.width / 2
        closeButtonBackgroundView.layer.masksToBounds = true
        
        
        decisionButton.setImage(decisionIcon, forState: .Normal)
        decisionButton.frame = CGRect(x: self.backgroundImageView.frame.width/2 - 30, y: 100, width: 60, height: 76)
        decisionButton.addTarget(self, action: "decisionMaking:", forControlEvents: .TouchUpInside)
        
        
        redecisionButton.setImage(decisionIcon, forState: .Normal)
        redecisionButton.frame = CGRect(x: 10, y: 0, width: 60, height: 76)
        
        let currentUser = "\(PFUser.currentUser()?.objectId)"
        print(currentUser)
        let createdUser = "\(interest.createdUser)"
        print(createdUser)
        if currentUser == createdUser {
            redecisionButton.addTarget(self, action: "decisionRemaking:", forControlEvents: .TouchUpInside)
    }
        
        selectPlaceView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        selectPlaceView.frame = CGRect(x: 0, y: 100, width: self.backgroundImageView.frame.width, height: 76)
        
        selectPlaceLabel.text = interest.selectedPlace
        selectPlaceLabel.font = UIFont(name: "Avenir", size: 18)
        selectPlaceLabel.frame = CGRect(x: 70, y: 0, width: self.backgroundImageView.frame.width-70-76, height: 76)
        selectPlaceLabel.textColor = UIColor.whiteColor()
        selectPlaceLabel.textAlignment = .Right
        
        
        
        openButton.backgroundColor = UIColor(hex: "#EF4836")
        openButton.frame = CGRect(x:  self.backgroundImageView.frame.width-76, y:0, width: 76, height: 76)
        openButton.setImage(openIcon, forState: .Normal)
        self.selectPlaceView.addSubview(openButton)
        self.selectPlaceView.addSubview(redecisionButton)
        self.selectPlaceView.addSubview(voteClosedLabel)
        self.selectPlaceView.bringSubviewToFront(openButton)
        self.selectPlaceView.addSubview(selectPlaceLabel)
        
        voteClosedLabel.textColor = UIColor.whiteColor()
        voteClosedLabel.backgroundColor = UIColor(hex: "#F89406")
        voteClosedLabel.frame = CGRect(x: 70, y: -15, width: self.backgroundImageView.frame.width/3, height: 30)
        voteClosedLabel.text = "VOTE CLOSED!!"
        voteClosedLabel.textAlignment = .Center
        voteClosedLabel.font = UIFont(name: "Avenir", size: 17)
        self.bringSubviewToFront(voteClosedLabel)

    }
    
    func decisionRemaking(sender: UIButton){
        interest.placeIsDesided = false
        interest.saveInBackground()
       
        self.selectPlaceView.removeFromSuperview()
        
        
        NSNotificationCenter.defaultCenter().postNotificationName("PlACEREDESIDE", object: nil)
        NSNotificationCenter.defaultCenter().postNotificationName("PLACEDESIDE2", object: nil)
        
    }
    
    
    func decisionMaking(sender: UIButton){
        
        NSNotificationCenter.defaultCenter().postNotificationName("PLACEBUTTON", object: nil)
        NSNotificationCenter.defaultCenter().postNotificationName("PLACEBUTTON2", object: nil)
        
        
    }

    
    @IBAction func closeButtonTapped(sender: UIButton)
    {
        // delegate right now is InterestViewController
        delegate.closeButtonClicked()
    }
}







