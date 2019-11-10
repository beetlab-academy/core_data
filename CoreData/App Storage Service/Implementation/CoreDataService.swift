//
//  CoreDataService.swift
//  CoreData
//
//  Created by nikita on 27/10/2019.
//  Copyright © 2019 nikita. All rights reserved.
//

import Foundation
import CoreData

class Mapper {
    func map(from: PostEntity) -> Post {
        return Post(id: Int(from.id), url: URL(string: from.url ?? "")!, isLiked: from.isLiked)
    }
}

class CoreDataService: NSObject {
    private let contextsQueue = DispatchQueue(label: "coredata.contexts")
    private let mapper = Mapper()
    private let persistentCOntainer = NSPersistentContainer(name: "DataModel")
    private lazy var controller: NSFetchedResultsController<PostEntity> = {
        let fetchRequest: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "url > %@", "fgjfgj")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: persistentCOntainer.viewContext,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        frc.delegate = self
        return frc
    }()
    var subscribers: [AppStorageServiceSubscriber] = []
    
    override init() {
        persistentCOntainer.loadPersistentStores { print("\($0) \($1)") }
        super.init()
        
        try? controller.performFetch()
        print("objects = \(controller.fetchedObjects?.count)")
        
    }
}

extension CoreDataService: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        
        guard let postEntity = anObject as? PostEntity else { return }

        switch type {
                        
        case .delete:
            print("delete \(anObject)")

            break
        case .move:
            print("move \(anObject)")

            break
        case .insert:
            print("inserted \(anObject)")
            break
        case .update:
            print("update \(anObject)")

            break
        }
        
        subscribers.forEach { $0.postChanged(mapper.map(from: postEntity)) }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
    }
}

extension CoreDataService: AppStorageService {
    func update(_ author: Author) {
        let entityDescription = NSEntityDescription.entity(forEntityName: "Author",
                                                           in: persistentCOntainer.viewContext)!
        
        let entity = Author(entity: entityDescription,
                                insertInto: persistentCOntainer.viewContext)
        
        try? persistentCOntainer.viewContext.save()
    }

    func update(_ post: Post) {
        persistentCOntainer.viewContext.automaticallyMergesChangesFromParent = true
        persistentCOntainer.viewContext.mergePolicy = NSMergePolicy.overwrite

        let context = persistentCOntainer.newBackgroundContext()
        let fetchRequest: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id=%d", post.id)
        contextsQueue.async(flags: .barrier) {
            do {
                guard let postEntity = try context.fetch(fetchRequest).first else {
                    print("create")
                    let entityDescription = NSEntityDescription.entity(forEntityName: "PostEntity",
                                                                       in: context)!
                    
                    let entity = PostEntity(entity: entityDescription,
                                            insertInto: context)
                    
                    entity.id = Int64(post.id)
                    entity.url = "swrgegr"
                    entity.isLiked = false
                    
                    try context.save()

                    return
                }
                
                print("update")
                postEntity.url = post.url.absoluteString
                postEntity.isLiked = post.isLiked
                
                try context.save()
            } catch {
                print(error)
            }
        }
       // context.perform {
       // }
        
    }
    
    func loadPosts() -> [Post] {
        let context = persistentCOntainer.newBackgroundContext()
        
        let r: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()//fetchRequest()
        let results = try? persistentCOntainer.viewContext.fetch(r)
        print(results)
        
        
        return []
    }
    
    func subscribe(_ subscriber: AppStorageServiceSubscriber) {
        subscribers.append(subscriber)
    }
}
