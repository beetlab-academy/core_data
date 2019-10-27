//
//  CoreDataService.swift
//  CoreData
//
//  Created by nikita on 27/10/2019.
//  Copyright © 2019 nikita. All rights reserved.
//

import Foundation
import CoreData

class CoreDataService {
    
    init() {
        
    }
}

extension CoreDataService: AppStorageService {
    func update(_ post: Post) {
        
    }
    
    func loadPosts() -> [Post] {
        return []
    }
    
    func subscribe(_ subscriber: AppStorageServiceSubscriber) {
        
    }
}
