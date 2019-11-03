//
//  CoreDataService.swift
//  CoreData
//
//  Created by nikita on 27/10/2019.
//  Copyright © 2019 nikita. All rights reserved.
//

import Foundation
import CoreData

class CoreDataService: NSObject {
    private let persistentCOntainer = NSPersistentContainer(name: "DataModel")
    private lazy var controller: NSFetchedResultsController<PostEntity> = {
        let fetchRequest: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "url > %@", "fgjfgj")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "url", ascending: true)]
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
        subscribers.forEach { $0.postChanged(Post(id: "", url: URL(string: "https://sdfsg")!, isLiked: true)) }
        
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

        let context = persistentCOntainer.newBackgroundContext()
//        persistentCOntainer.performBackgroundTask { context in
            let entityDescription = NSEntityDescription.entity(forEntityName: "PostEntity",
                                                               in: context)!
            
            let entity = PostEntity(entity: entityDescription,
                                    insertInto: context)
            
            entity.url = "swrgegr"
            try? context.save()
//        }
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
