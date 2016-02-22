
//
//  ChatHeaderView.swift
//  interests
//
//  Created by 株式会社ConU on 2016/02/16.
//  Copyright © 2016年 Developer Inspirus. All rights reserved.
//

import UIKit

protocol ChatHeaderViewDelegate {
    func closeButtonClicked()
}

class ChatHeaderView: UIView
{
    // MARK: - Public API
    var interest: Interest! {
        didSet {
            updateUI()
        }
    }
    
    var delegate: ChatHeaderViewDelegate!
    
    private func updateUI()
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

            pullDownToCloseLabel.text! = "Pull down to close"
            
            pullDownToCloseLabel.hidden = true
            
        }
        
       
    }
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var interestTitleLabel: UILabel!
    @IBOutlet weak var pullDownToCloseLabel: UILabel!
    @IBOutlet weak var closeButtonBackgroundView: UIView!
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        closeButtonBackgroundView.layer.cornerRadius = closeButtonBackgroundView.bounds.width / 2
        closeButtonBackgroundView.layer.masksToBounds = true
    }
    
    @IBAction func closeButtonTapped(sender: UIButton)
    {
        // delegate right now is InterestViewController
        delegate.closeButtonClicked()
    }
}






