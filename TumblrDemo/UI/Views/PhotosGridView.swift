//
//  PhotosGridView.swift
//  TumblrDemo
//
//  Created by ba9nist on 22.09.2019.
//  Copyright © 2019 Home. All rights reserved.
//

import UIKit

class PhotosGridView: UIView {
    private let reuseIdentifier = "PhotosGridViewCell"
    open var pattern: String = "" {
        didSet {
            patternArray = [Int]()
            mapPatternIntoArray()
        }
    }
    
    open var images = [Photo]() {
        didSet {
            collectionView.reloadData()
        }
    }

    private var patternArray = [Int]()
    private var spacing = CGFloat(4)

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.allowsSelection = false
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.contentInset = .zero
        collectionView.isUserInteractionEnabled = false

        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        return collectionView
    }()

    open func calculateHeight(by width: CGFloat) -> CGFloat {
        var height = CGFloat(0)
        var imageIndex = 0
        for index in 0..<patternArray.count {
            let size = calculateSizeOfImage(at: IndexPath(item: imageIndex, section: 0), for: width)
            imageIndex += patternArray[index]
            height += size.height
        }
        return height
    }

    open func reset() {
        pattern = ""
        images = [Photo]()

        collectionView.reloadData()
    }

    private func mapPatternIntoArray() {
        let start = pattern.startIndex
        for i in 0..<pattern.count {
            let index = pattern.index(start, offsetBy: i)
            let char = String(pattern[index])
            if let intValue = Int(char) {
                patternArray.append(intValue)
            }
        }
    }

    fileprivate func calculateSizeOfImage(at indexPath: IndexPath, for width: CGFloat) -> CGSize {
        var index = indexPath.item

        let photo = images[indexPath.item]

        for item in patternArray {
            index -= item
            if index < 0 {
                let calculatedWidth = (width - (CGFloat(item) - 1.0)*spacing) / CGFloat(item)
                let height = (calculatedWidth / CGFloat(photo.original_size.width)) * CGFloat(photo.original_size.height)

                return CGSize(width: calculatedWidth, height: height)
            }
        }

        return .zero
    }

    private func setupView() {
        addSubview(collectionView)
        collectionView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension PhotosGridView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return calculateSizeOfImage(at: indexPath, for: collectionView.frame.width)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
}

extension PhotosGridView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ImageCollectionViewCell

        let item = images[indexPath.item]
        cell.configure(data: item.original_size.url)

        return cell
    }


}
