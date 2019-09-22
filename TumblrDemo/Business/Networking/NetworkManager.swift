//
//  NetworkManager.swift
//  TumblrDemo
//
//  Created by ba9nist on 21.09.2019.
//  Copyright © 2019 Home. All rights reserved.
//

import Foundation
import Alamofire


class NetworkManager: NSObject {
    private let api_key = "7YIR9ao5keQ1mlSFnGJLMuhWkAyBBTYmMKCaQeniTurRrZUsxh"

    static let shared = NetworkManager()
    override init() {
        super.init()
    }

    func sendRequest(completion: @escaping (PostsResponse?) -> Void) {
//        https://api.tumblr.com/v2/blog/themsleeves.tumblr.com/posts?api_key=7YIR9ao5keQ1mlSFnGJLMuhWkAyBBTYmMKCaQeniTurRrZUsxh
//        let url = "https://api.tumblr.com/v2/tagged?tag=gif" + "&api_key=\(api_key)"

        let url = "https://api.tumblr.com/v2/blog/themsleeves.tumblr.com/posts?api_key=\(api_key)"

        Alamofire.request(url, method: .get).responseData { (responseData) in
            guard let data = responseData.data else {
                print("error getting data")
                completion(nil)
                return
//                completion(nil, NSError(domain: "test", code: 666, userInfo: [NSErrorDescripti]))
            }

            do {

                let response = try JSONDecoder().decode(Response.self, from: data)
                completion(response.response)
//                print(response)
//                for post in response.response {
//                    print("name = \(post.blog.name) type = \(post.type)")
//                }

            } catch {
                print(error)
                completion(nil)
            }
        }
    }


}

