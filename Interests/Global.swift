//
//  Global.swift
//  Interests
//
//  Created by Duc Tran on 6/19/15.
//  Copyright © 2015 Developer Inspirus. All rights reserved.
//

import UIKit
import Parse

private struct ImageSize {
    static let height: CGFloat = 480.0
}

public func createFileFrom(image: UIImage) -> PFFile!
{
    let ratio = image.size.width / image.size.height
    let resizedImage = resizeImage(image, toWidth: ImageSize.height * ratio, andHeight: ImageSize.height)
    let imageData = UIImageJPEGRepresentation(resizedImage, 0.8)!
    return PFFile(name: "image.jpg", data: imageData)
}

private func resizeImage(originalImage: UIImage, toWidth width: CGFloat, andHeight height: CGFloat) -> UIImage
{
    let newSize = CGSizeMake(width, height)
    let newRectangle = CGRectMake(0, 0, width, height)
    UIGraphicsBeginImageContext(newSize)
    originalImage.drawInRect(newRectangle)
    
    let resizedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return resizedImage
}
