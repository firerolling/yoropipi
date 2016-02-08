//
//  CardView.swift
//  Interests
//
//  Created by Duc Tran on 6/16/15.
//  Copyright © 2015 Developer Inspirus. All rights reserved.
//

import UIKit

class CardView: UIView {

    var cornerRadius: CGFloat = 3.0
    var shadowWidth: CGFloat = 0
    var shadowHeight: CGFloat = 1.0
    var shadowOpacity: Float = 0.2
    var shadowColor: UIColor = UIColor.blackColor()
    
    override func layoutSubviews() {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = false
        
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        layer.shadowColor = shadowColor.CGColor
        layer.shadowOffset = CGSize(width: shadowWidth, height: shadowHeight)
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.CGPath
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}




















