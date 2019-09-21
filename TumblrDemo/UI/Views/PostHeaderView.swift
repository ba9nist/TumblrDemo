//
//  PostHeaderView.swift
//  TumblrDemo
//
//  Created by ba9nist on 21.09.2019.
//  Copyright © 2019 Home. All rights reserved.
//

import UIKit

protocol PostHeaderViewDelegate {
    func didClickFollow( _ button: UIButton)
    func didClickClose(_ button: UIButton)
    func didClickHeader(_ view: PostHeaderView)
}

class PostHeaderView: UIView {

    var blogIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.image.blogIcon()
        imageView.contentMode = UIImageView.ContentMode.scaleAspectFill
        imageView.isUserInteractionEnabled = true

        return imageView
    }()

    lazy var followButton: UIButton = {
        let button = UIButton(type: .system)
        let title = NSLocalizedString("Follow", comment: "Post header follow button text")
        button.setTitle(title, for: .normal)
        button.tintColor = R.color.followButtonColor()
        button.addTarget(self, action: #selector(followButtonClicked), for: .touchUpInside)
        return button
    }()

    let blogTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "hellocoding"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()

    lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(R.image.closeIcon()?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(closeButtonClicked), for: .touchUpInside)
        return button
    }()

    open var delegate: PostHeaderViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    private func setupView() {
        [blogIconImageView, blogTitleLabel, followButton, closeButton].forEach({addSubview($0)})

        blogIconImageView.anchor(left: leftAnchor, size: CGSize(width: 30, height: 30))
        blogIconImageView.center(centerY: centerYAnchor)

        blogTitleLabel.anchor(left: blogIconImageView.rightAnchor, padding: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0))
        blogTitleLabel.center(centerY: centerYAnchor)

        followButton.center(centerY: centerYAnchor)
        followButton.anchor(left: blogTitleLabel.rightAnchor, padding: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0))

        closeButton.center(centerY: centerYAnchor)
        closeButton.anchor(right: rightAnchor)

        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewDidTap)))
    }

    @objc private func followButtonClicked() {
        delegate?.didClickFollow(followButton)
    }

    @objc private func closeButtonClicked() {
        delegate?.didClickClose(closeButton)
    }

    @objc private func viewDidTap() {
        delegate?.didClickHeader(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
