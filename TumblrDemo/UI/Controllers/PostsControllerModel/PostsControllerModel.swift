//
//  PostsControllerModel.swift
//  TumblrDemo
//
//  Created by ba9nist on 22.09.2019.
//  Copyright © 2019 Home. All rights reserved.
//

import Foundation

typealias PostCellConfigurator = CollectionViewConfigurator<PostCollectionViewCell, Post>
typealias ImageCellConfigurator = CollectionViewConfigurator<ImageCollectionViewCell, URL>

class PostsControllerModel {

    var posts = [CellConfigurator]()
    var view: PostsControllerViewProcotol?

    func fetchPosts(offset: Int = 0) {
        view?.showLoader()
        NetworkManager.shared.sendRequest(offset: offset) { (response) in

            guard let response = response else {
                self.view?.hideLoader()
                return
            }

            let mappedPosts = response.posts.map({ (post) -> CellConfigurator in
                return PostCellConfigurator(item: post)
            })

            self.posts.append(contentsOf: mappedPosts)

            self.view?.hideLoader()

            self.view?.updateTable()
//            response.posts.forEach({print("type: \($0.type)  layout: \($0.photoset_layout)")})
        }
    }



}
