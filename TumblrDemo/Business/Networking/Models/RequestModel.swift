//
//  RequestModel.swift
//  TumblrDemo
//
//  Created by ba9nist on 23.09.2019.
//  Copyright © 2019 Home. All rights reserved.
//

import Foundation

typealias ApiKey = String

class BaseRequestModel {

    private enum ApiKeys: ApiKey {
        case api_key = "api_key"
    }

    private let base_url = "https://api.tumblr.com/v2"
    private let api_key = "7YIR9ao5keQ1mlSFnGJLMuhWkAyBBTYmMKCaQeniTurRrZUsxh"
    open var params = [ApiKey: String]()
    init() {
        params[ApiKeys.api_key.rawValue] = api_key
    }

    func getUrl(_ appendingPath: String? = nil) -> String {
        var url = base_url
        if let path = appendingPath {
            url.append("/")
            url.append(path)
        }

        url.append("?")

        for key in Array(params.keys) {
            if let value = params[key] {
                url.append(key)
                url.append("=")
                url.append(value)
                url.append("&")
            }
        }

        url.removeLast()

        return url
    }
}

class BlogPostsRequestModel: BaseRequestModel {
    enum BlogPostKeys: ApiKey {
        case blogIdentifier = "blog_identifier"
        case offset
        case tag
    }

    private var urlPath: String = ""

    init(blogId: String, offset: Int = 0, tag: String = "") {
        super.init()

        urlPath = "blog/\(blogId)/posts"

        params[BlogPostKeys.offset.rawValue] = offset == 0 ? nil : String(offset)
        params[BlogPostKeys.tag.rawValue] = tag.isEmpty ? nil : tag
    }

    override func getUrl(_ appendingPath: String? = nil) -> String {
        return super.getUrl(urlPath)
    }

}

class TagsRequestModel: BaseRequestModel {
    enum TagsKeys: ApiKey {
        case tag
        case offset
    }

    private var urlPath = "tagged"

    init(tag: String, offset: Int = 0) {
        super.init()
        params[TagsKeys.tag.rawValue] = tag
        params[TagsKeys.offset.rawValue] = offset == 0 ? nil : String(offset)
    }

    override func getUrl(_ appendingPath: String? = nil) -> String {
        return super.getUrl(urlPath)
    }

}
