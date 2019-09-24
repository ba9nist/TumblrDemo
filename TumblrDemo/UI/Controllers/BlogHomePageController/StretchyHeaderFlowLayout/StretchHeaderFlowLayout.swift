//
//  StretchHeaderFlowLayout.swift
//  TumblrDemo
//
//  Created by ba9nist on 24.09.2019.
//  Copyright © 2019 Home. All rights reserved.
//

import UIKit

class StretchHeaderFlowLayout: UICollectionViewFlowLayout {
    var headerMinHeight = CGFloat(100)

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let layoutAttributes = super.layoutAttributesForElements(in: rect) else { return nil }

        guard let collectionView = collectionView else { return layoutAttributes}

        var newAttributes = [UICollectionViewLayoutAttributes]()

        for attribute in layoutAttributes {

            if attribute.representedElementCategory == .cell {
                newAttributes.append(attribute)
            }
        }

        if let headerAttributes = self.layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: 0)) {

            var frame = headerAttributes.frame
            let yOffset = collectionView.contentOffset.y

            let calcHeight = headerAttributes.frame.height - yOffset
            let headerHeight = max(headerMinHeight, calcHeight)

            frame = CGRect(x: 0, y: 0, width: frame.width, height: headerHeight)
            frame.origin.y = yOffset

            headerAttributes.frame = frame

            newAttributes.append(headerAttributes)
        }
        return newAttributes
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

}
