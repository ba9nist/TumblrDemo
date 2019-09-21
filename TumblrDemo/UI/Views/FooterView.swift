//
//  FooterView.swift
//  TumblrDemo
//
//  Created by yevhenii boryspolets on 9/20/19.
//  Copyright © 2019 Home. All rights reserved.
//

import UIKit
import Rswift

protocol FooterViewDelegate {
    func didClickLike(_ button: UIButton)
    func didClickShared(_ button: UIButton)
    func didClickRepeat(_ button: UIButton)
}

class FooterView: UIView {

    open var delegate: FooterViewDelegate?

    let notesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor.init(named: "textGrayColor")
        label.text = "3 notes"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var sharedButton = self.makeButtonWith(image: R.image.send_icon(), selector: #selector(sharedButtonClicked))
    lazy var likeButton = self.makeButtonWith(image: R.image.like_icon(), selector: #selector(likeButtonClicked))
    lazy var repeatButton: UIButton = self.makeButtonWith(image: R.image.mediaRepeat(), selector: #selector(repeatButtonClicked))

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }

    private func makeButtonWith(image: UIImage?, selector: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = R.color.textGrayColor()
        button.addTarget(self, action: selector, for: .touchUpInside)
        return button
    }
    
    private func setupView() {
        let stackView = UIStackView(arrangedSubviews: [sharedButton, repeatButton, likeButton])
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        addSubview(notesLabel)
        
        notesLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        notesLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        stackView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: notesLabel.rightAnchor).isActive = true
        stackView.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }


    @objc private func repeatButtonClicked() {
        delegate?.didClickRepeat(repeatButton)
    }

    @objc private func sharedButtonClicked() {
        delegate?.didClickShared(sharedButton)
    }

    @objc private func likeButtonClicked() {
        delegate?.didClickLike(likeButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
