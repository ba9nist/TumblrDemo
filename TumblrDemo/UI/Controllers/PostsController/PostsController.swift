//
//  PostsController.swift
//  TumblrDemo
//
//  Created by ba9nist on 21.09.2019.
//  Copyright © 2019 Home. All rights reserved.
//

import UIKit

protocol PostsControllerViewProcotol {

    func showLoader()
    func hideLoader()
    func updateTable()
    func showError(message: String)

}

class PostsController: BaseViewController {

    lazy var model: PostsControllerModel = {
        let model = PostsControllerModel()
        model.view = self
        return model
    }()

    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = UICollectionView.ScrollDirection.vertical

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        collectionView.backgroundColor = .clear
        collectionView.contentInset = .zero

        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCellConfigurator.reuseIdentifier)
        collectionView.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: PostCellConfigurator.reuseIdentifier)

        return collectionView
    }()

    lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchBar.delegate = self
        controller.obscuresBackgroundDuringPresentation = false
        controller.searchBar.placeholder = NSLocalizedString("Search Posts", comment: "SearchController placeholder")

        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        model.fetchPosts()
    }

    private func setupView() {
        view.backgroundColor = R.color.backgroundColor()
        setupNavigationBar()

        view.addSubview(collectionView)
        collectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
    }

    private func setupNavigationBar() {
        title = "Tumblr"

        navigationController?.navigationBar.barTintColor = R.color.backgroundColor()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                                   NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 21)]
        navigationController?.navigationBar.barStyle = .blackTranslucent
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        definesPresentationContext = true
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}

extension PostsController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.posts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let item = model.posts[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: type(of: item).reuseIdentifier, for: indexPath)

        cell.backgroundColor = .white
        item.configure(cell: cell)

        return cell
    }
}

extension PostsController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = model.posts[indexPath.item]
        return CGSize(width: collectionView.frame.width, height: item.calculateHeight(width: collectionView.frame.width))
    }
}

extension PostsController: PostsControllerViewProcotol {
    func showError(message: String) {
        
    }


    func updateTable() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }



}

extension PostsController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if let path = indexPaths.last, path.item == model.posts.count - 3 {
            model.fetchPosts(offset: model.posts.count, silentLoad: true)
        }
    }

}

extension PostsController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if let text = searchController.searchBar.text {
            model.fetchPosts(by: text)
        }
    }
}
