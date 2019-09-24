//
//  PostsControllerModel.swift
//  TumblrDemo
//
//  Created by ba9nist on 22.09.2019.
//  Copyright © 2019 Home. All rights reserved.
//

import Foundation

protocol ImageCellDelegate {
    
}

typealias PostCellConfigurator = CollectionViewConfigurator<PostCollectionViewCell, Post>
typealias ImageCellConfigurator = CollectionViewConfigurator<ImageCollectionViewCell, URL>

class PostsControllerModel {

    open var posts = [CellConfigurator]()
    open weak var view: PostsControllerViewProcotol?

    private var rawPosts = [Post]()
    private var searchModel: String = "gif"
    private var lastPostTimestamp: Int = 0

    private var isLoading = false
    func fetchPosts(by tag: String? = nil, appending: Bool = false) {
        guard !isLoading else { return }
        if let tag = tag, !tag.isEmpty {
            searchModel = tag
        }

        let tagsRequest = appending ? TagsRequestModel(tag: searchModel, timestamp: lastPostTimestamp) : TagsRequestModel(tag: searchModel)
        print(tagsRequest.getUrl())


        if !appending {
            view?.showLoader()
        }

        isLoading = true
        NetworkManager.shared.sendRequest(model: tagsRequest, handler: TagsResponse()) { (postList, error) in
            self.isLoading = false
            guard error == nil else {
                self.view?.hideLoader()
                return
            }

            guard let postList = postList else {
                self.view?.hideLoader()
                return
            }

            if !appending {
                self.posts = [CellConfigurator]()
                self.rawPosts = [Post]()
            }

            self.lastPostTimestamp = postList[postList.count - 1].timestamp

            let mappedPosts = postList.map({ (post) -> CellConfigurator in
                return PostCellConfigurator(item: post)
            })

            let previoutPostsCount = self.posts.count
            self.posts.append(contentsOf: mappedPosts)
            self.rawPosts.append(contentsOf: postList)

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

    func getBlog(by index: Int) -> Blog? {
        let post = rawPosts[index]

        return post.trail?.first?.blog
    }

}
