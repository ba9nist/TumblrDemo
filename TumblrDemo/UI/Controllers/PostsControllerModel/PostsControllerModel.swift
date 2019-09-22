//
//  PostsControllerModel.swift
//  TumblrDemo
//
//  Created by ba9nist on 22.09.2019.
//  Copyright © 2019 Home. All rights reserved.
//

import UIKit

typealias PostCellConfigurator = CollectionViewConfigurator<PostCollectionViewCell, Post>
typealias ImageCellConfigurator = CollectionViewConfigurator<ImageCollectionViewCell, UIImage>

class PostsControllerModel {

    var posts = [CellConfigurator]()
    var view: PostsControllerViewProcotol?

    func loadData() {
        view?.showLoader()
        NetworkManager.shared.sendRequest { (response) in
            self.view?.hideLoader()
            guard let response = response else {
                return
            }


            let mappedPosts = response.posts.map({ (post) -> CellConfigurator in
                return PostCellConfigurator(item: post)
            })

            self.posts = [CellConfigurator]()
            self.posts.append(ImageCellConfigurator(item: #imageLiteral(resourceName: "photo")))
            self.posts.append(contentsOf: mappedPosts)

            self.view?.updateTable()
//            response.posts.forEach({print($0.photoset_layout)})
        }
    }


}
