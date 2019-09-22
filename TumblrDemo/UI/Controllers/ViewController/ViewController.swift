//
//  ViewController.swift
//  TumblrDemo
//
//  Created by ba9nist on 22.09.2019.
//  Copyright © 2019 Home. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        let collection = PhotosGridView(frame: CGRect(x: 0, y: 100, width: view.frame.width, height: 200))
        collection.pattern = "13211"
        view.addSubview(collection)
    }


}


