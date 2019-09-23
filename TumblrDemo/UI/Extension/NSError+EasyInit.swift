//
//  NSError+EasyInit.swift
//
//  Created by yevhenii boryspolets on 9/17/18.
//  Copyright © 2018 Home. All rights reserved.
//

import Foundation

extension NSError {
    convenience init(code: Int, message: String) {
        self.init(domain: Bundle.main.bundleIdentifier!, code: code, userInfo: [NSLocalizedDescriptionKey: message])
    }    
    
}
