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

    var searchModel: String = "featured"

    func fetchPosts(by tag: String? = nil, offset: Int = 0, silentLoad: Bool = false) {

        if let tag = tag, !tag.isEmpty {
            searchModel = tag
        }

        let tagsRequest = TagsRequestModel(tag: searchModel, offset: offset)
        print(tagsRequest.getUrl())

        if !silentLoad {
            view?.showLoader()
        }
        
        NetworkManager.shared.sendRequest(model: tagsRequest, handler: TagsResponse()) { (postList, error) in
            guard error == nil else {
                print(error)
                self.view?.hideLoader()
                return
            }

            guard let postList = postList else {
                self.view?.hideLoader()
                return
            }

            if !silentLoad {
                self.posts = [CellConfigurator]()
            }

            let mappedPosts = postList.map({ (post) -> CellConfigurator in
                return PostCellConfigurator(item: post)
            })

            self.posts.append(contentsOf: mappedPosts)

            self.view?.hideLoader()

            self.view?.updateTable()
        }
    }

//    func fetchPosts(by tag: String = "featured") {
////        let tagsRequest = TagsRequestModel(tag: tag, offset: offset)
//        let postRequest = BlogPostsRequestModel(blogId: "themsleeves.tumblr.com")
//        view?.showLoader()
//        NetworkManager.shared.sendRequest(model: postRequest, handler: PostsResponse()) { (response, error) in
//            guard error == nil else {
////                view?.showError(message: error?.localizedDescription)
//                self.view?.hideLoader()
//                print(error)
//                return
//            }
//
//            guard let response = response else {
//                self.view?.hideLoader()
//                return
//            }
//
//            let mappedPosts = response.posts.map({ (post) -> CellConfigurator in
//                return PostCellConfigurator(item: post)
//            })
//
//            self.posts.append(contentsOf: mappedPosts)
//
//            self.view?.hideLoader()
//
//            self.view?.updateTable()
//            response.posts.forEach({print("type: \($0.type)  layout: \($0.trail?.first?.blog)")})
//        }
//    }


}
