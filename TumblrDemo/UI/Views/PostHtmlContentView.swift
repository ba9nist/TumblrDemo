//
//  PostHtmlContentView.swift
//  TumblrDemo
//
//  Created by ba9nist on 22.09.2019.
//  Copyright © 2019 Home. All rights reserved.
//

import UIKit

class PostHtmlContentView: UIView {

    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.delegate = self
        textView.isScrollEnabled = false
        textView.isUserInteractionEnabled = true
        textView.dataDetectorTypes = .link
        textView.font = UIFont.systemFont(ofSize: 15)
        return textView
    }()

    open var htmlText = NSAttributedString(string: "") {
        didSet {
            cachedHeights = [CGFloat: CGFloat]()
            textView.attributedText = htmlText
        }
    }

//    open var htmlText = String() {
//        didSet {
//            cachedHeights = [CGFloat: CGFloat]()
//                if let attributedString = try? NSAttributedString(data: self.htmlText.data(using: .utf16) ?? Data(), options: [NSAttributedString.DocumentReadingOptionKey.documentType : NSAttributedString.DocumentType.html], documentAttributes: nil) {
//                    self.textView.attributedText = attributedString
//
//                } else {
//                    self.textView.text = self.htmlText
//                }
//        }
//    }

    open func reset() {
        htmlText = NSAttributedString(string: "")
    }

    private var cachedHeights = [CGFloat: CGFloat]()
    open func calculateHeight(for width: CGFloat) -> CGFloat {

        if let height = cachedHeights[width] {
            return height
        }

        let size = textView.sizeThatFits(CGSize(width: width, height: CGFloat.infinity))
        cachedHeights[width] = size.height
        return size.height
    }

    private func setupView() {
        addSubview(textView)

        textView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension PostHtmlContentView: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return false
    }

    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        print("shouldInteractWith")
        return true
    }
}
