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
    private var gradientLayer: CAGradientLayer?
    private lazy var gradientView: UIView = {
        let view = UIView()

        gradientLayer  = CAGradientLayer()
        gradientLayer?.colors = [R.color.gradientStart()!.cgColor, R.color.gradientEnd()!.cgColor]
        gradientLayer?.type = .axial
        gradientLayer?.startPoint = CGPoint(x: 0, y: 1)
        gradientLayer?.endPoint = CGPoint(x: 1, y: 0)

        view.layer.addSublayer(gradientLayer!)

        return view
    }()

    private let imageView: FLAnimatedImageView = {
        let imageView = FLAnimatedImageView()
        imageView.contentMode = UIImageView.ContentMode.scaleAspectFit
        return imageView
    }()

    private var url: URL?
    func configure(data url: URL) {
        self.url = url
        imageView.image = nil
        imageView.animatedImage = nil

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
        addSubview(gradientView)
        addSubview(imageView)

        imageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        gradientView.anchor(top: imageView.topAnchor, left: imageView.leftAnchor, bottom: imageView.bottomAnchor, right: imageView.rightAnchor)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        gradientLayer?.frame = gradientView.frame
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
