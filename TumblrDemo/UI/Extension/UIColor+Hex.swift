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

    //processing string with format "#FFFFFF"
    convenience init?(htmlStyle: String?) {
        guard let string = htmlStyle else { return nil }

        var rawColor = string
        rawColor.remove(at: rawColor.startIndex)

        guard let colorInt = Int(rawColor, radix: 16) else {
            return nil
        }

        self.init(hexRgb: colorInt)
    }
}
