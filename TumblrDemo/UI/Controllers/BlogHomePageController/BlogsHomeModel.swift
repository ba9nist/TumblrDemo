//
//  BlogsHomeModel.swift
//  TumblrDemo
//
//  Created by ba9nist on 24.09.2019.
//  Copyright © 2019 Home. All rights reserved.
//

import Foundation


class BlogsHomeModel {

    open weak var view: BlogHomePageViewProtocol?
    open var blog: Blog? {
        didSet {
            loadBlogInfo()
            loadBlogPosts()
        }
    }

    open var posts = [CellConfigurator]()
    private var rawPosts = [Post]()

    func loadBlogInfo() {
        if let name = blog?.name {
            let infoModel = BlogInfoRequestModel(blogName: name)

            NetworkManager.shared.sendRequest(model: infoModel, handler: InfoResponse()) { (response, error) in
                guard error == nil else {
                    return
                }

                
            }
        }
    }

    private var isLoading = false
    func loadBlogPosts(offset: Int = 0, appending: Bool = false) {
        guard let blog = blog, !isLoading else { return }

        if !appending {
            view?.showLoader()
        }
        isLoading = true
        let blogsRequest = BlogPostsRequestModel(blogName: blog.name)
        NetworkManager.shared.sendRequest(model: blogsRequest, handler: PostsResponse()) { (response, error) in
            self.isLoading = false
            guard error == nil else {
                self.view?.hideLoader()
                return
            }

            guard let list = response?.posts else {
                self.view?.hideLoader()
                return
            }

            let mappedPosts = list.map({ (post) -> CellConfigurator in
                return PostCellConfigurator(item: post)
            })


            if !appending {
                self.posts = [CellConfigurator]()
                self.rawPosts = [Post]()
            }

            let previoutPostsCount = self.posts.count
            self.posts.append(contentsOf: mappedPosts)
            self.rawPosts.append(contentsOf: list)

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


}
