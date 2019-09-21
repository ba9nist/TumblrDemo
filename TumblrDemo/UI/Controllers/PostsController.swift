//
//  PostsController.swift
//  TumblrDemo
//
//  Created by ba9nist on 21.09.2019.
//  Copyright © 2019 Home. All rights reserved.
//

import UIKit

class PostsController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    private func setupView() {

        let testView = PostHeaderView()
        let testView1 = FooterView()

        view.addSubview(testView)
        view.addSubview(testView1)
        testView.translatesAutoresizingMaskIntoConstraints = false

        testView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        testView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        testView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        testView.heightAnchor.constraint(equalToConstant: 50).isActive = true

        testView1.translatesAutoresizingMaskIntoConstraints = false

        testView1.topAnchor.constraint(equalTo: testView.bottomAnchor, constant: 0).isActive = true
        testView1.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        testView1.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        testView1.heightAnchor.constraint(equalToConstant: 50).isActive = true

    }

}
