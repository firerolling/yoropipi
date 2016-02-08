//
//  InterestButton.swift
//  Interests
//
//  Created by Duc Tran on 6/16/15.
//  Copyright © 2015 Developer Inspirus. All rights reserved.
//

import UIKit

class InterestButton: UIButton
{
    // MARK: - Public API
    
    var color = UIColor.lightGrayColor() {
        didSet {
            borderColor = self.color.CGColor
            self.layer.borderColor = self.borderColor
            buttonTintColor = self.color
            self.tintColor = buttonTintColor
        }
    }
    
    // MARK: - Private
    
    private var borderWidth: CGFloat = 2.0
    private var cornerRadius: CGFloat = 3.0
    private var buttonTintColor: UIColor = UIColor.lightGrayColor()
    private var borderColor: CGColor = UIColor.lightGrayColor().CGColor
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        borderColor = self.color.CGColor
        buttonTintColor = self.color
        
        layer.borderColor = self.borderColor
        layer.borderWidth = self.borderWidth
        layer.cornerRadius = self.cornerRadius
        layer.masksToBounds = true
        self.tintColor = buttonTintColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}





























