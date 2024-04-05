//
//  Meal.swift
//  DialysisPlus
//
//  Created by Meghs on 25/03/24.
//

import Foundation


struct Meal : Identifiable {
    var id = UUID()
    var name: String
    var foodItems: [FoodItem]

    var totalPotassium: Double {
        return foodItems.reduce(0) { $0 + $1.potassium }
    }

    var totalSodium: Double {
        return foodItems.reduce(0) { $0 + $1.sodium }
    }
}


