//
//  PostsResponse.swift
//  TumblrDemo
//
//  Created by ba9nist on 21.09.2019.
//  Copyright © 2019 Home. All rights reserved.
//

import Foundation

struct Meta: Decodable {
    var status: Int
    var msg: String
}

struct Theme: Decodable {
    var avatar_shape: String
    var background_color: String
    var title_color: String?
    var body_font: String

    var header_image: URL?
    var header_full_height: Int?
}

struct Blog: Decodable {
    var description: String?
    var name: String
    var title: String?
    var url: URL?
    var uuid: String?
    var updated: Int64?

    var theme: Theme?
}

struct Post: Decodable {
    var type: String
    var blog_name: String
    var id: Int64
    var timestamp: Int
    var tags: [String]
    var format: String //html....
    var note_count: Int
    var trail: [Trail]?

    var photoset_layout: String?
    var photos: [Photo]?

    var can_like: Bool
    var can_reply: Bool
    var display_avatar: Bool
    var can_send_in_message: Bool
    var can_reblog: Bool
}

struct Photo: Decodable {
    var caption: String
    var original_size: PhotoInfo
    var alt_sizes: [PhotoInfo]
}

struct PhotoInfo: Decodable {
    var url: URL
    var width: Int
    var height: Int
}

struct Trail: Decodable {
//var blog: BLOG with theme
    var content: NSAttributedString = NSAttributedString(string: "")
    var blog: Blog?

    enum CodingKeys: String, CodingKey {
        case content
        case blog
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let htmlText = try container.decode(String.self, forKey: .content)

        if let htmlData = htmlText.data(using: .utf16) {
            content = try NSAttributedString(data: htmlData, options: [NSAttributedString.DocumentReadingOptionKey.documentType : NSAttributedString.DocumentType.html], documentAttributes: nil)
        }

        blog = try container.decode(Blog.self, forKey: .blog)

    }

}

typealias TagsResponse = [Post]

struct InfoResponse: Decodable {
    var blog: Blog?
}

struct PostsResponse: Decodable {
    var blog: Blog?
    var posts: [Post] = [Post]()
    var total_posts: Int = 0
    //_links
}

struct TumblrResponse<T: Decodable>: Decodable {
    var meta: Meta
    var response: T

}
