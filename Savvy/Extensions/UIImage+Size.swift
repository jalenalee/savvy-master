//
//  UIImage+Size.swift
//  Savvy
//
//  Created by Elmer Astudillo on 8/11/17.
//  Copyright © 2017 Elmer Astudillo. All rights reserved.
//

import Foundation
import UIKit


//This solution overlooks a lot of complexity for the sake of being easy to implement. What would happen if we ran the app on an iPad?

extension UIImage
{
    
    // Added a compueted property to UIImage that will calculate the aspect height for the instance o a UIImage based on the size property of an image
    var aspectHeight : CGFloat
    {
        let heightRatio = size.height / 736
        let widthRatio = size.width / 414
        let aspectRatio = fmax(heightRatio, widthRatio)

        return size.height / aspectRatio
    }
    
}

extension UIImageView
{
    func setRounded(image:UIImageView) {
        image.layer.borderWidth = 1
        image.layer.masksToBounds = false
        //image.layer.borderColor = UIColor.black as CGColor
        image.layer.cornerRadius = image.frame.height/2
        image.clipsToBounds = true
    }
}
