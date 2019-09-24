//
//  StrechyHeaderView.swift
//  TumblrDemo
//
//  Created by ba9nist on 24.09.2019.
//  Copyright © 2019 Home. All rights reserved.
//

import UIKit
import FLAnimatedImage

class StrechyHeaderView: UICollectionReusableView {

    private var imageView: FLAnimatedImageView = {
        let imageView = FLAnimatedImageView()
        imageView.contentMode = UIImageView.ContentMode.scaleAspectFill
        return imageView
    }()

    open func configure(with theme: Theme?) {
        if let theme = theme {
            loadImage(from: theme.header_image)
        }
    }

    private  func loadImage(from url: URL?) {
        if let url = url {
            NetworkManager.shared.loadImage(url: url) { (imageData) in
                guard let imageData = imageData else { return }

                DispatchQueue.main.async {
                    let image = FLAnimatedImage(gifData: imageData)
                    if url.pathExtension == "gif" {
                        self.imageView.animatedImage = image
                    } else {
                        self.imageView.image = UIImage(data: imageData)
                    }
                }
            }
        }
    }

    private func setupView() {
        clipsToBounds = true
        addSubview(imageView)

        imageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

