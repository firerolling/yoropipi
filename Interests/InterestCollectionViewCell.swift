//
//  InterestCollectionViewCell.swift
//  Interests
//
//  Created by Duc Tran on 6/13/15.
//  Copyright © 2015 Developer Inspirus. All rights reserved.
//

import UIKit

class InterestCollectionViewCell: UICollectionViewCell
{
    // MARK: - Public API
    var interest: Interest! {
        didSet {
            updateUI()
        }
    }
    
    // MARK: - Private
    
    @IBOutlet weak var featuredImageView: UIImageView!
    @IBOutlet weak var interestTitleLabel: UILabel!
    
    private func updateUI()
    {
        interestTitleLabel?.text! = interest.title
        
        interest.featuredImageFile.getDataInBackgroundWithBlock { (imageData, error) -> Void in
            if error == nil {
                if let featuredImageData = imageData {
                    self.featuredImageView.image = UIImage(data: featuredImageData)!
                }
            } else {
                print("\(error?.localizedDescription)")
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 10.0
        self.clipsToBounds = true
    }
}





















