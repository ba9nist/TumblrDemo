//
//  BaseViewController.swift
//  TumblrDemo
//
//  Created by ba9nist on 22.09.2019.
//  Copyright © 2019 Home. All rights reserved.
//

import UIKit
import BLMultiColorLoader

class BaseViewController: UIViewController {
    private var loader: BLMultiColorLoader = {
        let loader = BLMultiColorLoader(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        loader.backgroundColor = UIColor.black
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.lineWidth = 5
        loader.colorArray = [UIColor.white]
        return loader
    }()

    private lazy var shadowView: UIView = {
        let shadowView = UIView()
        shadowView.alpha = 0.5
        shadowView.backgroundColor = UIColor.black

        shadowView.addSubview(loader)
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.centerXAnchor.constraint(equalTo: shadowView.centerXAnchor).isActive = true
        loader.centerYAnchor.constraint(equalTo: shadowView.centerYAnchor).isActive = true
        loader.widthAnchor.constraint(equalToConstant: 40).isActive = true
        loader.heightAnchor.constraint(equalToConstant: 40).isActive = true

        loader.isHidden = true
        shadowView.isHidden = true
        return shadowView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        initLoader()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if shadowView.isHidden == false {
            loader.startAnimation()
        }
    }

    private func initLoader() {
        view.addSubview(shadowView)

        shadowView.translatesAutoresizingMaskIntoConstraints = false
        shadowView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        shadowView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        shadowView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        shadowView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    func showLoader() {
        DispatchQueue.main.async {
            self.shadowView.isHidden = false
            self.loader.isHidden = false
            self.loader.startAnimation()
        }
    }

    func hideLoader() {
        DispatchQueue.main.async {
            self.shadowView.isHidden = true
            self.loader.isHidden = true
            self.loader.stopAnimation()
        }
    }

}
