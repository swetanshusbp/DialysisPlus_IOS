//
//  editMealViewModel.swift
//  DialysisPlus
//
//  Created by user1.0 on 23/02/24.
//

import Foundation
import CoreData
final class editMealViewModel: ObservableObject {
    
    @Published var meal : MealData
    
    private let context : NSManagedObjectContext
    
    init(provider: MealDataProvider , meal : MealData? = nil){
        
        self.context = provider.newContext
        self.meal = MealData(context: self.context)
    }
    
    func save() throws {
        
        if context.hasChanges{
            try context.save()
        }
    }
}
