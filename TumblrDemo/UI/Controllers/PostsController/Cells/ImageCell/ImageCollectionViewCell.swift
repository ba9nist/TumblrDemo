//
//  ImageCollectionViewCell.swift
//  TumblrDemo
//
//  Created by ba9nist on 22.09.2019.
//  Copyright © 2019 Home. All rights reserved.
//

import UIKit
import FLAnimatedImage

class ImageCollectionViewCell: UICollectionViewCell, ConfigurableCell {

    private let imageView: FLAnimatedImageView = {
        let imageView = FLAnimatedImageView()
        imageView.contentMode = UIImageView.ContentMode.scaleAspectFit

        return imageView
    }()

    private var url: URL?
    func configure(data url: URL) {
        self.url = url

        NetworkManager.shared.loadImage(url: url) { (imageData) in
            guard let imageData = imageData else {
                return
            }

            if (self.url != url) {
                return
            }

            DispatchQueue.main.async {
                if url.pathExtension == "gif" {
                    self.imageView.animatedImage = FLAnimatedImage(gifData: imageData)
                } else {
                    self.imageView.image = UIImage(data: imageData)
                }
            }

        }

    }

    private func setupView() {
        addSubview(imageView)

        imageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
    }

    func calculateHeight(for width: CGFloat) -> CGFloat {
        guard let image = imageView.image else {
            return 0
        }
        let scale = width / image.size.width

        return image.size.height*scale
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
