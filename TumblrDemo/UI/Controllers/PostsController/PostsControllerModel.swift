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

    private var searchModel: String = "gif"
    private var lastPostTimestamp: Int = 0

    func fetchPosts(by tag: String? = nil, appending: Bool = false) {

        if let tag = tag, !tag.isEmpty {
            searchModel = tag
        }

        let tagsRequest = appending ? TagsRequestModel(tag: searchModel, timestamp: lastPostTimestamp) : TagsRequestModel(tag: searchModel)
        print(tagsRequest.getUrl())


        if !appending {
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

            if !appending {
                self.posts = [CellConfigurator]()
            }

            self.lastPostTimestamp = postList[postList.count - 1].timestamp

            let mappedPosts = postList.map({ (post) -> CellConfigurator in
                return PostCellConfigurator(item: post)
            })

            let previoutPostsCount = self.posts.count
            self.posts.append(contentsOf: mappedPosts)

            self.view?.hideLoader()

            if appending {
                var indexPaths = [IndexPath]()
                for index in previoutPostsCount..<previoutPostsCount + mappedPosts.count {
                    indexPaths.append(IndexPath(item: index, section: 0))
                }
                self.view?.insertItems(indexPaths)
            } else {
                self.view?.reloadTable()
            }
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
