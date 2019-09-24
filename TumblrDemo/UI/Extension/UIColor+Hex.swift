//
//  UIColor+Hex.swift
//
//
//  Created by yevhenii boryspolets on 11/2/18.
//  Copyright © 2018. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(hexRgb: Int) {
        self.init(red: CGFloat(((hexRgb >> 16) & 0xFF))/255, green: CGFloat(((hexRgb >> 8) & 0xFF))/255, blue: CGFloat((hexRgb & 0xFF))/255, alpha: 1.0)
    }
}
