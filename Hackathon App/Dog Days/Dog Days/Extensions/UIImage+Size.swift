//
//  UIImage+Size.swift
//  Dog Days
//
//  Created by Connie Guan on 7/19/17.
//  Copyright © 2017 Connie Guan. All rights reserved.
//

import UIKit

extension UIImage {
    var aspectHeight: CGFloat {
        let heightRatio = size.height / 736
        let widthRatio = size.width / 414
        let aspectRatio = fmax(heightRatio, widthRatio)
        
        return size.height / aspectRatio
    }
}
