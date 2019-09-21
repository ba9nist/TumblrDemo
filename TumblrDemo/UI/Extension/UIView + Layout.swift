//
//  UIView + Layout.swift
//  TumblrDemo
//
//  Created by ba9nist on 21.09.2019.
//  Copyright © 2019 Home. All rights reserved.
//

import UIKit

extension UIView {
    func anchor(top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, padding: UIEdgeInsets = .zero, size: CGSize = .zero) {

        translatesAutoresizingMaskIntoConstraints = false
        var constraints = [NSLayoutConstraint]()

        if let top = top {
            constraints.append(topAnchor.constraint(equalTo: top, constant: padding.top))
        }

        if let bottom = bottom {
            constraints.append(bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom))
        }

        if let right = right {
            constraints.append(rightAnchor.constraint(equalTo: right, constant: -padding.right))
        }

        if let left = left {
            constraints.append(leftAnchor.constraint(equalTo: left, constant: padding.left))
        }

        if size.height > 0 {
            constraints.append(heightAnchor.constraint(equalToConstant: size.height))
        }

        if size.width > 0 {
            constraints.append(widthAnchor.constraint(equalToConstant: size.width))
        }

        constraints.forEach({$0.isActive = true})
    }

    func center(to centerX: NSLayoutXAxisAnchor? = nil, centerY: NSLayoutYAxisAnchor? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        if let centerX = centerX {
            centerXAnchor.constraint(equalTo: centerX).isActive = true
        }

        if let centerY = centerY {
            centerYAnchor.constraint(equalTo: centerY).isActive = true
        }
    }
}
