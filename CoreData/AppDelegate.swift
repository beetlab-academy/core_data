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
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let service = CoreDataService()
        service.update(Post(id: "", url: URL(string: "https://google.com")!, isLiked: false))
        service.loadPosts()

        // Override point for customization after application launch.
        return true
    }
}

