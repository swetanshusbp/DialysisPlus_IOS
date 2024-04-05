//
//  dailyIntakeManager.swift
//  DialysisPlus
//
//  Created by user1 on 17/01/24.
//
import Combine
import Foundation
import SwiftUI

// ObservableObject to track the state of the slide-up view
class SlideUpState: ObservableObject {
    @Published var isPresented: Bool = false 
}


class dailyIntakeManager: ObservableObject {
    @Published var dailyIntake: DailyIntake // Published property to store the daily intake data

    init() {
        // Initialize meals with empty food items
        let breakfast = Meal(name: "Breakfast", foodItems: [])
        let lunch = Meal(name: "Lunch", foodItems: [])
        let dinner = Meal(name: "Dinner", foodItems: [])
        let snacks = Meal(name: "Snacks", foodItems: [])

        // Initialize daily intake with the provided meals and initial values for potassium, sodium, and flags
        self.dailyIntake = DailyIntake(
            breakfast: breakfast,
            lunch: lunch,
            dinner: dinner,
            snacks: snacks,
            totalPotassium: 0,
            totalSodium: 0,
            above75K: false,
            above75Na: false
        )
    }

    // Method to add a food item to the specified meal
    func addFoodItem(mealType: MealType, foodItem: FoodItem) {
        switch mealType {
        case .breakfast:
            dailyIntake.breakfast.foodItems.append(foodItem)
        case .lunch:
            dailyIntake.lunch.foodItems.append(foodItem)
        case .dinner:
            dailyIntake.dinner.foodItems.append(foodItem)
        case .snacks:
            dailyIntake.snacks.foodItems.append(foodItem)
        }

        dailyIntake.updateTotals() // Update totals after adding the food item
    }
    
    // Method to delete a food item from the specified meal
    func deleteFoodItem(mealType: MealType, index: Int) {
        var meal: Meal
            
        switch mealType {
        case .breakfast:
            meal = dailyIntake.breakfast
        case .lunch:
            meal = dailyIntake.lunch
        case .dinner:
            meal = dailyIntake.dinner
        case .snacks:
            meal = dailyIntake.snacks
        }

        guard index >= 0, index < meal.foodItems.count else {
            return
        }

        meal.foodItems.remove(at: index) // Remove the food item from the meal's food items
        
        dailyIntake.updateTotals() // Update totals after removing the food item
    }
}
