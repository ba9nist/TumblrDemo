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

class BlogPostsRequestModel: BlogRequestModel {
    enum BlogPostKeys: ApiKey {
        case offset
        case tag
    }

    private let urlPath: String = "posts"

    init(blogName: String, offset: Int = 0, tag: String = "") {
        super.init(blogName: blogName)

        params[BlogPostKeys.offset.rawValue] = offset == 0 ? nil : String(offset)
        params[BlogPostKeys.tag.rawValue] = tag.isEmpty ? nil : tag
    }

    override func getUrl(_ appendingPath: String? = nil) -> String {
        return super.getUrl(urlPath)
    }

}

class BlogAvatarRequest: BlogRequestModel {
    private var url = "avatar"

    public let sizes = [16, 24, 30, 40, 48, 64, 96, 128, 512]
    init(blogName: String, size: Int = 128) {
        super.init(blogName: blogName)

        var actualSize = 128
        if sizes.contains(size) {
            actualSize = size
        }

        url.append("/\(actualSize)")
    }

    override func getUrl(_ appendingPath: String? = nil) -> String {
        return super.getUrl(url)
    }

}

class BlogInfoRequestModel: BlogRequestModel {

    private let urlMethod = "info"

    override init(blogName: String) {
        super.init(blogName: blogName)
    }

    override func getUrl(_ appendingPath: String? = nil) -> String {
        return super.getUrl(urlMethod)
    }
}

class BlogRequestModel: BaseRequestModel {
    enum BlogKeys: ApiKey {
        case blogIdentifier = "blog_identifier"
    }

    private var urlPath: String = ""

    init(blogName: String) {
        super.init()
        urlPath = "blog/\(blogName).tumblr.com"
    }

    override func getUrl(_ appendingPath: String? = nil) -> String {
        var path = urlPath
        if let appendingPath = appendingPath {
            path.append("/")
            path.append(appendingPath)
        }

        return super.getUrl(path)
    }
}

class TagsRequestModel: BaseRequestModel {
    enum TagsKeys: ApiKey {
        case tag
        case timestamp = "before"
        case featuredTimestamp = "featured_timestamp"
    }

    private var urlPath = "tagged"

    init(tag: String, timestamp: Int = 0) {
        super.init()
        
        params[TagsKeys.tag.rawValue] = tag
        if tag == "featured" {
            params[TagsKeys.featuredTimestamp.rawValue] = String(timestamp)
        } else {
            params[TagsKeys.timestamp.rawValue] = String(timestamp)
        }

    }

    override func getUrl(_ appendingPath: String? = nil) -> String {
        return super.getUrl(urlPath)
    }

}
