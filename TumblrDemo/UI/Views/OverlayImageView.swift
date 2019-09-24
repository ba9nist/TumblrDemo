//
//  OverlayImageView.swift
//  TumblrDemo
//
//  Created by ba9nist on 24.09.2019.
//  Copyright © 2019 Home. All rights reserved.
//

import UIKit
import FLAnimatedImage

class OverlayImageView: UIView {

    private let imageView: FLAnimatedImageView = {
        let imageView = FLAnimatedImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var fadedView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 1

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        view.addGestureRecognizer(tapGesture)

        return view
    }()

    private var initialFrame = CGRect.zero

    @objc private func backgroundTapped() {
        self.animateImageDisappear()
    }

    open func configure(with initialFrame: CGRect, initial url: URL?, finalUrl: URL?) {
        self.initialFrame = initialFrame

        imageView.frame = initialFrame
        fadedView.alpha = 0

        loadImage(from: url) { (url, imageData) in
            self.setupImage(from: url, with: imageData)
            self.animateImageAppear()
        }

        loadImage(from: finalUrl) { (url, imageData) in
            self.setupImage(from: url, with: imageData)
        }
    }

    private func setupImage(from url: URL,with imageData: Data) {
        if url.pathExtension == "gif" {
            self.imageView.animatedImage = FLAnimatedImage(gifData: imageData)
        } else {
            self.imageView.image = UIImage(data: imageData)
        }
    }

    private func animateImageDisappear() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseIn, animations: {
            self.fadedView.alpha = 0
            self.imageView.frame = self.initialFrame

        }, completion:  { _ in 
            self.removeFromSuperview()
        })
    }

    private func animateImageAppear() {
        let resultHeight = imageView.frame.width / frame.width * frame.height
        let imageY = frame.height / 2 - resultHeight / 2

        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
            self.fadedView.alpha = 1.0
            self.imageView.frame = CGRect(x: 0, y: imageY, width: self.frame.width, height: resultHeight)
        })
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
        addSubview(fadedView)
        addSubview(imageView)

        fadedView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
