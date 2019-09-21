//
//  AppDelegate.swift
//  TumblrDemo
//
//  Created by yevhenii boryspolets on 9/20/19.
//  Copyright © 2019 Home. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)

        let controller = makeInitialController()
        window?.rootViewController = controller

        window?.makeKeyAndVisible()

        return true
    }

    private func makeInitialController() -> UIViewController {
        let controller = PostsController()
        controller.view.backgroundColor = .white

        return UINavigationController(rootViewController: controller)
    }

}

