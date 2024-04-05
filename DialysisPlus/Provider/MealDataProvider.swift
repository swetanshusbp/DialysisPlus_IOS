//
//  MealDataProvider.swift
//  DialysisPlus
//
//  Created by user1.0 on 23/02/24.
//

import Foundation
import CoreData

final class MealDataProvider {
    
    static let shared = MealDataProvider()
    private let persistentContainer: NSPersistentContainer
    
    var viewContext : NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    var newContext : NSManagedObjectContext {
        persistentContainer.newBackgroundContext()
    }
    private init(){
        
        persistentContainer = NSPersistentContainer(name: "DataBaseModel")
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        persistentContainer.loadPersistentStores { _, error in
            if let error {
                fatalError("Unable to load store with error : \(error)")
            }
        }
    }
}
