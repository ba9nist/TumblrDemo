//
//  ConfigurableCell.swift
//  TumblrDemo
//
//  Created by yevhenii boryspolets on 9/20/19.
//  Copyright © 2019 Home. All rights reserved.
//

import UIKit

protocol ConfigurableCell {
    associatedtype T
    
    func configure(data: T)
    func calculateHeight(for width: CGFloat) -> CGFloat
}

protocol CellConfigurator {
    static var reuseIdentifier: String { get }
    
    func configure(cell: UIView)
    func calculateHeight(width: CGFloat) -> CGFloat
}

class CollectionViewConfigurator<CellType: ConfigurableCell, U> : CellConfigurator where CellType.T == U, CellType: UICollectionViewCell {
    static var reuseIdentifier: String { return String(describing: CellType.self) }
    
    let item: U
    let cell = CellType()

    init(item: U) {
        self.item = item
        cell.configure(data: item)
    }
    
    func configure(cell: UIView) {
        (cell as! CellType).configure(data: item)
    }

    func calculateHeight(width: CGFloat) -> CGFloat {
        return cell.calculateHeight(for: width)
    }

}
