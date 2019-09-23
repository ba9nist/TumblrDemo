//
//  NetworkManager.swift
//  TumblrDemo
//
//  Created by ba9nist on 21.09.2019.
//  Copyright © 2019 Home. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

class NetworkManager: NSObject {


    private let api_key = "7YIR9ao5keQ1mlSFnGJLMuhWkAyBBTYmMKCaQeniTurRrZUsxh"

    private let cache = NSCache<NSURL, NSData>()

    static let shared = NetworkManager()
    override init() {
        super.init()
    }


    func processResponse() {
    }


    func sendRequest<T>(model: BaseRequestModel, handler: T, completion: @escaping (T?, Error?) -> Void) where T: Decodable {

        Alamofire.request(model.getUrl(), method: .get)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in

                switch response.result {
                case .success:
                    print("success")
                    if let data = response.data {
                        do {

                            let result = try JSONDecoder().decode(TumblrResponse<T>.self, from: data)
                            completion(result.response as T, nil)
//                            print(result.response)
//                            print(result.response.posts)
//                            completion(result.response, nil)
                        } catch {
                            print("decoding error")
                            completion(nil, error)
                        }
                    }
//                    self.processResponse()
//                    processResponse(response)
//                    let result = try JSONDecoder().decode(Response.self, from: data)
//                    completion(response.response)
                case let .failure(error):
                    completion(nil, error)
                }

//                do {
//
//
//                } catch {
//                    print(error)
//                    completion(nil)
//                }
        }
    }


    func loadImage(url: URL, completion: @escaping (Data?) -> Void) {

        if let imageData = cache.object(forKey: url as NSURL) {
            completion(imageData as Data)
            return
        }

        Alamofire.request(url).responseData { response in
//            print("finish image request")

            if let imageData =  response.result.value {
                self.cache.setObject(imageData as NSData, forKey: url as NSURL)
            }
            completion(response.result.value)
        }
    }

}

