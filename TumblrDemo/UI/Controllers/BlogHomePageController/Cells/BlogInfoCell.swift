//
//  BlogInfoCell.swift
//  TumblrDemo
//
//  Created by ba9nist on 25.09.2019.
//  Copyright © 2019 Home. All rights reserved.
//

import UIKit

class BlogInfoCell: UICollectionViewCell, ConfigurableCell {

    private let titleLabel: UILabel = {
        let label  = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        return label
    } ()

    private let htmlView = PostHtmlContentView()

    func configure(data: Blog) {
        titleLabel.text = data.title

        if let htmlData = data.description?.data(using: .utf16) {
            if let htmlText = try? NSAttributedString(data: htmlData, options: [NSAttributedString.DocumentReadingOptionKey.documentType : NSAttributedString.DocumentType.html], documentAttributes: nil) {

                htmlView.htmlText = htmlText
            }
        }

    }

    func calculateHeight(for width: CGFloat) -> CGFloat {
        return 52 + htmlView.calculateHeight(for: width)
    }

    private func setupView() {
        backgroundColor = .white

        addSubview(titleLabel)
        addSubview(htmlView)

        titleLabel.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, padding: UIEdgeInsets(top: 32, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 20))
        htmlView.anchor(top: titleLabel.bottomAnchor, left: titleLabel.leftAnchor, bottom: bottomAnchor, right: titleLabel.rightAnchor)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
