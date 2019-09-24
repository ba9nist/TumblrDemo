//
//  BlogHomePageController.swift
//  TumblrDemo
//
//  Created by ba9nist on 24.09.2019.
//  Copyright © 2019 Home. All rights reserved.
//

import UIKit

protocol BlogHomePageViewProtocol: class {
    func reloadTable()
    func insertItems(_ indexPath: [IndexPath])
    func showLoader()
    func hideLoader()
}

class BlogHomePageController: BaseViewController {
    private let headerReuseIdentifier = "headerIdentifier"
    var blog: Blog? {
        didSet {
            model.blog = blog
        }
    }

    private lazy var collectionView: UICollectionView = {
        let layout = StretchHeaderFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.backgroundColor = .white
        collectionView.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: PostCellConfigurator.reuseIdentifier)
        collectionView.register(StrechyHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier)

        return collectionView
    }()

    private lazy var model: BlogsHomeModel = {
        let model = BlogsHomeModel()
        model.view = self
        return model
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        setupNavigation()

        view.addSubview(collectionView)
        collectionView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor
            , right: view.rightAnchor)

        setupTheme()
    }

    private func setupTheme() {
//        print(blog?.theme)
        guard let theme = blog?.theme else { return }

        var rawColor = theme.background_color
        rawColor.remove(at: rawColor.startIndex)

        print("rawColor = \(rawColor)")
        if let colorInt = Int(rawColor, radix: 16) {
            print(colorInt)
            collectionView.backgroundColor = UIColor(hexRgb: colorInt)
        }
        
    }

    private func setupNavigation() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        self.navigationController?.navigationBar.tintColor = .white

    }

}

extension BlogHomePageController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = model.posts[indexPath.item]
        return CGSize(width: collectionView.frame.width, height: item.calculateHeight(width: collectionView.frame.width))
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

        return CGSize(width: collectionView.frame.width, height: 120)
    }
}

extension BlogHomePageController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.posts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = model.posts[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: type(of: item).reuseIdentifier, for: indexPath)

        item.configure(cell: cell)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerReuseIdentifier, for: indexPath) as! StrechyHeaderView

        var avatarModel: BlogAvatarRequest?
        if let name = blog?.name {
            avatarModel = BlogAvatarRequest(blogName: name, size: 96)
        }

        let url = URL(string: avatarModel?.getUrl() ?? "")
        header.configure(with: blog?.theme, avatarUrl: url)
        return header
    }

}

extension BlogHomePageController: BlogHomePageViewProtocol {
    func reloadTable() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

    func insertItems(_ indexPath: [IndexPath]) {
        DispatchQueue.main.async {
            self.collectionView.insertItems(at: indexPath)
        }
    }

}
