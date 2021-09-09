//
//  StorageService.swift
//  VPNTest
//
//  Created by Ara Hakobyan on 08.09.21.
//

import CoreData

protocol StorageServiceProtocol {
    var backgroundContext: NSManagedObjectContext { get }
    func fetchObject<T: NSManagedObject>(_ fetchRequest: NSFetchRequest<T>) throws -> [T]
}

class StorageService: StorageServiceProtocol {
    private let coreDataStack: CoreDataStack
    
    init(coreDataStack: CoreDataStack = .shared) {
        self.coreDataStack = coreDataStack
    }
    
    var backgroundContext: NSManagedObjectContext {
        return coreDataStack.backgroundContext
    }
    
    func fetchObject<T: NSManagedObject>(_ fetchRequest: NSFetchRequest<T>) throws -> [T] {
        let models = try coreDataStack.viewContext.fetch(fetchRequest)
        return models
    }
}
