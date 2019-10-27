//
//  AppStorageService.swift
//  CoreData
//
//  Created by nikita on 27/10/2019.
//  Copyright © 2019 nikita. All rights reserved.
//

import Foundation

struct Post {
    let id: String
    let url: URL
    let isLiked: Bool
}
 
protocol AppStorageServiceSubscriber {
    func postChanged(_ post: Post)
}

protocol AppStorageService {
    func update(_ post: Post)
    func loadPosts() -> [Post]
    func subscribe(_ subscriber: AppStorageServiceSubscriber)
}
