//
//  AppDelegate.swift
//  CoreData
//
//  Created by nikita on 27/10/2019.
//  Copyright © 2019 nikita. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let service = CoreDataService()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        service.update(Post(id: 12, url: URL(string: "https://google.com")!, isLiked: false))
//        service.update(Post(id: 12, url: URL(string: "https://google.com")!, isLiked: true))
//        service.update(Post(id: 12, url: URL(string: "sef")!, isLiked: true))
//        service.loadPosts()

        // Override point for customization after application launch.
        return true
    }
}

