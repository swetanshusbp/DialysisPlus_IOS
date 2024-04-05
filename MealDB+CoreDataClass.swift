//
//  MealDB+CoreDataClass.swift
//  DialysisPlus
//
//  Created by user1.0 on 23/02/24.
//
//

import Foundation
import CoreData

@objc(MealDB)
public class MealDB: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<MealDB> {
        return NSFetchRequest<MealDB>(entityName: "MealDB")
    }

    @NSManaged public var meal: String?
    @NSManaged public var sodium: Double
    @NSManaged public var potassium: Double
    @NSManaged public var timeStamp: Date?
    @NSManaged public var foodName: String?
}

