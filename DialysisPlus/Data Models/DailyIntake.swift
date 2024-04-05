//
//  DailyIntake.swift
//  DialysisPlus
//
//  Created by user1 on 16/01/24.
//

import SwiftUI
import Combine


struct DailyIntake {
    var breakfast: Meal
    var lunch: Meal
    var dinner: Meal
    var snacks: Meal
    var totalPotassium: Double
    var totalSodium: Double
    var above75K : Bool
    var above75Na : Bool
    var totalNa : Double = 2000
    var totalK : Double = 2000
    var notifications: Bool = false
    var darkMode : Bool = false
    var dataAdded : Bool = false
    
    var uK : Double = 0
    var uNa : Double = 0
    mutating func updateTotals() {
        totalPotassium = [breakfast, lunch, dinner, snacks].flatMap { $0.foodItems }.reduce(0) { $0 + $1.potassium }
        totalSodium = [breakfast, lunch, dinner, snacks].flatMap { $0.foodItems }.reduce(0) { $0 + $1.sodium }
        
        if calculatePercentage(consumed: totalPotassium , total: totalK) >= 75 {
            above75K = true
        }
        else{
            above75K = false
        }
        
        if calculatePercentage(consumed: totalSodium , total: totalNa) >= 75 {
            above75Na = true
        }
        else{
            above75Na = false
        }
                
    }
}

enum MealType {
    case breakfast
    case lunch
    case dinner
    case snacks
}

