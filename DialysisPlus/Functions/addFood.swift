//
//  addFood.swift
//  DialysisPlus
//
//  Created by user1 on 17/01/24.
//

import Foundation
import SwiftUI


func addFood(title : String , foodName : String , potassiumContent : Double , sodiumContent : Double,DailyIntakeManager: dailyIntakeManager) {

    
    if title == "Breakfast" {
        
        let food = FoodItem(name: foodName, potassium: potassiumContent, sodium: sodiumContent)
        
        DailyIntakeManager.addFoodItem(mealType: .breakfast, foodItem: food)
    }
    
    
    if title == "Lunch" {
        
        let food = FoodItem(name: foodName, potassium: potassiumContent, sodium: sodiumContent)
        
        DailyIntakeManager.addFoodItem(mealType: .lunch, foodItem: food)
    }
    
    
    if title == "Dinner" {
        
        let food = FoodItem(name: foodName, potassium: potassiumContent, sodium: sodiumContent)
        
        DailyIntakeManager.addFoodItem(mealType: .dinner, foodItem: food)
    }
    
    
    
    if title == "Snacks" {
        
        let food = FoodItem(name: foodName, potassium: potassiumContent, sodium: sodiumContent)
        
        DailyIntakeManager.addFoodItem(mealType: .snacks, foodItem: food)
    }
    
}
