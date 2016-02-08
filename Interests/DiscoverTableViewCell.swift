//
//  DiscoverTableViewCell.swift
//  Interests
//
//  Created by Duc Tran on 6/16/15.
//  Copyright © 2015 Developer Inspirus. All rights reserved.
//

import UIKit

protocol DiscoverTableViewCellDelegate
{
    func joinButtonClicked(interest: Interest!)
}

class DiscoverTableViewCell: UITableViewCell
{
    // MARK: - Public API
    
    var interest: Interest! {
        didSet {
            updateUI()
        }
    }
    
    var delegate: DiscoverTableViewCellDelegate!
    
    @IBOutlet weak var backgroundViewWithShadow: CardView!
    @IBOutlet weak var interestTitleLabel: UILabel!
    @IBOutlet weak var joinButton: InterestButton!
    @IBOutlet weak var interestFeaturedImage: UIImageView!
    @IBOutlet weak var interestDescriptionLabel: UILabel!
    
    func updateUI()
    {
        interest.featuredImageFile.getDataInBackgroundWithBlock { (data, error) -> Void in
            if error == nil {
                if let imageData = data {
                    self.interestFeaturedImage.image! = UIImage(data: imageData)!
                }
            }
        }
        
        interestTitleLabel.text! = interest.title
        interestDescriptionLabel.text! = interest.interestDescription
        
        // join button
        let currentUser = User.currentUser()!
        if currentUser.isMemberOf(interest.objectId!) {
            joinButton.setTitle("→", forState: .Normal)
        } else {
            joinButton.setTitle("Join", forState: .Normal)
        }
        
        // change the color
        let randomColor = UIColor.randomColor()
        joinButton.color = randomColor
        interestTitleLabel.textColor = randomColor
        
    }
    
    @IBAction func joinButtonClicked(sender: InterestButton)
    {
        let currentUser = User.currentUser()!
        if !currentUser.isMemberOf(interest.objectId!) {
            // let user to to join the interest
            currentUser.joinInterest(interest.objectId!)
            interest.incrementNumberOfMembers()
            joinButton.setTitle("→", forState: .Normal)
        } else {
            delegate?.joinButtonClicked(interest)
        }
    }
}




































