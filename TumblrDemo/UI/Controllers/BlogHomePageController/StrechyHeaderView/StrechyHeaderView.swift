//
//  StrechyHeaderView.swift
//  TumblrDemo
//
//  Created by ba9nist on 24.09.2019.
//  Copyright © 2019 Home. All rights reserved.
//

import UIKit
import FLAnimatedImage

protocol StrechyHeaderViewDelegate: class {
    func didClickOnAvatarImage(_ view: StrechyHeaderView)
}

class StrechyHeaderView: UICollectionReusableView {

    private var imageView: FLAnimatedImageView = {
        let imageView = FLAnimatedImageView()
        imageView.contentMode = UIImageView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    public lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.cgColor

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(avatarImageClicked))
        imageView.addGestureRecognizer(tapGesture)
        return imageView
    }()

    private var theme: Theme?

    public weak var delegate: StrechyHeaderViewDelegate?
    open func configure(with theme: Theme?, avatarUrl: URL?) {
        self.theme = theme

        if let theme = theme {
            loadImage(from: theme.header_image) { (url, imageData) in
                let image = FLAnimatedImage(gifData: imageData)
                if url.pathExtension == "gif" {
                    self.imageView.animatedImage = image
                } else {
                    self.imageView.image = UIImage(data: imageData)
                }
            }

            loadImage(from: avatarUrl) { (url, imageData) in
                self.avatarImageView.image = UIImage(data: imageData)
            }

            self.layoutSubviews()
            defaultRatio = avatarImageView.frame.height / frame.height

            switch theme.avatar_shape {
            case "circle":
                print("setup corners \(avatarImageView.frame)")
                avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
            case "square":
                avatarImageView.layer.cornerRadius = 0
            default:
                break
            }
        }
    }

    @objc func avatarImageClicked() {
        delegate?.didClickOnAvatarImage(self)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        avatarImageView.alpha = calculateAvatarAlpha()
    }

    var defaultRatio: CGFloat = 0
    var maxRatio = CGFloat(0.55)
    func calculateAvatarAlpha() -> CGFloat {
        let ratio = avatarImageView.frame.height / frame.height
        let alpha = 1 - abs(ratio - defaultRatio)/abs(maxRatio - defaultRatio)
        return max(0, alpha)
    }


    private func loadImage(from url: URL?, block: @escaping (_ url: URL, _ imageData: Data) -> Void) {
        if let url = url {
            NetworkManager.shared.loadImage(url: url) { (imageData) in
                guard let imageData = imageData else { return }
                DispatchQueue.main.async {
                    block(url, imageData)
                }
            }
        }
    }

    private func setupView() {
        addSubview(imageView)
        addSubview(avatarImageView)

        imageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        avatarImageView.anchor(size: CGSize(width: 75, height: 75))
        avatarImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 16).isActive = true
        avatarImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

