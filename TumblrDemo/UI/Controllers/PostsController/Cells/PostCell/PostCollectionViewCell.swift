//
//  PostCollectionViewCell.swift
//  TumblrDemo
//
//  Created by ba9nist on 22.09.2019.
//  Copyright © 2019 Home. All rights reserved.
//

import UIKit

protocol PostCellDelegate {
    func didClickHeader(_ cell: PostCollectionViewCell)
}

class PostCollectionViewCell: UICollectionViewCell, ConfigurableCell {

    let headerView = PostHeaderView()
    let footerView = FooterView()
    let htmlContent = PostHtmlContentView()
    let photosGrid = PhotosGridView()

    var htmlContentHeightConstraint: NSLayoutConstraint?
    var photosHeightConstraint: NSLayoutConstraint?

    private let insets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    private func setupView() {
        backgroundColor = .white

        addSubview(headerView)
        addSubview(footerView)
        addSubview(htmlContent)
        addSubview(photosGrid)

        headerView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, padding: insets, size: CGSize(width: 0, height: 50))

        photosGrid.anchor(top: headerView.bottomAnchor, left: leftAnchor, right: rightAnchor)

        photosHeightConstraint = photosGrid.heightAnchor.constraint(equalToConstant: 0)
        photosHeightConstraint?.isActive = true

        htmlContent.anchor(top: photosGrid.bottomAnchor, left: leftAnchor, right: rightAnchor)
        htmlContentHeightConstraint = htmlContent.heightAnchor.constraint(equalToConstant: 0)
        htmlContentHeightConstraint?.isActive = true

        footerView.anchor(top: htmlContent.bottomAnchor, left: headerView.leftAnchor, bottom: bottomAnchor, right: headerView.rightAnchor)

    }

    var delegate: PostCellDelegate? {
        didSet {
            headerView.delegate = self
            footerView.delegate = self
        }
    }

    func configure(data post:  Post) {
        resetView()

        footerView.notesLabel.text = "\(post.note_count) notes"

        if let blogInfo = post.trail?.first?.blog {
            headerView.blogTitleLabel.text = blogInfo.name
        }

        if let html = post.trail?.first?.content {
            htmlContent.htmlText = html
        }

        if let photos = post.photos {
            photosGrid.pattern = post.photoset_layout ?? "1" //if have photos and no layout there so show only 1 photo
            photosGrid.images = photos
        }
    }

    private func resetView() {
        photosGrid.reset()
        htmlContent.reset()

        htmlContentHeightConstraint?.constant = 0
        photosHeightConstraint?.constant = 0
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        htmlContentHeightConstraint?.constant = htmlContent.calculateHeight(for: frame.width)
        photosHeightConstraint?.constant = photosGrid.calculateHeight(by: frame.width)
    }

    func calculateHeight(for width: CGFloat) -> CGFloat {
        return 100 + htmlContent.calculateHeight(for: width) + photosGrid.calculateHeight(by: width)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PostCollectionViewCell: PostHeaderViewDelegate {
    func didClickFollow(_ button: UIButton) {

    }

    func didClickClose(_ button: UIButton) {

    }

    func didClickHeader(_ view: PostHeaderView) {
        delegate?.didClickHeader(self)
    }


}

extension PostCollectionViewCell: FooterViewDelegate {
    func didClickLike(_ button: UIButton) {

    }

    func didClickShared(_ button: UIButton) {

    }

    func didClickRepeat(_ button: UIButton) {
        
    }


}
