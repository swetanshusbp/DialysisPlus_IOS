//
//  apiIngredients.swift
//  FoodTracking
//
//  Created by user1.0 on 21/02/24.
//

import Foundation

struct Ingredient: Identifiable {
  let id = UUID()
  let name: String
  var quantity: String?
  var sodium : Double?
  var potassium : Double?
}

class Ingredients : ObservableObject{
    @Published var ingredients: [Ingredient] = []
    @Published var totalSodium: Double = 0
    @Published var totalPotassium: Double = 0
    
    
    func addIngredient(ingredient : Ingredient){
        ingredients.append(ingredient)
        recalculateValues()
    }
    
    func addIngredients(_ jsonString : String){
        guard let jsonData = jsonString.data(using: .utf8) else {
            print("Failed to convert JSON string to data")
            return
        }
    }
    
    func parseJSONString(_ jsonString: String) {
        guard let jsonData = jsonString.data(using: .utf8) else {
            print("Failed to convert JSON string to data")
            return
        }
        
        do {
            // Decode the JSON data into a Swift object
            let decodedData = try JSONDecoder().decode([String: [[String: String?]]].self, from: jsonData)
        
            
            guard let ingredientsArray = decodedData["ingredients"] else {
                print("Failed to extract ingredients array")
                return
            }

            for ingredientData in ingredientsArray {
   
                guard let name = ingredientData["name"] as? String,
                      let quantity = ingredientData["quantity"] as? String,
                      let sodiumString = ingredientData["sodium"] as? String,
                      let sodium = Double(sodiumString.components(separatedBy: CharacterSet.decimalDigits.inverted)
                        .joined()),
                      let potassiumString = ingredientData["potassium"] as? String,
                      let potassium = Double(potassiumString.components(separatedBy: CharacterSet.decimalDigits.inverted)
                        .joined()) else {
                    print("Failed to extract values for ingredient")
                    continue
                }
  
                let ingredient = Ingredient(name: name, quantity: quantity, sodium: sodium, potassium: potassium)
                ingredients.append(ingredient)
                totalSodium += sodium
                totalPotassium += potassium
                
                print("Done")
            
            }
        } catch {
            print("Error decoding JSON:", error)
        }
    }
    
    func recalculateValues() {
        totalSodium = ingredients.reduce(0) { $0 + ($1.sodium ?? 0.0) }
                totalPotassium = ingredients.reduce(0) { $0 + ($1.potassium ?? 0.0) }
       }
    

}
