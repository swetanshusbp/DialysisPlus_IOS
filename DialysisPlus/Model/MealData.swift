//
//  MealData.swift
//  DialysisPlus
//
//  Created by user1.0 on 23/02/24.
//

import Foundation
import CoreData

final class MealData: NSManagedObject{
    
    @NSManaged var food : String
    @NSManaged var meal : String
    @NSManaged var potassium : Double
    @NSManaged var sodium : Double
    @NSManaged var timeStamp : Date
    
    override func awakeFromInsert() {
        super.awakeFromInsert()
        
        setPrimitiveValue(Date.now, forKey: "timeStamp")
        setPrimitiveValue(0.0, forKey: "potassium")
        setPrimitiveValue(0.0, forKey: "sodium")
    }
}
